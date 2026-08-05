import 'package:isar_community/isar.dart';

part 'savings_goal_model.g.dart';

@collection
class SavingsGoalModel {
  SavingsGoalModel({
    this.id = Isar.autoIncrement,
    this.encryptedName = '',
    this.targetAmount = 0,
    this.savedAmount = 0,
    this.targetDate,
    this.hexColor = 'CBB8FF',
    this.iconName = 'savings',
    this.isArchived = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  Id id;
  String encryptedName;
  double targetAmount;
  double savedAmount;
  DateTime? targetDate;
  String hexColor;
  String iconName;
  bool isArchived;
  DateTime createdAt;
  DateTime updatedAt;
}
