import 'dart:math' as math;

import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

enum WeeklyChallengeType { spendingCap, noSpendDays }

enum WeeklyChallengeStatus { active, won, missed }

class WeeklyChallenge {
  const WeeklyChallenge({
    required this.id,
    required this.type,
    required this.weekStart,
    required this.status,
    required this.targetAmount,
    required this.targetDays,
    required this.createdAt,
    this.finalizedAt,
  });

  final int id;
  final WeeklyChallengeType type;
  final DateTime weekStart;
  final WeeklyChallengeStatus status;
  final double targetAmount;
  final int targetDays;
  final DateTime createdAt;
  final DateTime? finalizedAt;

  DateTime get weekEnd => weekStart.add(const Duration(days: 7));
  bool get isActive => status == WeeklyChallengeStatus.active;
}

class WeeklyChallengeProgress {
  const WeeklyChallengeProgress({
    required this.progress,
    required this.spent,
    required this.noSpendDays,
    required this.elapsedDays,
    required this.onTrack,
  });

  final double progress;
  final double spent;
  final int noSpendDays;
  final int elapsedDays;
  final bool onTrack;
}

class ChallengeRewardSummary {
  const ChallengeRewardSummary({
    required this.totalWins,
    required this.currentStreak,
  });

  final int totalWins;
  final int currentStreak;

  bool get firstWinUnlocked => totalWins >= 1;
  bool get threeWeekStreakUnlocked => currentStreak >= 3;
  bool get fiveWinsUnlocked => totalWins >= 5;
  bool get tenWinsUnlocked => totalWins >= 10;
}

DateTime startOfChallengeWeek(DateTime value) {
  final DateTime day = DateTime(value.year, value.month, value.day);
  return day.subtract(Duration(days: day.weekday - DateTime.monday));
}

WeeklyChallengeProgress evaluateWeeklyChallenge({
  required WeeklyChallenge challenge,
  required List<ExpenseTransaction> transactions,
  DateTime? now,
}) {
  final DateTime current = now ?? DateTime.now();
  final DateTime evaluationEnd = current.isBefore(challenge.weekEnd)
      ? current
      : challenge.weekEnd.subtract(const Duration(microseconds: 1));
  final List<ExpenseTransaction> debits = transactions
      .where((item) {
        return item.isDebit &&
            !item.timestamp.isBefore(challenge.weekStart) &&
            item.timestamp.isBefore(challenge.weekEnd);
      })
      .toList(growable: false);
  final double spent = debits.fold(
    0,
    (double total, ExpenseTransaction item) => total + item.amount,
  );
  final int elapsedDays = evaluationEnd.isBefore(challenge.weekStart)
      ? 0
      : math
            .min(
              7,
              DateTime(
                    evaluationEnd.year,
                    evaluationEnd.month,
                    evaluationEnd.day,
                  ).difference(challenge.weekStart).inDays +
                  1,
            )
            .toInt();
  int noSpendDays = 0;
  for (int offset = 0; offset < elapsedDays; offset += 1) {
    final DateTime day = challenge.weekStart.add(Duration(days: offset));
    final bool spentOnDay = debits.any((item) {
      return item.timestamp.year == day.year &&
          item.timestamp.month == day.month &&
          item.timestamp.day == day.day;
    });
    if (!spentOnDay) {
      noSpendDays += 1;
    }
  }

  if (challenge.type == WeeklyChallengeType.spendingCap) {
    final double target = math.max(challenge.targetAmount, 0.01).toDouble();
    return WeeklyChallengeProgress(
      progress: (spent / target).clamp(0, 1).toDouble(),
      spent: spent,
      noSpendDays: noSpendDays,
      elapsedDays: elapsedDays,
      onTrack: spent <= target,
    );
  }

  final int targetDays = math.max(challenge.targetDays, 1).toInt();
  final int remainingDays = math.max(7 - elapsedDays, 0).toInt();
  return WeeklyChallengeProgress(
    progress: (noSpendDays / targetDays).clamp(0, 1).toDouble(),
    spent: spent,
    noSpendDays: noSpendDays,
    elapsedDays: elapsedDays,
    onTrack: noSpendDays + remainingDays >= targetDays,
  );
}

ChallengeRewardSummary summarizeChallengeRewards(
  List<WeeklyChallenge> challenges,
) {
  final List<WeeklyChallenge> completed =
      challenges
          .where((item) => item.status != WeeklyChallengeStatus.active)
          .toList()
        ..sort((a, b) => b.weekStart.compareTo(a.weekStart));
  final int totalWins = completed
      .where((item) => item.status == WeeklyChallengeStatus.won)
      .length;
  int streak = 0;
  DateTime? expectedWeek;
  for (final WeeklyChallenge item in completed) {
    if (expectedWeek != null && item.weekStart != expectedWeek) {
      break;
    }
    if (item.status != WeeklyChallengeStatus.won) {
      break;
    }
    streak += 1;
    expectedWeek = item.weekStart.subtract(const Duration(days: 7));
  }
  return ChallengeRewardSummary(totalWins: totalWins, currentStreak: streak);
}
