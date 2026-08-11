import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/presentation/debt_account_editor_screen.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class DebtDetailScreen extends ConsumerWidget {
  const DebtDetailScreen({super.key, required this.debtId});

  final int debtId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool privacyMode = ref.watch(privacyModeProvider);
    return ref.watch(debtAccountsProvider).when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (Object error, StackTrace stackTrace) => const Scaffold(
        body: Center(child: Text('Could not open this debt ledger.')),
      ),
      data: (List<DebtAccount> items) {
        DebtAccount? account;
        for (final DebtAccount item in items) {
          if (item.id == debtId) {
            account = item;
            break;
          }
        }
        if (account == null) {
          return const Scaffold(
            body: Center(child: Text('This debt ledger is no longer active.')),
          );
        }
        return _DebtDetailBody(
          account: account,
          privacyMode: privacyMode,
        );
      },
    );
  }
}

class _DebtDetailBody extends ConsumerWidget {
  const _DebtDetailBody({required this.account, required this.privacyMode});

  static final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  final DebtAccount account;
  final bool privacyMode;

  String _amount(double value) => privacyMode
      ? '$defaultCurrencySymbol •••••'
      : inrCurrency.format(value);

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String action,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(action),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _addMovement(
    BuildContext context,
    WidgetRef ref,
    DebtMovementType type,
  ) async {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController noteController = TextEditingController();
    DateTime occurredAt = DateTime.now();
    String? errorText;
    final _MovementDraft? draft = await showDialog<_MovementDraft>(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          final bool repayment = type == DebtMovementType.decrease;
          final String title = repayment
              ? account.kind == DebtKind.lent
                    ? 'Record repayment received'
                    : 'Record repayment'
              : account.kind == DebtKind.lent
              ? 'Lent more money'
              : account.kind == DebtKind.loan
              ? 'Increase loan balance'
              : 'Borrowed more money';
          Future<void> pickDate() async {
            final DateTime? picked = await showDatePicker(
              context: dialogContext,
              initialDate: occurredAt,
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 1)),
            );
            if (picked != null) {
              setDialogState(() => occurredAt = picked);
            }
          }

          void submit() {
            final double? value = double.tryParse(
              amountController.text.trim().replaceAll(',', ''),
            );
            if (value == null || value <= 0) {
              setDialogState(() => errorText = 'Enter an amount above zero.');
              return;
            }
            Navigator.of(dialogContext).pop(
              _MovementDraft(
                amount: value,
                occurredAt: occurredAt,
                note: noteController.text.trim(),
              ),
            );
          }

          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'This changes only the debt ledger. It does not create or edit a bank transaction.',
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: amountController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      prefixText: '₹ ',
                      errorText: errorText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: pickDate,
                    icon: const Icon(Icons.event_rounded),
                    label: Text(_dateFormat.format(occurredAt)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(labelText: 'Private note (optional)'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(onPressed: submit, child: const Text('Save entry')),
            ],
          );
        },
      ),
    );
    amountController.dispose();
    noteController.dispose();
    if (draft == null) {
      return;
    }
    await ref.read(debtRepositoryProvider).addManualMovement(
          debtId: account.id,
          type: type,
          amount: draft.amount,
          occurredAt: draft.occurredAt,
          note: draft.note,
        );
  }

  Future<void> _linkTransaction(BuildContext context, WidgetRef ref) async {
    final List<ExpenseTransaction> transactions = await ref
        .read(debtRepositoryProvider)
        .linkableConfirmedTransactions(account.id);
    if (!context.mounted) {
      return;
    }
    if (transactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No compatible confirmed transactions are available. Set the transaction purpose first, then return here.',
          ),
        ),
      );
      return;
    }
    final int? selected = await showDialog<int>(
      context: context,
      builder: (BuildContext dialogContext) => SimpleDialog(
        title: const Text('Link confirmed transaction'),
        children: transactions
            .map(
              (ExpenseTransaction item) => SimpleDialogOption(
                onPressed: () => Navigator.of(dialogContext).pop(item.id),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(item.merchant, style: const TextStyle(fontWeight: FontWeight.w800)),
                            Text('${item.purpose.shortLabel} • ${_dateFormat.format(item.timestamp)}'),
                          ],
                        ),
                      ),
                      Text(_amount(item.amount), style: const TextStyle(fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
    if (selected == null || !context.mounted) {
      return;
    }
    final bool confirmed = await _confirm(
      context,
      title: 'Link this transaction?',
      message:
          'PiggyAI will use its confirmed amount and purpose to update this ledger. The original transaction will not be edited.',
      action: 'Link',
    );
    if (!confirmed) {
      return;
    }
    await ref.read(debtRepositoryProvider).linkConfirmedTransaction(
          debtId: account.id,
          transactionId: selected,
        );
  }

  Future<void> _deleteEntry(
    BuildContext context,
    WidgetRef ref,
    DebtLedgerEntry entry,
  ) async {
    final bool confirmed = await _confirm(
      context,
      title: entry.isLinkedTransaction ? 'Unlink this transaction?' : 'Delete this ledger entry?',
      message: entry.isLinkedTransaction
          ? 'This removes only the debt-ledger link. The confirmed transaction stays in History.'
          : 'This permanently removes the manual debt-ledger entry from this device.',
      action: entry.isLinkedTransaction ? 'Unlink' : 'Delete',
    );
    if (confirmed) {
      await ref.read(debtRepositoryProvider).deleteEntry(entry.id);
    }
  }

  Future<void> _archive(BuildContext context, WidgetRef ref) async {
    final bool confirmed = await _confirm(
      context,
      title: 'Archive this ledger?',
      message: 'It will leave the active Plan view and its private reminder will be cancelled.',
      action: 'Archive',
    );
    if (!confirmed) {
      return;
    }
    await ref.read(debtRepositoryProvider).setArchived(account.id, true);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final bool confirmed = await _confirm(
      context,
      title: 'Delete this debt ledger permanently?',
      message:
          'The ledger and its repayment history will be removed. Linked bank transactions themselves will remain in History.',
      action: 'Delete',
    );
    if (!confirmed) {
      return;
    }
    await ref.read(debtRepositoryProvider).delete(account.id);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime? dueDate = account.dueDate;
    return Scaffold(
      appBar: AppBar(
        title: Text(account.counterparty),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String value) async {
              switch (value) {
                case 'edit':
                  await Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => DebtAccountEditorScreen(account: account),
                    ),
                  );
                case 'archive':
                  await _archive(context, ref);
                case 'delete':
                  await _delete(context, ref);
              }
            },
            itemBuilder: (_) => const <PopupMenuEntry<String>>[
              PopupMenuItem<String>(value: 'edit', child: Text('Edit')),
              PopupMenuItem<String>(value: 'archive', child: Text('Archive')),
              PopupMenuItem<String>(value: 'delete', child: Text('Delete permanently')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: account.kind.youOwe ? AppPalette.peach : AppPalette.mint,
                borderRadius: BorderRadius.circular(26),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(account.kind.label, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    account.isSettled ? 'Settled' : _amount(account.outstanding),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: account.progress,
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    privacyMode
                        ? 'Opening balance and repayment progress are hidden.'
                        : '${inrCurrency.format(account.repaidBalance)} repaid from ${inrCurrency.format(account.totalObligation)} tracked',
                  ),
                  if (dueDate != null) ...<Widget>[
                    const SizedBox(height: 8),
                    Text('Due ${_dateFormat.format(dueDate)}'),
                  ],
                ],
              ),
            ),
            if (account.note.isNotEmpty) ...<Widget>[
              const SizedBox(height: 14),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(account.note),
                ),
              ),
            ],
            const SizedBox(height: 14),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: <Widget>[
                FilledButton.icon(
                  onPressed: () => _addMovement(context, ref, DebtMovementType.decrease),
                  icon: const Icon(Icons.done_rounded),
                  label: Text(account.kind == DebtKind.lent ? 'Repayment received' : 'Record repayment'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _addMovement(context, ref, DebtMovementType.increase),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(account.kind == DebtKind.lent ? 'Lent more' : 'Increase balance'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _linkTransaction(context, ref),
                  icon: const Icon(Icons.link_rounded),
                  label: const Text('Link transaction'),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Text('Ledger activity', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            if (account.entries.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text('No repayments or balance changes recorded yet.'),
                ),
              )
            else
              ...account.entries.map(
                (DebtLedgerEntry entry) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: entry.type == DebtMovementType.decrease
                          ? AppPalette.mint
                          : AppPalette.peach,
                      child: Icon(
                        entry.type == DebtMovementType.decrease
                            ? Icons.south_west_rounded
                            : Icons.north_east_rounded,
                      ),
                    ),
                    title: Text(
                      entry.type == DebtMovementType.decrease
                          ? 'Balance reduced'
                          : 'Balance increased',
                    ),
                    subtitle: Text(
                      '${_dateFormat.format(entry.occurredAt)}${entry.isLinkedTransaction ? ' • Linked transaction' : ' • Manual ledger entry'}${entry.note.isEmpty ? '' : '\n${entry.note}'}',
                    ),
                    isThreeLine: entry.note.isNotEmpty,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '${entry.type == DebtMovementType.decrease ? '-' : '+'}${_amount(entry.amount)}',
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        IconButton(
                          tooltip: entry.isLinkedTransaction ? 'Unlink' : 'Delete entry',
                          onPressed: () => _deleteEntry(context, ref, entry),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MovementDraft {
  const _MovementDraft({
    required this.amount,
    required this.occurredAt,
    required this.note,
  });

  final double amount;
  final DateTime occurredAt;
  final String note;
}
