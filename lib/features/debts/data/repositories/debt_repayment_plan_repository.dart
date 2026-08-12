import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/debts/data/models/debt_repayment_plan_model.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_repayment_plan.dart';

class DebtRepaymentPlanRepository {
  const DebtRepaymentPlanRepository(this._isar);

  final Isar _isar;

  Stream<DebtRepaymentPlan?> watchForDebt(int debtId) {
    return _isar.debtRepaymentPlanModels
        .where()
        .watch(fireImmediately: true)
        .map((List<DebtRepaymentPlanModel> models) {
          DebtRepaymentPlanModel? latest;
          for (final DebtRepaymentPlanModel model in models) {
            if (model.debtId != debtId) {
              continue;
            }
            if (latest == null || model.updatedAt.isAfter(latest.updatedAt)) {
              latest = model;
            }
          }
          return latest == null ? null : _toDomain(latest);
        });
  }

  Future<DebtRepaymentPlan?> getForDebt(int debtId) async {
    final List<DebtRepaymentPlanModel> models = await _isar
        .debtRepaymentPlanModels
        .where()
        .findAll();
    DebtRepaymentPlanModel? latest;
    for (final DebtRepaymentPlanModel model in models) {
      if (model.debtId != debtId) {
        continue;
      }
      if (latest == null || model.updatedAt.isAfter(latest.updatedAt)) {
        latest = model;
      }
    }
    return latest == null ? null : _toDomain(latest);
  }

  Future<int> save({
    required int debtId,
    required RepaymentCadence cadence,
    required double installmentAmount,
    required double annualInterestRatePct,
    required DateTime firstDueDate,
    required double startingOutstanding,
    required double baselineRepaidAmount,
  }) async {
    if (debtId <= 0) {
      throw ArgumentError.value(debtId, 'debtId', 'Debt ID must be positive');
    }
    if (installmentAmount <= 0) {
      throw ArgumentError.value(
        installmentAmount,
        'installmentAmount',
        'Installment amount must be greater than zero',
      );
    }
    if (annualInterestRatePct < 0 || annualInterestRatePct > 100) {
      throw ArgumentError.value(
        annualInterestRatePct,
        'annualInterestRatePct',
        'Interest rate must be between 0 and 100',
      );
    }
    if (startingOutstanding < 0 || baselineRepaidAmount < 0) {
      throw ArgumentError('Repayment-plan balances must not be negative');
    }

    final List<DebtRepaymentPlanModel> models = await _isar
        .debtRepaymentPlanModels
        .where()
        .findAll();
    final List<DebtRepaymentPlanModel> matches = models
        .where((DebtRepaymentPlanModel item) => item.debtId == debtId)
        .toList(growable: false);
    final DebtRepaymentPlanModel model = matches.isEmpty
        ? DebtRepaymentPlanModel(debtId: debtId)
        : matches.first;
    model
      ..cadence = cadence
      ..installmentAmount = installmentAmount
      ..annualInterestRatePct = annualInterestRatePct
      ..firstDueDate = DateTime(
        firstDueDate.year,
        firstDueDate.month,
        firstDueDate.day,
      )
      ..startingOutstanding = startingOutstanding
      ..baselineRepaidAmount = baselineRepaidAmount
      ..isPaused = false
      ..updatedAt = DateTime.now();

    final List<int> duplicateIds = matches
        .skip(1)
        .map((DebtRepaymentPlanModel item) => item.id)
        .toList(growable: false);
    return _isar.writeTxn(() async {
      if (duplicateIds.isNotEmpty) {
        await _isar.debtRepaymentPlanModels.deleteAll(duplicateIds);
      }
      return _isar.debtRepaymentPlanModels.put(model);
    });
  }

  Future<void> setPaused(int debtId, bool paused) async {
    final List<DebtRepaymentPlanModel> models = await _isar
        .debtRepaymentPlanModels
        .where()
        .findAll();
    final DebtRepaymentPlanModel? model = models
        .where((DebtRepaymentPlanModel item) => item.debtId == debtId)
        .firstOrNull;
    if (model == null) {
      return;
    }
    model
      ..isPaused = paused
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.debtRepaymentPlanModels.put(model));
  }

  Future<void> deleteForDebt(int debtId) async {
    final List<DebtRepaymentPlanModel> models = await _isar
        .debtRepaymentPlanModels
        .where()
        .findAll();
    final List<int> ids = models
        .where((DebtRepaymentPlanModel item) => item.debtId == debtId)
        .map((DebtRepaymentPlanModel item) => item.id)
        .toList(growable: false);
    if (ids.isEmpty) {
      return;
    }
    await _isar.writeTxn(() => _isar.debtRepaymentPlanModels.deleteAll(ids));
  }

  Future<void> clearAll() async {
    await _isar.writeTxn(() => _isar.debtRepaymentPlanModels.clear());
  }

  DebtRepaymentPlan _toDomain(DebtRepaymentPlanModel model) {
    return DebtRepaymentPlan(
      id: model.id,
      debtId: model.debtId,
      cadence: model.cadence,
      installmentAmount: model.installmentAmount,
      annualInterestRatePct: model.annualInterestRatePct,
      firstDueDate: model.firstDueDate,
      startingOutstanding: model.startingOutstanding,
      baselineRepaidAmount: model.baselineRepaidAmount,
      isPaused: model.isPaused,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
