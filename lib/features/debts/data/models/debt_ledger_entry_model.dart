import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';

part 'debt_ledger_entry_model.g.dart';

@collection
class DebtLedgerEntryModel {
  DebtLedgerEntryModel({
    this.id = Isar.autoIncrement,
    this.debtId = 0,
    this.type = DebtMovementType.decrease,
    this.amount = 0,
    required this.occurredAt,
    this.linkedTransactionId,
    this.encryptedNote = '',
  }) : createdAt = DateTime.now();

  Id id;

  @Index()
  int debtId;

  @enumerated
  DebtMovementType type;

  double amount;
  DateTime occurredAt;

  @Index()
  int? linkedTransactionId;

  String encryptedNote;
  DateTime createdAt;
}
