import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/goals/data/models/savings_goal_model.dart';
import 'package:smart_expense_manager/features/goals/domain/savings_goal.dart';

class SavingsGoalRepository {
  SavingsGoalRepository(Isar isar, SecureCipherService cipher)
    : this._(isar, cipher);

  SavingsGoalRepository._(this._isar, this._cipher);

  final Isar _isar;
  final SecureCipherService _cipher;

  Stream<List<SavingsGoal>> watchActive() {
    return _isar.savingsGoalModels
        .where()
        .watch(fireImmediately: true)
        .asyncMap((List<SavingsGoalModel> models) async {
          final List<SavingsGoalModel> active = models
              .where((SavingsGoalModel item) => !item.isArchived)
              .toList();
          active.sort((SavingsGoalModel a, SavingsGoalModel b) {
            final bool aComplete = a.savedAmount >= a.targetAmount;
            final bool bComplete = b.savedAmount >= b.targetAmount;
            if (aComplete != bComplete) {
              return aComplete ? 1 : -1;
            }
            final DateTime? aDate = a.targetDate;
            final DateTime? bDate = b.targetDate;
            if (aDate == null && bDate == null) {
              return b.updatedAt.compareTo(a.updatedAt);
            }
            if (aDate == null) {
              return 1;
            }
            if (bDate == null) {
              return -1;
            }
            return aDate.compareTo(bDate);
          });
          return Future.wait(active.map(_toDomain));
        });
  }

  Future<int> save({
    int? id,
    required String name,
    required double targetAmount,
    required double savedAmount,
    required String hexColor,
    required String iconName,
    DateTime? targetDate,
    bool isArchived = false,
  }) async {
    final String normalizedName = name.trim();
    if (normalizedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Goal name must not be empty');
    }
    if (targetAmount <= 0) {
      throw ArgumentError.value(
        targetAmount,
        'targetAmount',
        'Target amount must be greater than zero',
      );
    }
    if (savedAmount < 0) {
      throw ArgumentError.value(
        savedAmount,
        'savedAmount',
        'Saved amount must not be negative',
      );
    }

    final SavingsGoalModel model = id == null
        ? SavingsGoalModel()
        : await _isar.savingsGoalModels.get(id) ?? SavingsGoalModel(id: id);
    model
      ..encryptedName = await _cipher.encrypt(normalizedName)
      ..targetAmount = targetAmount
      ..savedAmount = savedAmount
      ..targetDate = targetDate
      ..hexColor = hexColor
      ..iconName = iconName
      ..isArchived = isArchived
      ..updatedAt = DateTime.now();
    return _isar.writeTxn(() => _isar.savingsGoalModels.put(model));
  }

  Future<void> addContribution(int id, double amount) async {
    if (amount <= 0) {
      throw ArgumentError.value(
        amount,
        'amount',
        'Contribution must be greater than zero',
      );
    }
    final SavingsGoalModel? model = await _isar.savingsGoalModels.get(id);
    if (model == null || model.isArchived) {
      return;
    }
    model
      ..savedAmount += amount
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.savingsGoalModels.put(model));
  }

  Future<void> setArchived(int id, bool archived) async {
    final SavingsGoalModel? model = await _isar.savingsGoalModels.get(id);
    if (model == null) {
      return;
    }
    model
      ..isArchived = archived
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.savingsGoalModels.put(model));
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() => _isar.savingsGoalModels.delete(id));
  }

  Future<SavingsGoal> _toDomain(SavingsGoalModel model) async {
    return SavingsGoal(
      id: model.id,
      name: await _cipher.decrypt(model.encryptedName),
      targetAmount: model.targetAmount,
      savedAmount: model.savedAmount,
      targetDate: model.targetDate,
      hexColor: model.hexColor,
      iconName: model.iconName,
      isArchived: model.isArchived,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}
