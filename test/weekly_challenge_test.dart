import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/challenges/domain/weekly_challenge.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

void main() {
  ExpenseTransaction debit(double amount, DateTime timestamp) {
    return ExpenseTransaction(
      id: timestamp.millisecondsSinceEpoch,
      amount: amount,
      type: TransactionType.debit,
      merchant: 'Local test',
      timestamp: timestamp,
      status: TransactionStatus.confirmed,
      accountTail: '',
      originalSmsText: '',
    );
  }

  test('challenge week starts on Monday', () {
    expect(startOfChallengeWeek(DateTime(2026, 8, 7)), DateTime(2026, 8, 3));
  });

  test('spending cap tracks confirmed debit spend', () {
    final WeeklyChallenge challenge = WeeklyChallenge(
      id: 1,
      type: WeeklyChallengeType.spendingCap,
      weekStart: DateTime(2026, 8, 3),
      status: WeeklyChallengeStatus.active,
      targetAmount: 1000,
      targetDays: 0,
      createdAt: DateTime(2026, 8, 3),
    );
    final WeeklyChallengeProgress progress = evaluateWeeklyChallenge(
      challenge: challenge,
      transactions: <ExpenseTransaction>[
        debit(250, DateTime(2026, 8, 3, 12)),
        debit(150, DateTime(2026, 8, 5, 18)),
      ],
      now: DateTime(2026, 8, 6, 20),
    );

    expect(progress.spent, 400);
    expect(progress.progress, 0.4);
    expect(progress.onTrack, isTrue);
  });

  test('no-spend challenge counts only elapsed days', () {
    final WeeklyChallenge challenge = WeeklyChallenge(
      id: 2,
      type: WeeklyChallengeType.noSpendDays,
      weekStart: DateTime(2026, 8, 3),
      status: WeeklyChallengeStatus.active,
      targetAmount: 0,
      targetDays: 3,
      createdAt: DateTime(2026, 8, 3),
    );
    final WeeklyChallengeProgress progress = evaluateWeeklyChallenge(
      challenge: challenge,
      transactions: <ExpenseTransaction>[debit(100, DateTime(2026, 8, 4, 10))],
      now: DateTime(2026, 8, 5, 20),
    );

    expect(progress.elapsedDays, 3);
    expect(progress.noSpendDays, 2);
    expect(progress.progress, closeTo(2 / 3, 0.0001));
  });

  test('reward streak stops at a missed week', () {
    final List<WeeklyChallenge> history = <WeeklyChallenge>[
      WeeklyChallenge(
        id: 3,
        type: WeeklyChallengeType.spendingCap,
        weekStart: DateTime(2026, 7, 27),
        status: WeeklyChallengeStatus.won,
        targetAmount: 1000,
        targetDays: 0,
        createdAt: DateTime(2026, 7, 27),
      ),
      WeeklyChallenge(
        id: 2,
        type: WeeklyChallengeType.spendingCap,
        weekStart: DateTime(2026, 7, 20),
        status: WeeklyChallengeStatus.won,
        targetAmount: 1000,
        targetDays: 0,
        createdAt: DateTime(2026, 7, 20),
      ),
      WeeklyChallenge(
        id: 1,
        type: WeeklyChallengeType.spendingCap,
        weekStart: DateTime(2026, 7, 13),
        status: WeeklyChallengeStatus.missed,
        targetAmount: 1000,
        targetDays: 0,
        createdAt: DateTime(2026, 7, 13),
      ),
    ];

    final ChallengeRewardSummary rewards = summarizeChallengeRewards(history);
    expect(rewards.currentStreak, 2);
    expect(rewards.totalWins, 2);
    expect(rewards.firstWinUnlocked, isTrue);
    expect(rewards.threeWeekStreakUnlocked, isFalse);
  });
}
