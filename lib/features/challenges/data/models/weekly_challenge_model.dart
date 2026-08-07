import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/challenges/domain/weekly_challenge.dart';

part 'weekly_challenge_model.g.dart';

@collection
class WeeklyChallengeModel {
  WeeklyChallengeModel({
    this.id = Isar.autoIncrement,
    this.type = WeeklyChallengeType.spendingCap,
    required this.weekStart,
    this.status = WeeklyChallengeStatus.active,
    this.targetAmount = 0,
    this.targetDays = 0,
    DateTime? createdAt,
    this.finalizedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Id id;

  @enumerated
  WeeklyChallengeType type;

  DateTime weekStart;

  @enumerated
  WeeklyChallengeStatus status;

  double targetAmount;
  int targetDays;
  DateTime createdAt;
  DateTime? finalizedAt;
}
