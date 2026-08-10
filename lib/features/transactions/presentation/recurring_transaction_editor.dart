import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/settings/services/bill_reminder_service.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';
import 'package:smart_expense_manager/features/transactions/presentation/transaction_semantics_widgets.dart';

class RecurringEditorSeed {
  const RecurringEditorSeed({
    required this.merchant,
    required this.amount,
    required this.frequency,
    required this.nextDueAt,
    this.categoryId,
  });

  final String merchant;
  final double amount;
  final RecurringFrequency frequency;
  final DateTime nextDueAt;
  final int? categoryId;
}

Future<void> showRecurringTransactionEditor(
  BuildContext context, {
  RecurringTransaction? transaction,
  RecurringEditorSeed? seed,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) =>
        _RecurringEditorSheet(transaction: transaction, seed: seed),
  );
}

class _RecurringEditorSheet extends ConsumerStatefulWidget {
  const _RecurringEditorSheet({this.transaction, this.seed});

  final RecurringTransaction? transaction;
  final RecurringEditorSeed? seed;

  @override
  ConsumerState<_RecurringEditorSheet> createState() =>
      _RecurringEditorSheetState();
}

class _RecurringEditorSheetState extends ConsumerState<_RecurringEditorSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _merchantController;
  late final TextEditingController _amountController;
  late TransactionType _type;
  late TransactionPurpose _purpose;
  late RecurringFrequency _frequency;
  late DateTime _nextDueAt;
  late bool _reminderEnabled;
  late int _reminderDaysBefore;
  int? _categoryId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final RecurringTransaction? item = widget.transaction;
    final RecurringEditorSeed? seed = widget.seed;
    _merchantController = TextEditingController(
      text: item?.merchant ?? seed?.merchant ?? '',
    );
    _amountController = TextEditingController(
      text:
          item?.amount.toStringAsFixed(2) ??
          (seed == null ? '' : seed.amount.toStringAsFixed(2)),
    );
    _type = item?.type ?? TransactionType.debit;
    _purpose = item?.purpose ?? defaultTransactionPurpose(_type);
    _frequency =
        item?.frequency ?? seed?.frequency ?? RecurringFrequency.monthly;
    _nextDueAt = item?.nextDueAt ?? seed?.nextDueAt ?? DateTime.now();
    _categoryId = item?.categoryId ?? seed?.categoryId;
    _reminderEnabled = item?.reminderEnabled ?? false;
    _reminderDaysBefore = item?.reminderDaysBefore ?? 1;
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _nextDueAt,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 3660)),
      helpText: 'Choose the next due date',
    );
    if (selected != null && mounted) {
      setState(() => _nextDueAt = selected);
    }
  }

  void _changeType(TransactionType type) {
    setState(() {
      _type = type;
      if (!transactionPurposesFor(type).contains(_purpose)) {
        _purpose = defaultTransactionPurpose(type);
      }
      if (_type == TransactionType.credit) {
        _reminderEnabled = false;
      }
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _saving = true);
    bool reminderEnabled = _type == TransactionType.debit && _reminderEnabled;
    if (reminderEnabled) {
      final bool permitted = await ref
          .read(billReminderServiceProvider)
          .requestPermission();
      if (!permitted) {
        reminderEnabled = false;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Notification permission was not granted. The item was saved without a reminder.',
              ),
            ),
          );
        }
      }
    }

    final String merchant = _merchantController.text.trim();
    await ref
        .read(recurringTransactionRepositoryProvider)
        .save(
          id: widget.transaction?.id,
          amount: double.parse(_amountController.text.trim()),
          type: _type,
          purpose: _purpose,
          merchant: merchant,
          frequency: _frequency,
          nextDueAt: _nextDueAt,
          categoryId: _categoryId,
          isActive: widget.transaction?.isActive ?? true,
          reminderEnabled: reminderEnabled,
          reminderDaysBefore: _reminderDaysBefore,
        );
    if (_categoryId != null) {
      await ref
          .read(merchantRuleRepositoryProvider)
          .learnCategory(merchant: merchant, categoryId: _categoryId!);
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CategoryModel> categories =
        ref.watch(categoriesProvider).value ?? const <CategoryModel>[];
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppPalette.heroGradient,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.transaction == null
                          ? 'Add a recurring item'
                          : 'Edit recurring item',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Nothing is created until you press Save. Future occurrences still land in Review.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SegmentedButton<TransactionType>(
                segments: const <ButtonSegment<TransactionType>>[
                  ButtonSegment<TransactionType>(
                    value: TransactionType.debit,
                    label: Text('Debit'),
                  ),
                  ButtonSegment<TransactionType>(
                    value: TransactionType.credit,
                    label: Text('Credit'),
                  ),
                ],
                selected: <TransactionType>{_type},
                onSelectionChanged: (Set<TransactionType> selected) =>
                    _changeType(selected.first),
              ),
              const SizedBox(height: 12),
              TransactionPurposeField(
                key: ValueKey<String>('${_type.name}-${_purpose.name}'),
                type: _type,
                value: _purpose,
                onChanged: (TransactionPurpose value) =>
                    setState(() => _purpose = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _merchantController,
                decoration: const InputDecoration(
                  labelText: 'Merchant, person or note',
                ),
                validator: (String? value) => (value?.trim().isEmpty ?? true)
                    ? 'Enter a name or note'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount in INR',
                  prefixText: '$defaultCurrencySymbol ',
                ),
                validator: (String? value) {
                  final double? amount = double.tryParse(value?.trim() ?? '');
                  return amount == null || amount <= 0
                      ? 'Enter a valid amount'
                      : null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _categoryId,
                decoration: const InputDecoration(labelText: 'Category'),
                items: categories
                    .map(
                      (CategoryModel category) => DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (int? value) => setState(() => _categoryId = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<RecurringFrequency>(
                initialValue: _frequency,
                decoration: const InputDecoration(labelText: 'Repeats'),
                items: const <DropdownMenuItem<RecurringFrequency>>[
                  DropdownMenuItem<RecurringFrequency>(
                    value: RecurringFrequency.weekly,
                    child: Text('Every week'),
                  ),
                  DropdownMenuItem<RecurringFrequency>(
                    value: RecurringFrequency.monthly,
                    child: Text('Every month'),
                  ),
                ],
                onChanged: (RecurringFrequency? value) {
                  if (value != null) {
                    setState(() => _frequency = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_month_rounded),
                title: const Text('Next due date'),
                subtitle: Text(transactionDayFormat.format(_nextDueAt)),
                onTap: _pickDate,
              ),
              if (_type == TransactionType.debit) ...<Widget>[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Private reminder'),
                  subtitle: const Text(
                    'Notification text never includes the name or amount.',
                  ),
                  value: _reminderEnabled,
                  onChanged: (bool value) =>
                      setState(() => _reminderEnabled = value),
                ),
                if (_reminderEnabled)
                  DropdownButtonFormField<int>(
                    initialValue: _reminderDaysBefore,
                    decoration: const InputDecoration(labelText: 'Remind me'),
                    items: BillReminderService.supportedLeadDays
                        .map(
                          (int days) => DropdownMenuItem<int>(
                            value: days,
                            child: Text(_leadTimeLabel(days)),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() => _reminderDaysBefore = value);
                      }
                    },
                  ),
              ],
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.check_rounded),
                label: Text(
                  widget.transaction == null
                      ? 'Save recurring item'
                      : 'Save changes',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _leadTimeLabel(int days) {
    return switch (days) {
      0 => 'On the due day at 9:00 AM',
      1 => '1 day before at 9:00 AM',
      _ => '$days days before at 9:00 AM',
    };
  }
}
