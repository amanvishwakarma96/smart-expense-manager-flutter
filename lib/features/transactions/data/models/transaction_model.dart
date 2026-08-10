import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {
  TransactionModel({
    this.id = Isar.autoIncrement,
    this.amount = 0,
    this.type = TransactionType.debit,
    this.purposeCode = '',
    this.encryptedMerchant = '',
    required this.timestamp,
    this.categoryId,
    this.status = TransactionStatus.pending,
    this.encryptedOriginalSmsText = '',
    this.encryptedAccountTail = '',
    this.smsFingerprint,
    this.possibleDuplicateOf,
    this.isManual = false,
    this.isRecurring = false,
  }) : createdAt = DateTime.now();

  Id id;
  double amount;

  @enumerated
  TransactionType type;

  String purposeCode;
  String encryptedMerchant;
  DateTime timestamp;
  int? categoryId;

  @enumerated
  TransactionStatus status;

  String encryptedOriginalSmsText;
  String encryptedAccountTail;

  @Index(unique: true, replace: false)
  String? smsFingerprint;

  int? possibleDuplicateOf;
  bool isManual;
  bool isRecurring;
  DateTime createdAt;
}
