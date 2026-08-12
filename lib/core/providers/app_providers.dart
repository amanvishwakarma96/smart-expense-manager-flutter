import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/app_lock_service.dart';
import 'package:smart_expense_manager/core/security/onboarding_service.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/challenges/data/repositories/weekly_challenge_repository.dart';
import 'package:smart_expense_manager/features/challenges/domain/weekly_challenge.dart';
import 'package:smart_expense_manager/features/debts/data/repositories/debt_repayment_plan_repository.dart';
import 'package:smart_expense_manager/features/debts/data/repositories/debt_repository.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_repayment_plan.dart';
import 'package:smart_expense_manager/features/debts/services/debt_reminder_service.dart';
import 'package:smart_expense_manager/features/debts/services/repayment_schedule_service.dart';
import 'package:smart_expense_manager/features/goals/data/repositories/savings_goal_repository.dart';
import 'package:smart_expense_manager/features/goals/domain/savings_goal.dart';
import 'package:smart_expense_manager/features/settings/services/backup_file_service.dart';
import 'package:smart_expense_manager/features/settings/services/bill_reminder_service.dart';
import 'package:smart_expense_manager/features/settings/services/budget_alert_service.dart';
import 'package:smart_expense_manager/features/settings/services/debt_aware_backup_service.dart';
import 'package:smart_expense_manager/features/settings/services/local_backup_service.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_engine_coordinator.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/category_repository.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/merchant_rule_repository.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/recurring_transaction_repository.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/transaction_repository.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/learned_merchant_mapping.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

final Provider<Isar> isarProvider = Provider<Isar>((Ref ref) {
  throw StateError('isarProvider must be overridden at startup');
});

final Provider<SecureCipherService> cipherProvider =
    Provider<SecureCipherService>((Ref ref) {
      throw StateError('cipherProvider must be overridden at startup');
    });

final Provider<BudgetAlertService> budgetAlertServiceProvider =
    Provider<BudgetAlertService>((Ref ref) {
      return BudgetAlertService(isar: ref.watch(isarProvider));
    });

final Provider<BillReminderService> billReminderServiceProvider =
    Provider<BillReminderService>((Ref ref) {
      return BillReminderService(isar: ref.watch(isarProvider));
    });

final Provider<DebtReminderService> debtReminderServiceProvider =
    Provider<DebtReminderService>((Ref ref) {
      return DebtReminderService(isar: ref.watch(isarProvider));
    });

final Provider<DebtRepaymentPlanRepository> debtRepaymentPlanRepositoryProvider =
    Provider<DebtRepaymentPlanRepository>((Ref ref) {
      return DebtRepaymentPlanRepository(ref.watch(isarProvider));
    });

final Provider<RepaymentScheduleService> repaymentScheduleServiceProvider =
    Provider<RepaymentScheduleService>((Ref ref) {
      return const RepaymentScheduleService();
    });

final Provider<MerchantRuleRepository> merchantRuleRepositoryProvider =
    Provider<MerchantRuleRepository>((Ref ref) {
      return MerchantRuleRepository(
        ref.watch(isarProvider),
        ref.watch(cipherProvider),
      );
    });

final Provider<TransactionRepository> transactionRepositoryProvider =
    Provider<TransactionRepository>((Ref ref) {
      return TransactionRepository(
        ref.watch(isarProvider),
        ref.watch(cipherProvider),
        budgetAlertService: ref.watch(budgetAlertServiceProvider),
        reminderService: ref.watch(billReminderServiceProvider),
        merchantRuleRepository: ref.watch(merchantRuleRepositoryProvider),
      );
    });

final Provider<RecurringTransactionRepository>
recurringTransactionRepositoryProvider =
    Provider<RecurringTransactionRepository>((Ref ref) {
      return RecurringTransactionRepository(
        ref.watch(isarProvider),
        ref.watch(cipherProvider),
        reminderService: ref.watch(billReminderServiceProvider),
      );
    });

final Provider<DebtRepository> debtRepositoryProvider =
    Provider<DebtRepository>((Ref ref) {
      return DebtRepository(
        ref.watch(isarProvider),
        ref.watch(cipherProvider),
        reminderService: ref.watch(debtReminderServiceProvider),
      );
    });

final Provider<WeeklyChallengeRepository> weeklyChallengeRepositoryProvider =
    Provider<WeeklyChallengeRepository>((Ref ref) {
      return WeeklyChallengeRepository(ref.watch(isarProvider));
    });

final Provider<SavingsGoalRepository> savingsGoalRepositoryProvider =
    Provider<SavingsGoalRepository>((Ref ref) {
      return SavingsGoalRepository(
        ref.watch(isarProvider),
        ref.watch(cipherProvider),
      );
    });

final Provider<CategoryRepository> categoryRepositoryProvider =
    Provider<CategoryRepository>((Ref ref) {
      return CategoryRepository(ref.watch(isarProvider));
    });

final Provider<LocalBackupService> localBackupServiceProvider =
    Provider<LocalBackupService>((Ref ref) {
      return DebtAwareBackupService(
        ref.watch(weeklyChallengeRepositoryProvider),
        isar: ref.watch(isarProvider),
        cipher: ref.watch(cipherProvider),
        reminderService: ref.watch(billReminderServiceProvider),
        debtReminderService: ref.watch(debtReminderServiceProvider),
      );
    });

final Provider<BackupFileService> backupFileServiceProvider =
    Provider<BackupFileService>((Ref ref) => BackupFileService());

final Provider<SmsEngineCoordinator> smsEngineCoordinatorProvider =
    Provider<SmsEngineCoordinator>((Ref ref) {
      return SmsEngineCoordinator(
        transactionRepository: ref.watch(transactionRepositoryProvider),
        merchantRuleRepository: ref.watch(merchantRuleRepositoryProvider),
        categoryRepository: ref.watch(categoryRepositoryProvider),
      );
    });

final Provider<AppLockService> appLockServiceProvider =
    Provider<AppLockService>((Ref ref) => AppLockService());

final Provider<OnboardingService> onboardingServiceProvider =
    Provider<OnboardingService>((Ref ref) => OnboardingService());

final StreamProvider<List<ExpenseTransaction>> pendingTransactionsProvider =
    StreamProvider<List<ExpenseTransaction>>((Ref ref) {
      return ref.watch(transactionRepositoryProvider).watchPending();
    });

final StreamProvider<List<ExpenseTransaction>> confirmedTransactionsProvider =
    StreamProvider<List<ExpenseTransaction>>((Ref ref) {
      return ref.watch(transactionRepositoryProvider).watchConfirmed();
    });

final StreamProvider<List<RecurringTransaction>> recurringTransactionsProvider =
    StreamProvider<List<RecurringTransaction>>((Ref ref) {
      return ref.watch(recurringTransactionRepositoryProvider).watchAll();
    });

final StreamProvider<List<DebtAccount>> debtAccountsProvider =
    StreamProvider<List<DebtAccount>>((Ref ref) {
      return ref.watch(debtRepositoryProvider).watchActive();
    });

final StreamProviderFamily<DebtRepaymentPlan?, int> debtRepaymentPlanProvider =
    StreamProvider.family<DebtRepaymentPlan?, int>((Ref ref, int debtId) {
      return ref.watch(debtRepaymentPlanRepositoryProvider).watchForDebt(debtId);
    });

final StreamProvider<List<WeeklyChallenge>> weeklyChallengesProvider =
    StreamProvider<List<WeeklyChallenge>>((Ref ref) {
      return ref.watch(weeklyChallengeRepositoryProvider).watchAll();
    });

final StreamProvider<List<SavingsGoal>> savingsGoalsProvider =
    StreamProvider<List<SavingsGoal>>((Ref ref) {
      return ref.watch(savingsGoalRepositoryProvider).watchActive();
    });

final StreamProvider<List<CategoryModel>> categoriesProvider =
    StreamProvider<List<CategoryModel>>((Ref ref) {
      return ref.watch(categoryRepositoryProvider).watchAll();
    });

final StreamProvider<List<MerchantRuleModel>> merchantRulesProvider =
    StreamProvider<List<MerchantRuleModel>>((Ref ref) {
      return ref.watch(merchantRuleRepositoryProvider).watchAll();
    });

final StreamProvider<List<LearnedMerchantMapping>>
learnedMerchantMappingsProvider = StreamProvider<List<LearnedMerchantMapping>>((
  Ref ref,
) {
  return ref.watch(merchantRuleRepositoryProvider).watchLearnedMappings();
});

class PrivacyModeController extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle() => state = !state;

  void setEnabled(bool value) => state = value;
}

final NotifierProvider<PrivacyModeController, bool> privacyModeProvider =
    NotifierProvider<PrivacyModeController, bool>(PrivacyModeController.new);

class ResetRequiredController extends Notifier<bool> {
  @override
  bool build() => false;

  void requireRestart() => state = true;
}

final NotifierProvider<ResetRequiredController, bool> resetRequiredProvider =
    NotifierProvider<ResetRequiredController, bool>(
      ResetRequiredController.new,
    );
