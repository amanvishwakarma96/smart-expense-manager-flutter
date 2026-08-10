import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

class SubscriptionSuggestion {
  const SubscriptionSuggestion({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.frequency,
    required this.nextExpectedAt,
    required this.occurrences,
    this.categoryId,
  });

  final String id;
  final String merchant;
  final double amount;
  final RecurringFrequency frequency;
  final DateTime nextExpectedAt;
  final int occurrences;
  final int? categoryId;
}
