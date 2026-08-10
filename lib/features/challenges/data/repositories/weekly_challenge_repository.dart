import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/challenges/data/models/weekly_challenge_model.dart';
import 'package:smart_expense_manager/features/challenges/domain/weekly_challenge.dart';
import 'package:smart_expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class WeeklyChallengeRepository {
  WeeklyChallengeRepository(this._isar);

  final Isar _isar;

  Stream<List<WeeklyChallenge>> watchAll() {
    return _isar.weeklyChallengeModels.where().watch(fireImmediately: true).map(
      (List<WeeklyChallengeModel> models) {
        models.sort((a, b) => b.weekStart.compareTo(a.weekStart));
        return models.map(_toDomain).toList(growable: false);
      },
    );
  }

  Future<int> saveCurrent({
    required WeeklyChallengeType type,
    required double targetAmount,
    required int targetDays,
    DateTime? now,
  }) async {
    final DateTime weekStart = startOfChallengeWeek(now ?? DateTime.now());
    if (type == WeeklyChallengeType.spendingCap && targetAmount <= 0) {
      throw ArgumentError.value(
        targetAmount,
        'targetAmount',
        'Weekly spending cap must be greater than zero',
      );
    }
    if (type == WeeklyChallengeType.noSpendDays &&
        (targetDays < 1 || targetDays > 7)) {
      throw ArgumentError.value(
        targetDays,
        'targetDays',
        'No-spend day target must be between 1 and 7',
      );
    }

    final List<WeeklyChallengeModel> models = await _isar.weeklyChallengeModels
        .where()
        .findAll();
    WeeklyChallengeModel? current;
    for (final WeeklyChallengeModel model in models) {
      if (model.weekStart == weekStart) {
        current = model;
        break;
      }
    }
    current ??= WeeklyChallengeModel(weekStart: weekStart);
    current
      ..type = type
      ..targetAmount = type == WeeklyChallengeType.spendingCap
          ? targetAmount
          : 0
      ..targetDays = type == WeeklyChallengeType.noSpendDays ? targetDays : 0
      ..status = WeeklyChallengeStatus.active
      ..finalizedAt = null;
    return _isar.writeTxn(() => _isar.weeklyChallengeModels.put(current!));
  }

  Future<void> deleteCurrent({DateTime? now}) async {
    final DateTime weekStart = startOfChallengeWeek(now ?? DateTime.now());
    final List<WeeklyChallengeModel> models = await _isar.weeklyChallengeModels
        .where()
        .findAll();
    final List<int> ids = models
        .where((item) {
          return item.weekStart == weekStart &&
              item.status == WeeklyChallengeStatus.active;
        })
        .map((item) => item.id)
        .toList(growable: false);
    if (ids.isEmpty) {
      return;
    }
    await _isar.writeTxn(() async {
      for (final int id in ids) {
        await _isar.weeklyChallengeModels.delete(id);
      }
    });
  }

  Future<void> clearAll() {
    return _isar.writeTxn(() => _isar.weeklyChallengeModels.clear());
  }

  Future<int> finalizeExpired({DateTime? now}) async {
    final DateTime current = now ?? DateTime.now();
    final List<WeeklyChallengeModel> challenges = await _isar
        .weeklyChallengeModels
        .where()
        .findAll();
    final List<WeeklyChallengeModel> expired = challenges
        .where((item) {
          return item.status == WeeklyChallengeStatus.active &&
              !item.weekStart.add(const Duration(days: 7)).isAfter(current);
        })
        .toList(growable: false);
    if (expired.isEmpty) {
      return 0;
    }

    final List<TransactionModel> models = await _isar.transactionModels
        .where()
        .findAll();
    final List<ExpenseTransaction> confirmed = models
        .where((item) => item.status == TransactionStatus.confirmed)
        .map(
          (item) => ExpenseTransaction(
            id: item.id,
            amount: item.amount,
            type: item.type,
            purpose: transactionPurposeFromCode(item.purposeCode, item.type),
            merchant: '',
            timestamp: item.timestamp,
            categoryId: item.categoryId,
            status: item.status,
            accountTail: '',
            originalSmsText: '',
            isManual: item.isManual,
            isRecurring: item.isRecurring,
          ),
        )
        .toList(growable: false);

    for (final WeeklyChallengeModel model in expired) {
      final WeeklyChallenge challenge = _toDomain(model);
      final WeeklyChallengeProgress progress = evaluateWeeklyChallenge(
        challenge: challenge,
        transactions: confirmed,
        now: challenge.weekEnd,
      );
      final bool won = challenge.type == WeeklyChallengeType.spendingCap
          ? progress.spent <= challenge.targetAmount
          : progress.noSpendDays >= challenge.targetDays;
      model
        ..status = won
            ? WeeklyChallengeStatus.won
            : WeeklyChallengeStatus.missed
        ..finalizedAt = current;
    }
    await _isar.writeTxn(() => _isar.weeklyChallengeModels.putAll(expired));
    return expired.length;
  }

  WeeklyChallenge _toDomain(WeeklyChallengeModel model) {
    return WeeklyChallenge(
      id: model.id,
      type: model.type,
      weekStart: model.weekStart,
      status: model.status,
      targetAmount: model.targetAmount,
      targetDays: model.targetDays,
      createdAt: model.createdAt,
      finalizedAt: model.finalizedAt,
    );
  }
}
