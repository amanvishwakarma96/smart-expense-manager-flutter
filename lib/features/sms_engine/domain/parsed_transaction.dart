import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class ParsedTransaction {
  const ParsedTransaction({
    required this.amount,
    required this.type,
    required this.merchantName,
    required this.accountTail,
    required this.timestamp,
    required this.originalText,
    required this.sender,
    required this.confidence,
  });

  final double amount;
  final TransactionType type;
  final String merchantName;
  final String accountTail;
  final DateTime timestamp;
  final String originalText;
  final String sender;
  final double confidence;
}
