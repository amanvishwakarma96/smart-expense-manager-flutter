import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/goals/domain/savings_goal.dart';

void main() {
  SavingsGoal goal({required double saved, double target = 1000}) {
    final DateTime now = DateTime(2026, 8, 5);
    return SavingsGoal(
      id: 1,
      name: 'Emergency fund',
      targetAmount: target,
      savedAmount: saved,
      hexColor: 'CBB8FF',
      iconName: 'savings',
      isArchived: false,
      createdAt: now,
      updatedAt: now,
    );
  }

  test('progress and remaining values are clamped safely', () {
    expect(goal(saved: 250).progress, 0.25);
    expect(goal(saved: 250).remaining, 750);
    expect(goal(saved: 1400).progress, 1);
    expect(goal(saved: 1400).remaining, 0);
    expect(goal(saved: 1400).isComplete, isTrue);
  });

  test('milestone stars unlock at each progress band', () {
    expect(goal(saved: 0).earnedMilestones, 0);
    expect(goal(saved: 1).earnedMilestones, 1);
    expect(goal(saved: 250).earnedMilestones, 2);
    expect(goal(saved: 500).earnedMilestones, 3);
    expect(goal(saved: 750).earnedMilestones, 4);
    expect(goal(saved: 1000).earnedMilestones, 5);
  });
}
