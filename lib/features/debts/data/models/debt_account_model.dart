import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';

part 'debt_account_model.g.dart';

@collection
class DebtAccountModel {
  DebtAccountModel({
    this.id = Isar.autoIncrement,
    this.kind = DebtKind.borrowed,
    this.encryptedCounterparty = '',
    this.openingBalance = 0,
    this.dueDate,
    this.encryptedNote = '',
    this.reminderEnabled = false,
    this.reminderDaysBefore = 1,
    this.isArchived = false,
  }) : createdAt = DateTime.now(),
       updatedAt = DateTime.now();

  Id id;

  @enumerated
  DebtKind kind;

  String encryptedCounterparty;
  double openingBalance;
  DateTime? dueDate;
  String encryptedNote;
  bool reminderEnabled;
  int reminderDaysBefore;
  bool isArchived;
  DateTime createdAt;
  DateTime updatedAt;
}
