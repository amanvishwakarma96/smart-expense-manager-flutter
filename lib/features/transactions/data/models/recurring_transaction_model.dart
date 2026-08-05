import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

part 'recurring_transaction_model.g.dart';

@collection
class RecurringTransactionModel {
  RecurringTransactionModel({
    this.id = Isar.autoIncrement,
    this.amount = 0,
    this.type = TransactionType.debit,
    this.encryptedMerchant = '',
    this.categoryId,
    this.frequency = RecurringFrequency.monthly,
    required this.nextDueAt,
    this.isActive = true,
  });

  Id id;
  double amount;

  @enumerated
  TransactionType type;

  String encryptedMerchant;
  int? categoryId;

  @enumerated
  RecurringFrequency frequency;

  DateTime nextDueAt;
  bool isActive;
  DateTime createdAt = DateTime.now();
}
