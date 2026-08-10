import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';
import 'package:smart_expense_manager/features/transactions/presentation/recurring_transaction_editor.dart';
import 'package:smart_expense_manager/features/transactions/presentation/transaction_semantics_widgets.dart';

class RecurringTransactionsCard extends ConsumerWidget {
  const RecurringTransactionsCard({super.key});

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    RecurringTransaction transaction,
  ) async {
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: const Text('Delete recurring item?'),
            content: Text(
              '${transaction.merchant} will stop creating future review entries and reminders.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Keep'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                icon: const Icon(Icons.delete_rounded),
                label: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
    if (confirmed) {
      await ref
          .read(recurringTransactionRepositoryProvider)
          .delete(transaction.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<RecurringTransaction>> recurring = ref.watch(
      recurringTransactionsProvider,
    );
    final bool privacyMode = ref.watch(privacyModeProvider);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppPalette.rose,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.event_repeat_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Recurring money moments',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text(
                        'Salary, EMI, rent, investments and subscriptions stay local.',
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Add recurring transaction',
                  onPressed: () => showRecurringTransactionEditor(context),
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            recurring.when(
              loading: () => const LinearProgressIndicator(),
              error: (Object error, StackTrace stackTrace) => const Text(
                'Could not load recurring items from local storage.',
              ),
              data: (List<RecurringTransaction> items) {
                if (items.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppPalette.lemon,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Text(
                      'Add rent, salary, EMI, SIP, subscriptions, or any repeating transaction.',
                    ),
                  ).animate().fadeIn();
                }
                return Column(
                  children: items.indexed
                      .map((entry) {
                        final int index = entry.$1;
                        final RecurringTransaction item = entry.$2;
                        final Color accent =
                            AppPalette.playfulSequence[index %
                                AppPalette.playfulSequence.length];
                        return Container(
                          margin: EdgeInsets.only(top: index == 0 ? 0 : 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: accent.withValues(
                              alpha: item.isActive ? 0.72 : 0.30,
                            ),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.66,
                                ),
                                child: Icon(
                                  item.isDebit
                                      ? Icons.north_east_rounded
                                      : Icons.south_west_rounded,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      item.merchant,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    TransactionSemanticChips(
                                      type: item.type,
                                      purpose: item.purpose,
                                      compact: true,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_frequencyLabel(item.frequency)} · next ${transactionDayFormat.format(item.nextDueAt)}',
                                    ),
                                    Text(
                                      privacyMode
                                          ? '$defaultCurrencySymbol ••••'
                                          : inrCurrency.format(item.amount),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    if (item.reminderEnabled && item.isDebit)
                                      Text(
                                        _reminderLabel(item.reminderDaysBefore),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: item.isActive,
                                onChanged: (bool value) => ref
                                    .read(
                                      recurringTransactionRepositoryProvider,
                                    )
                                    .setActive(item.id, value),
                              ),
                              PopupMenuButton<_RecurringAction>(
                                onSelected: (_RecurringAction action) {
                                  switch (action) {
                                    case _RecurringAction.edit:
                                      showRecurringTransactionEditor(
                                        context,
                                        transaction: item,
                                      );
                                    case _RecurringAction.delete:
                                      _delete(context, ref, item);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    const <PopupMenuEntry<_RecurringAction>>[
                                      PopupMenuItem<_RecurringAction>(
                                        value: _RecurringAction.edit,
                                        child: Text('Edit'),
                                      ),
                                      PopupMenuItem<_RecurringAction>(
                                        value: _RecurringAction.delete,
                                        child: Text('Delete'),
                                      ),
                                    ],
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: (index * 45).ms);
                      })
                      .toList(growable: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _frequencyLabel(RecurringFrequency frequency) =>
      frequency == RecurringFrequency.weekly ? 'Weekly' : 'Monthly';

  static String _reminderLabel(int daysBefore) => daysBefore == 0
      ? 'Reminder on due day'
      : 'Reminder $daysBefore day${daysBefore == 1 ? '' : 's'} before';
}

enum _RecurringAction { edit, delete }
