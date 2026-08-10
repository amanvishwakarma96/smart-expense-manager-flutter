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
    this.purposeCode = '',
    this.encryptedMerchant = '',
    this.categoryId,
    this.frequency = RecurringFrequency.monthly,
    this.scheduleDay = 1,
    required this.nextDueAt,
    this.isActive = true,
    this.reminderEnabled = false,
    this.reminderDaysBefore = 1,
  });

  Id id;
  double amount;

  @enumerated
  TransactionType type;

  String purposeCode;
  String encryptedMerchant;
  int? categoryId;

  @enumerated
  RecurringFrequency frequency;

  int scheduleDay;
  DateTime nextDueAt;
  bool isActive;
  bool reminderEnabled;
  int reminderDaysBefore;
  DateTime createdAt = DateTime.now();
}
