import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/challenges/data/models/weekly_challenge_model.dart';
import 'package:smart_expense_manager/features/goals/data/models/savings_goal_model.dart';
import 'package:smart_expense_manager/features/settings/services/bill_reminder_service.dart';
import 'package:smart_expense_manager/features/settings/services/budget_alert_service.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/recurring_transaction_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class TransactionRepository {
  TransactionRepository(
    Isar isar,
    SecureCipherService cipher, {
    BudgetAlertService? budgetAlertService,
    BillReminderService? reminderService,
  }) : this._(isar, cipher, budgetAlertService, reminderService);

  TransactionRepository._(
    this._isar,
    this._cipher,
    this._budgetAlertService,
    this._reminderService,
  );

  final Isar _isar;
  final SecureCipherService _cipher;
  final BudgetAlertService? _budgetAlertService;
  final BillReminderService? _reminderService;

  Stream<List<ExpenseTransaction>> watchPending() {
    return _isar.transactionModels
        .where()
        .watch(fireImmediately: true)
        .asyncMap((List<TransactionModel> models) async {
          final List<TransactionModel> pending =
              models.where((TransactionModel item) {
                return item.status == TransactionStatus.pending;
              }).toList()..sort((TransactionModel a, TransactionModel b) {
                return b.timestamp.compareTo(a.timestamp);
              });
          return Future.wait(pending.map(_toDomain));
        });
  }

  Stream<List<ExpenseTransaction>> watchConfirmed() {
    return _isar.transactionModels
        .where()
        .watch(fireImmediately: true)
        .asyncMap((List<TransactionModel> models) async {
          final List<TransactionModel> confirmed =
              models.where((TransactionModel item) {
                return item.status == TransactionStatus.confirmed;
              }).toList()..sort((TransactionModel a, TransactionModel b) {
                return b.timestamp.compareTo(a.timestamp);
              });
          return Future.wait(confirmed.map(_toDomain));
        });
  }

  Future<bool> containsFingerprint(String fingerprint) async {
    final List<TransactionModel> models = await _isar.transactionModels
        .where()
        .findAll();
    return models.any((TransactionModel item) {
      return item.smsFingerprint == fingerprint;
    });
  }

  Future<int> addSmsTransaction({
    required double amount,
    required TransactionType type,
    required String merchant,
    required DateTime timestamp,
    required String accountTail,
    required String originalSmsText,
    required String fingerprint,
    int? categoryId,
  }) async {
    if (await containsFingerprint(fingerprint)) {
      return -1;
    }

    final TransactionModel model = TransactionModel(
      amount: amount,
      type: type,
      encryptedMerchant: await _cipher.encrypt(merchant),
      timestamp: timestamp,
      categoryId: categoryId,
      encryptedAccountTail: await _cipher.encrypt(accountTail),
      encryptedOriginalSmsText: await _cipher.encrypt(originalSmsText),
      smsFingerprint: fingerprint,
    );
    return _isar.writeTxn(() => _isar.transactionModels.put(model));
  }

  Future<int> addManualTransaction({
    required double amount,
    required TransactionType type,
    required String merchant,
    required DateTime timestamp,
    int? categoryId,
  }) async {
    final TransactionModel model = TransactionModel(
      amount: amount,
      type: type,
      encryptedMerchant: await _cipher.encrypt(merchant),
      timestamp: timestamp,
      categoryId: categoryId,
      status: TransactionStatus.confirmed,
      isManual: true,
    );
    final int id = await _isar.writeTxn(
      () => _isar.transactionModels.put(model),
    );
    await _budgetAlertService?.checkCategory(categoryId);
    return id;
  }

  Future<void> confirm(int id, {int? categoryId}) async {
    final TransactionModel? model = await _isar.transactionModels.get(id);
    if (model == null) {
      return;
    }
    model
      ..status = TransactionStatus.confirmed
      ..categoryId = categoryId ?? model.categoryId
      ..encryptedOriginalSmsText = '';
    await _isar.writeTxn(() => _isar.transactionModels.put(model));
    await _budgetAlertService?.checkCategory(model.categoryId);
  }

  Future<void> updatePending({
    required int id,
    required double amount,
    required String merchant,
    required TransactionType type,
    int? categoryId,
  }) async {
    final TransactionModel? model = await _isar.transactionModels.get(id);
    if (model == null) {
      return;
    }
    model
      ..amount = amount
      ..type = type
      ..categoryId = categoryId
      ..encryptedMerchant = await _cipher.encrypt(merchant);
    await _isar.writeTxn(() => _isar.transactionModels.put(model));
  }

  Future<void> updateConfirmed({
    required int id,
    required double amount,
    required String merchant,
    required TransactionType type,
    required DateTime timestamp,
    int? categoryId,
  }) async {
    final TransactionModel? model = await _isar.transactionModels.get(id);
    if (model == null || model.status != TransactionStatus.confirmed) {
      return;
    }
    final int? previousCategoryId = model.categoryId;
    model
      ..amount = amount
      ..type = type
      ..timestamp = timestamp
      ..categoryId = categoryId
      ..encryptedMerchant = await _cipher.encrypt(merchant);
    await _isar.writeTxn(() => _isar.transactionModels.put(model));
    await _budgetAlertService?.checkCategory(previousCategoryId);
    if (categoryId != previousCategoryId) {
      await _budgetAlertService?.checkCategory(categoryId);
    }
  }

  Future<void> delete(int id) {
    return _isar.writeTxn(() async {
      await _isar.transactionModels.delete(id);
    });
  }

  Future<void> clearAll() async {
    final List<int> recurringIds =
        (await _isar.recurringTransactionModels.where().findAll())
            .map((RecurringTransactionModel item) => item.id)
            .toList(growable: false);
    await _isar.writeTxn(() async {
      await _isar.transactionModels.clear();
      await _isar.recurringTransactionModels.clear();
      await _isar.savingsGoalModels.clear();
      await _isar.weeklyChallengeModels.clear();
      await _isar.merchantRuleModels.clear();
      await _isar.categoryModels.clear();
    });
    for (final int id in recurringIds) {
      await _reminderService?.cancelForTemplate(id);
    }
  }

  Future<String> fingerprintFor(String value) async {
    final Hash hash = await Sha256().hash(utf8.encode(value));
    return hash.bytes
        .map((int byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
  }

  Future<ExpenseTransaction> _toDomain(TransactionModel model) async {
    return ExpenseTransaction(
      id: model.id,
      amount: model.amount,
      type: model.type,
      merchant: await _cipher.decrypt(model.encryptedMerchant),
      timestamp: model.timestamp,
      categoryId: model.categoryId,
      status: model.status,
      accountTail: await _cipher.decrypt(model.encryptedAccountTail),
      originalSmsText: await _cipher.decrypt(model.encryptedOriginalSmsText),
      isManual: model.isManual,
      isRecurring: model.isRecurring,
    );
  }
}
