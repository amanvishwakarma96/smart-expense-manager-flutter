import 'dart:math' as math;

import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/transactions/data/models/recurring_transaction_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

class RecurringTransactionRepository {
  RecurringTransactionRepository(
    Isar isar,
    SecureCipherService cipher,
  ) : this._(isar, cipher);

  RecurringTransactionRepository._(this._isar, this._cipher);

  static const int maxGeneratedOccurrencesPerTemplate = 24;

  final Isar _isar;
  final SecureCipherService _cipher;

  Stream<List<RecurringTransaction>> watchAll() {
    return _isar.recurringTransactionModels
        .where()
        .watch(fireImmediately: true)
        .asyncMap((List<RecurringTransactionModel> models) async {
          models.sort((RecurringTransactionModel a, RecurringTransactionModel b) {
            return a.nextDueAt.compareTo(b.nextDueAt);
          });
          return Future.wait(models.map(_toDomain));
        });
  }

  Future<int> save({
    int? id,
    required double amount,
    required TransactionType type,
    required String merchant,
    required RecurringFrequency frequency,
    required DateTime nextDueAt,
    int? categoryId,
    bool isActive = true,
  }) async {
    final RecurringTransactionModel model = id == null
        ? RecurringTransactionModel(nextDueAt: nextDueAt)
        : await _isar.recurringTransactionModels.get(id) ??
              RecurringTransactionModel(id: id, nextDueAt: nextDueAt);
    model
      ..amount = amount
      ..type = type
      ..encryptedMerchant = await _cipher.encrypt(merchant)
      ..categoryId = categoryId
      ..frequency = frequency
      ..scheduleDay = frequency == RecurringFrequency.weekly
          ? nextDueAt.weekday
          : nextDueAt.day
      ..nextDueAt = nextDueAt
      ..isActive = isActive;
    return _isar.writeTxn(() => _isar.recurringTransactionModels.put(model));
  }

  Future<void> setActive(int id, bool isActive) async {
    final RecurringTransactionModel? model = await _isar
        .recurringTransactionModels
        .get(id);
    if (model == null) {
      return;
    }
    model.isActive = isActive;
    await _isar.writeTxn(() => _isar.recurringTransactionModels.put(model));
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() => _isar.recurringTransactionModels.delete(id));
  }

  Future<int> generateDueTransactions({DateTime? now}) async {
    final DateTime current = now ?? DateTime.now();
    final List<RecurringTransactionModel> templates = await _isar
        .recurringTransactionModels
        .where()
        .findAll();
    final List<TransactionModel> generated = <TransactionModel>[];
    final List<RecurringTransactionModel> changed =
        <RecurringTransactionModel>[];

    for (final RecurringTransactionModel template in templates) {
      if (!template.isActive || template.nextDueAt.isAfter(current)) {
        continue;
      }
      int generatedForTemplate = 0;
      while (!template.nextDueAt.isAfter(current) &&
          generatedForTemplate < maxGeneratedOccurrencesPerTemplate) {
        generated.add(
          TransactionModel(
            amount: template.amount,
            type: template.type,
            encryptedMerchant: template.encryptedMerchant,
            timestamp: template.nextDueAt,
            categoryId: template.categoryId,
            status: TransactionStatus.pending,
            isRecurring: true,
          ),
        );
        template.nextDueAt = _nextOccurrence(template);
        generatedForTemplate += 1;
      }
      changed.add(template);
    }

    if (generated.isEmpty) {
      return 0;
    }
    await _isar.writeTxn(() async {
      await _isar.transactionModels.putAll(generated);
      await _isar.recurringTransactionModels.putAll(changed);
    });
    return generated.length;
  }

  DateTime _nextOccurrence(RecurringTransactionModel template) {
    final DateTime current = template.nextDueAt;
    if (template.frequency == RecurringFrequency.weekly) {
      return current.add(const Duration(days: 7));
    }

    final DateTime targetMonth = DateTime(current.year, current.month + 1);
    final int lastDay = DateTime(
      targetMonth.year,
      targetMonth.month + 1,
      0,
    ).day;
    final int day = math.min(template.scheduleDay, lastDay);
    return DateTime(
      targetMonth.year,
      targetMonth.month,
      day,
      current.hour,
      current.minute,
    );
  }

  Future<RecurringTransaction> _toDomain(
    RecurringTransactionModel model,
  ) async {
    return RecurringTransaction(
      id: model.id,
      amount: model.amount,
      type: model.type,
      merchant: await _cipher.decrypt(model.encryptedMerchant),
      categoryId: model.categoryId,
      frequency: model.frequency,
      nextDueAt: model.nextDueAt,
      isActive: model.isActive,
    );
  }
}
