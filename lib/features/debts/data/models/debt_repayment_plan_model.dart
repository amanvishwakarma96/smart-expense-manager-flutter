import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_repayment_plan.dart';

part 'debt_repayment_plan_model.g.dart';

@collection
class DebtRepaymentPlanModel {
  DebtRepaymentPlanModel({
    this.id = Isar.autoIncrement,
    this.debtId = 0,
    this.cadence = RepaymentCadence.monthly,
    this.installmentAmount = 0,
    this.annualInterestRatePct = 0,
    DateTime? firstDueDate,
    this.startingOutstanding = 0,
    this.baselineRepaidAmount = 0,
    this.isPaused = false,
  }) : firstDueDate = firstDueDate ?? DateTime.now(),
       createdAt = DateTime.now(),
       updatedAt = DateTime.now();

  Id id;
  int debtId;

  @enumerated
  RepaymentCadence cadence;

  double installmentAmount;
  double annualInterestRatePct;
  DateTime firstDueDate;
  double startingOutstanding;
  double baselineRepaidAmount;
  bool isPaused;
  DateTime createdAt;
  DateTime updatedAt;
}
