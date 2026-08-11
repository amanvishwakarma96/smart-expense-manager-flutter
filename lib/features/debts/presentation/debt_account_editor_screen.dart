import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/services/debt_reminder_service.dart';

class DebtAccountEditorScreen extends ConsumerStatefulWidget {
  const DebtAccountEditorScreen({super.key, this.account});

  final DebtAccount? account;

  @override
  ConsumerState<DebtAccountEditorScreen> createState() =>
      _DebtAccountEditorScreenState();
}

class _DebtAccountEditorScreenState
    extends ConsumerState<DebtAccountEditorScreen> {
  static final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  late final TextEditingController _counterpartyController;
  late final TextEditingController _balanceController;
  late final TextEditingController _noteController;
  late DebtKind _kind;
  DateTime? _dueDate;
  bool _reminderEnabled = false;
  int _reminderDaysBefore = 1;
  String? _errorText;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final DebtAccount? account = widget.account;
    _kind = account?.kind ?? DebtKind.borrowed;
    _counterpartyController = TextEditingController(
      text: account?.counterparty ?? '',
    );
    _balanceController = TextEditingController(
      text: account == null ? '' : account.openingBalance.toStringAsFixed(0),
    );
    _noteController = TextEditingController(text: account?.note ?? '');
    _dueDate = account?.dueDate;
    _reminderEnabled = account?.reminderEnabled ?? false;
    _reminderDaysBefore = account?.reminderDaysBefore ?? 1;
  }

  @override
  void dispose() {
    _counterpartyController.dispose();
    _balanceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate() async {
    final DateTime now = DateTime.now();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now.add(const Duration(days: 30)),
      firstDate: DateTime(2000),
      lastDate: DateTime(now.year + 30),
    );
    if (selected != null && mounted) {
      setState(() => _dueDate = selected);
    }
  }

  Future<void> _save() async {
    final String counterparty = _counterpartyController.text.trim();
    final double? openingBalance = double.tryParse(
      _balanceController.text.trim().replaceAll(',', ''),
    );
    if (counterparty.isEmpty || openingBalance == null || openingBalance <= 0) {
      setState(() {
        _errorText = 'Enter who this is with and an opening balance above zero.';
      });
      return;
    }
    if (_reminderEnabled) {
      final DateTime? dueDate = _dueDate;
      if (dueDate == null || !dueDate.isAfter(DateTime.now())) {
        setState(() {
          _errorText = 'Choose a future due date before enabling a reminder.';
        });
        return;
      }
      final bool granted = await ref
          .read(debtReminderServiceProvider)
          .requestPermission();
      if (!granted && mounted) {
        setState(() {
          _errorText = 'Notification permission is needed for the private reminder.';
        });
        return;
      }
    }
    if (!mounted) {
      return;
    }
    setState(() {
      _saving = true;
      _errorText = null;
    });
    try {
      final repository = ref.read(debtRepositoryProvider);
      final DebtAccount? existing = widget.account;
      if (existing == null) {
        await repository.create(
          kind: _kind,
          counterparty: counterparty,
          openingBalance: openingBalance,
          dueDate: _dueDate,
          note: _noteController.text,
          reminderEnabled: _reminderEnabled,
          reminderDaysBefore: _reminderDaysBefore,
        );
      } else {
        await repository.update(
          id: existing.id,
          kind: _kind,
          counterparty: counterparty,
          openingBalance: openingBalance,
          dueDate: _dueDate,
          note: _noteController.text,
          reminderEnabled: _reminderEnabled,
          reminderDaysBefore: _reminderDaysBefore,
        );
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _errorText = 'Could not save this ledger: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool editing = widget.account != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit debt or loan' : 'Add debt or loan')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            const Text(
              'Names and notes are encrypted before local storage. Nothing here is sent off-device.',
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<DebtKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Type'),
              items: DebtKind.values
                  .map(
                    (DebtKind kind) => DropdownMenuItem<DebtKind>(
                      value: kind,
                      child: Text(kind.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (DebtKind? value) {
                if (value != null) {
                  setState(() => _kind = value);
                }
              },
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _counterpartyController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: _kind.counterpartyLabel),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _balanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Opening outstanding balance',
                prefixText: '₹ ',
                helperText: 'Use the balance that is outstanding when you start tracking it here.',
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _pickDueDate,
              icon: const Icon(Icons.event_rounded),
              label: Text(
                _dueDate == null
                    ? 'Optional due date'
                    : 'Due ${_dateFormat.format(_dueDate!)}',
              ),
            ),
            if (_dueDate != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => setState(() {
                    _dueDate = null;
                    _reminderEnabled = false;
                  }),
                  child: const Text('Clear due date'),
                ),
              ),
            const SizedBox(height: 6),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Private due reminder'),
              subtitle: const Text(
                'The notification never includes a name, amount, account, or balance.',
              ),
              value: _reminderEnabled,
              onChanged: _dueDate == null
                  ? null
                  : (bool value) => setState(() => _reminderEnabled = value),
            ),
            if (_reminderEnabled)
              DropdownButtonFormField<int>(
                initialValue: _reminderDaysBefore,
                decoration: const InputDecoration(labelText: 'Remind me before'),
                items: DebtReminderService.supportedLeadDays
                    .map(
                      (int days) => DropdownMenuItem<int>(
                        value: days,
                        child: Text('$days day${days == 1 ? '' : 's'} before'),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() => _reminderDaysBefore = value);
                  }
                },
              ),
            const SizedBox(height: 14),
            TextField(
              controller: _noteController,
              minLines: 2,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Private note (optional)',
              ),
            ),
            if (_errorText != null) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                _errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.lock_rounded),
              label: Text(editing ? 'Save changes' : 'Create private ledger'),
            ),
          ],
        ),
      ),
    );
  }
}
