enum TransactionType { debit, credit }

enum TransactionStatus { pending, confirmed }

class ExpenseTransaction {
  const ExpenseTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.merchant,
    required this.timestamp,
    required this.status,
    required this.accountTail,
    required this.originalSmsText,
    this.categoryId,
    this.isManual = false,
  });

  final int id;
  final double amount;
  final TransactionType type;
  final String merchant;
  final DateTime timestamp;
  final int? categoryId;
  final TransactionStatus status;
  final String accountTail;
  final String originalSmsText;
  final bool isManual;

  bool get isDebit => type == TransactionType.debit;
}
