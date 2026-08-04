import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/app_lock_service.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_engine_coordinator.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/category_repository.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/merchant_rule_repository.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/transaction_repository.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

final Provider<Isar> isarProvider = Provider<Isar>((Ref ref) {
  throw StateError('isarProvider must be overridden at startup');
});

final Provider<SecureCipherService> cipherProvider =
    Provider<SecureCipherService>((Ref ref) {
      throw StateError('cipherProvider must be overridden at startup');
    });

final Provider<TransactionRepository> transactionRepositoryProvider =
    Provider<TransactionRepository>((Ref ref) {
      return TransactionRepository(
        ref.watch(isarProvider),
        ref.watch(cipherProvider),
      );
    });

final Provider<CategoryRepository> categoryRepositoryProvider =
    Provider<CategoryRepository>((Ref ref) {
      return CategoryRepository(ref.watch(isarProvider));
    });

final Provider<MerchantRuleRepository> merchantRuleRepositoryProvider =
    Provider<MerchantRuleRepository>((Ref ref) {
      return MerchantRuleRepository(ref.watch(isarProvider));
    });

final Provider<SmsEngineCoordinator> smsEngineCoordinatorProvider =
    Provider<SmsEngineCoordinator>((Ref ref) {
      return SmsEngineCoordinator(
        transactionRepository: ref.watch(transactionRepositoryProvider),
        merchantRuleRepository: ref.watch(merchantRuleRepositoryProvider),
      );
    });

final Provider<AppLockService> appLockServiceProvider =
    Provider<AppLockService>((Ref ref) => AppLockService());

final StreamProvider<List<ExpenseTransaction>> pendingTransactionsProvider =
    StreamProvider<List<ExpenseTransaction>>((Ref ref) {
      return ref.watch(transactionRepositoryProvider).watchPending();
    });

final StreamProvider<List<ExpenseTransaction>> confirmedTransactionsProvider =
    StreamProvider<List<ExpenseTransaction>>((Ref ref) {
      return ref.watch(transactionRepositoryProvider).watchConfirmed();
    });

final StreamProvider<List<CategoryModel>> categoriesProvider =
    StreamProvider<List<CategoryModel>>((Ref ref) {
      return ref.watch(categoryRepositoryProvider).watchAll();
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
