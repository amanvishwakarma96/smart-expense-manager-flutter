import 'dart:math' as math;

import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

enum ForecastConfidence { low, medium, high }

class SpendingForecast {
  const SpendingForecast({
    required this.variableSpend,
    required this.recurringSpend,
    required this.projectedSpend,
    required this.projectedIncome,
    required this.projectedNet,
    required this.totalBudget,
    required this.historyDays,
    required this.confidence,
  });

  final double variableSpend;
  final double recurringSpend;
  final double projectedSpend;
  final double projectedIncome;
  final double projectedNet;
  final double totalBudget;
  final int historyDays;
  final ForecastConfidence confidence;

  double get budgetUsage => totalBudget <= 0
      ? 0
      : (projectedSpend / totalBudget).clamp(0, 2).toDouble();

  bool get isOverBudget => totalBudget > 0 && projectedSpend > totalBudget;
}

class SpendingForecastService {
  const SpendingForecastService();

  static const int historyWindowDays = 60;
  static const int forecastWindowDays = 30;

  SpendingForecast calculate({
    required List<ExpenseTransaction> transactions,
    required List<RecurringTransaction> recurring,
    required List<CategoryModel> categories,
    DateTime? now,
  }) {
    final DateTime current = now ?? DateTime.now();
    final DateTime today = DateTime(current.year, current.month, current.day);
    final DateTime historyStart = today.subtract(
      const Duration(days: historyWindowDays - 1),
    );
    final List<ExpenseTransaction> history = transactions.where((item) {
      return !item.timestamp.isBefore(historyStart) &&
          !item.timestamp.isAfter(current) &&
          !item.isRecurring;
    }).toList(growable: false);

    final DateTime? earliest = history.isEmpty
        ? null
        : history
              .map((ExpenseTransaction item) => item.timestamp)
              .reduce((DateTime a, DateTime b) => a.isBefore(b) ? a : b);
    final int historyDays = earliest == null
        ? 0
        : math.min(
            historyWindowDays,
            today
                    .difference(
                      DateTime(earliest.year, earliest.month, earliest.day),
                    )
                    .inDays +
                1,
          );
    final int divisor = math.max(historyDays, 1);

    final double historicalDebit = history
        .where((ExpenseTransaction item) => item.isDebit)
        .fold(0, (double total, ExpenseTransaction item) => total + item.amount);
    final double historicalCredit = history
        .where((ExpenseTransaction item) => !item.isDebit)
        .fold(0, (double total, ExpenseTransaction item) => total + item.amount);
    final double variableSpend =
        historicalDebit / divisor * forecastWindowDays;
    final double variableIncome =
        historicalCredit / divisor * forecastWindowDays;

    final DateTime horizon = current.add(
      const Duration(days: forecastWindowDays),
    );
    double recurringSpend = 0;
    double recurringIncome = 0;
    for (final RecurringTransaction template in recurring) {
      if (!template.isActive) {
        continue;
      }
      DateTime occurrence = template.nextDueAt;
      int guard = 0;
      while (occurrence.isBefore(current) && guard < 60) {
        occurrence = _nextOccurrence(template, occurrence);
        guard += 1;
      }
      while (!occurrence.isAfter(horizon) && guard < 72) {
        if (template.isDebit) {
          recurringSpend += template.amount;
        } else {
          recurringIncome += template.amount;
        }
        occurrence = _nextOccurrence(template, occurrence);
        guard += 1;
      }
    }

    final double projectedSpend = variableSpend + recurringSpend;
    final double projectedIncome = variableIncome + recurringIncome;
    final double totalBudget = categories.fold(
      0,
      (double total, CategoryModel item) => total + item.monthlyBudgetLimit,
    );
    final ForecastConfidence confidence = historyDays >= 45
        ? ForecastConfidence.high
        : historyDays >= 14
        ? ForecastConfidence.medium
        : ForecastConfidence.low;

    return SpendingForecast(
      variableSpend: variableSpend,
      recurringSpend: recurringSpend,
      projectedSpend: projectedSpend,
      projectedIncome: projectedIncome,
      projectedNet: projectedIncome - projectedSpend,
      totalBudget: totalBudget,
      historyDays: historyDays,
      confidence: confidence,
    );
  }

  DateTime _nextOccurrence(
    RecurringTransaction template,
    DateTime current,
  ) {
    if (template.frequency == RecurringFrequency.weekly) {
      return current.add(const Duration(days: 7));
    }
    final DateTime month = DateTime(current.year, current.month + 1);
    final int lastDay = DateTime(month.year, month.month + 1, 0).day;
    final int day = math.min(template.nextDueAt.day, lastDay);
    return DateTime(
      month.year,
      month.month,
      day,
      current.hour,
      current.minute,
    );
  }
}
