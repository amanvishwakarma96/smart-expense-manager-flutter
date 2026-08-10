import 'package:flutter/material.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/dashboard/domain/subscription_suggestion.dart';
import 'package:smart_expense_manager/features/dashboard/services/subscription_detector_service.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';
import 'package:smart_expense_manager/features/transactions/presentation/recurring_transaction_editor.dart';

class SubscriptionSuggestionsCard extends StatefulWidget {
  const SubscriptionSuggestionsCard({
    required this.transactions,
    required this.recurring,
    required this.privacyMode,
    super.key,
  });

  final List<ExpenseTransaction> transactions;
  final List<RecurringTransaction> recurring;
  final bool privacyMode;

  @override
  State<SubscriptionSuggestionsCard> createState() =>
      _SubscriptionSuggestionsCardState();
}

class _SubscriptionSuggestionsCardState
    extends State<SubscriptionSuggestionsCard> {
  final Set<String> _dismissed = <String>{};

  @override
  Widget build(BuildContext context) {
    final List<SubscriptionSuggestion> suggestions = const SubscriptionDetectorService()
        .detect(
          transactions: widget.transactions,
          recurringTransactions: widget.recurring,
          now: DateTime.now(),
        )
        .where(
          (SubscriptionSuggestion item) => !_dismissed.contains(item.id),
        )
        .take(3)
        .toList(growable: false);
    if (suggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: suggestions.map((SubscriptionSuggestion suggestion) {
        final String cadence =
            suggestion.frequency == RecurringFrequency.weekly
            ? 'weekly'
            : 'monthly';
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppPalette.lemon,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.autorenew_rounded),
                    ),
                    const SizedBox(width: 11),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Looks like a subscription',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text('Detected only from confirmed local history.'),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Dismiss suggestion',
                      onPressed: () =>
                          setState(() => _dismissed.add(suggestion.id)),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  '${suggestion.merchant} · $cadence · '
                  '${widget.privacyMode ? '$defaultCurrencySymbol ••••' : inrCurrency.format(suggestion.amount)}',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  '${suggestion.occurrences} matching payments found in the last 90 days.',
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => showRecurringTransactionEditor(
                    context,
                    seed: RecurringEditorSeed(
                      merchant: suggestion.merchant,
                      amount: suggestion.amount,
                      frequency: suggestion.frequency,
                      nextDueAt: suggestion.nextExpectedAt,
                      categoryId: suggestion.categoryId,
                    ),
                  ),
                  icon: const Icon(Icons.event_repeat_rounded),
                  label: const Text('Set up as recurring'),
                ),
              ],
            ),
          ),
        );
      }).toList(growable: false),
    );
  }
}
