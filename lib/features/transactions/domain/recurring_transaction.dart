import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

enum RecurringFrequency { weekly, monthly }

class RecurringTransaction {
  const RecurringTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.merchant,
    required this.frequency,
    required this.nextDueAt,
    required this.isActive,
    this.categoryId,
  });

  final int id;
  final double amount;
  final TransactionType type;
  final String merchant;
  final int? categoryId;
  final RecurringFrequency frequency;
  final DateTime nextDueAt;
  final bool isActive;

  bool get isDebit => type == TransactionType.debit;
}
