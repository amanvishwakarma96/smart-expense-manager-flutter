import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/debts/data/repositories/debt_repayment_plan_repository.dart';
import 'package:smart_expense_manager/features/debts/data/repositories/debt_repository.dart';
import 'package:smart_expense_manager/features/debts/services/debt_reminder_service.dart';

class RepaymentAwareDebtRepository extends DebtRepository {
  RepaymentAwareDebtRepository(
    Isar isar,
    SecureCipherService cipher, {
    required DebtRepaymentPlanRepository repaymentPlans,
    DebtReminderService? reminderService,
  }) : _repaymentPlans = repaymentPlans,
       super(isar, cipher, reminderService: reminderService);

  final DebtRepaymentPlanRepository _repaymentPlans;

  @override
  Future<void> delete(int id) async {
    await super.delete(id);
    await _repaymentPlans.deleteForDebt(id);
  }

  @override
  Future<void> clearAll() async {
    await super.clearAll();
    await _repaymentPlans.clearAll();
  }
}
