class SavingsGoal {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.hexColor,
    required this.iconName,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    this.targetDate,
  });

  final int id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final DateTime? targetDate;
  final String hexColor;
  final String iconName;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;

  double get progress {
    if (targetAmount <= 0) {
      return 0;
    }
    return (savedAmount / targetAmount).clamp(0, 1).toDouble();
  }

  double get remaining => (targetAmount - savedAmount).clamp(0, targetAmount);

  bool get isComplete => savedAmount >= targetAmount;

  int get earnedMilestones {
    if (savedAmount <= 0) {
      return 0;
    }
    if (progress >= 1) {
      return 5;
    }
    if (progress >= 0.75) {
      return 4;
    }
    if (progress >= 0.5) {
      return 3;
    }
    if (progress >= 0.25) {
      return 2;
    }
    return 1;
  }
}
