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
    TransactionPurpose? purpose,
    this.categoryId,
    this.reminderEnabled = false,
    this.reminderDaysBefore = 1,
  }) : purpose =
           purpose ??
           (type == TransactionType.debit
               ? TransactionPurpose.expense
               : TransactionPurpose.income);

  final int id;
  final double amount;
  final TransactionType type;
  final TransactionPurpose purpose;
  final String merchant;
  final int? categoryId;
  final RecurringFrequency frequency;
  final DateTime nextDueAt;
  final bool isActive;
  final bool reminderEnabled;
  final int reminderDaysBefore;

  bool get isDebit => type == TransactionType.debit;
  bool get isCredit => type == TransactionType.credit;
  bool get countsAsIncome => purpose.countsAsIncome;
  bool get countsAsSpending => purpose.countsAsSpending;
}
