import 'dart:math' as math;

import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

enum SafeToSpendBasis { incomeAndBudget, incomeOnly, budgetOnly, unavailable }

class UpcomingBill {
  const UpcomingBill({
    required this.recurringId,
    required this.name,
    required this.amount,
    required this.dueAt,
  });

  final int recurringId;
  final String name;
  final double amount;
  final DateTime dueAt;
}

class SafeToSpendPlan {
  const SafeToSpendPlan({
    required this.confirmedIncome,
    required this.confirmedSpending,
    required this.totalBudget,
    required this.remainingBudget,
    required this.upcomingBillTotal,
    required this.safeToSpend,
    required this.safePerDay,
    required this.daysRemaining,
    required this.basis,
    required this.upcomingBills,
  });

  final double confirmedIncome;
  final double confirmedSpending;
  final double totalBudget;
  final double remainingBudget;
  final double upcomingBillTotal;
  final double safeToSpend;
  final double safePerDay;
  final int daysRemaining;
  final SafeToSpendBasis basis;
  final List<UpcomingBill> upcomingBills;
}

class SafeToSpendService {
  const SafeToSpendService();

  SafeToSpendPlan calculate({
    required List<ExpenseTransaction> transactions,
    required List<RecurringTransaction> recurring,
    required List<CategoryModel> categories,
    DateTime? now,
  }) {
    final DateTime current = now ?? DateTime.now();
    final DateTime monthStart = DateTime(current.year, current.month);
    final DateTime nextMonth = DateTime(current.year, current.month + 1);
    final DateTime today = DateTime(current.year, current.month, current.day);
    final int daysRemaining = math.max(nextMonth.difference(today).inDays, 1);

    final List<ExpenseTransaction> thisMonth = transactions
        .where((ExpenseTransaction item) {
          return !item.timestamp.isBefore(monthStart) &&
              item.timestamp.isBefore(nextMonth);
        })
        .toList(growable: false);
    final double income = thisMonth
        .where((ExpenseTransaction item) => !item.isDebit)
        .fold(
          0,
          (double total, ExpenseTransaction item) => total + item.amount,
        );
    final double spending = thisMonth
        .where((ExpenseTransaction item) => item.isDebit)
        .fold(
          0,
          (double total, ExpenseTransaction item) => total + item.amount,
        );
    final double totalBudget = categories.fold(
      0,
      (double total, CategoryModel category) =>
          total + category.monthlyBudgetLimit,
    );
    final double remainingBudget = math.max(totalBudget - spending, 0);

    final List<UpcomingBill> upcomingBills = <UpcomingBill>[];
    for (final RecurringTransaction template in recurring) {
      if (!template.isActive || !template.isDebit) {
        continue;
      }
      DateTime occurrence = template.nextDueAt;
      int guard = 0;
      while (occurrence.isBefore(current) && guard < 60) {
        occurrence = _nextOccurrence(template, occurrence);
        guard += 1;
      }
      while (occurrence.isBefore(nextMonth) && guard < 72) {
        upcomingBills.add(
          UpcomingBill(
            recurringId: template.id,
            name: template.merchant,
            amount: template.amount,
            dueAt: occurrence,
          ),
        );
        occurrence = _nextOccurrence(template, occurrence);
        guard += 1;
      }
    }
    upcomingBills.sort((UpcomingBill a, UpcomingBill b) {
      return a.dueAt.compareTo(b.dueAt);
    });
    final double upcomingBillTotal = upcomingBills.fold(
      0,
      (double total, UpcomingBill bill) => total + bill.amount,
    );

    final double cashAfterBills = math.max(
      income - spending - upcomingBillTotal,
      0,
    );
    final double budgetAfterBills = math.max(
      remainingBudget - upcomingBillTotal,
      0,
    );

    late final SafeToSpendBasis basis;
    late final double safeToSpend;
    if (income > 0 && totalBudget > 0) {
      basis = SafeToSpendBasis.incomeAndBudget;
      safeToSpend = math.min(cashAfterBills, budgetAfterBills);
    } else if (income > 0) {
      basis = SafeToSpendBasis.incomeOnly;
      safeToSpend = cashAfterBills;
    } else if (totalBudget > 0) {
      basis = SafeToSpendBasis.budgetOnly;
      safeToSpend = budgetAfterBills;
    } else {
      basis = SafeToSpendBasis.unavailable;
      safeToSpend = 0;
    }

    return SafeToSpendPlan(
      confirmedIncome: income,
      confirmedSpending: spending,
      totalBudget: totalBudget,
      remainingBudget: remainingBudget,
      upcomingBillTotal: upcomingBillTotal,
      safeToSpend: safeToSpend,
      safePerDay: safeToSpend / daysRemaining,
      daysRemaining: daysRemaining,
      basis: basis,
      upcomingBills: List<UpcomingBill>.unmodifiable(upcomingBills),
    );
  }

  DateTime _nextOccurrence(RecurringTransaction template, DateTime current) {
    if (template.frequency == RecurringFrequency.weekly) {
      return current.add(const Duration(days: 7));
    }
    final DateTime month = DateTime(current.year, current.month + 1);
    final int lastDay = DateTime(month.year, month.month + 1, 0).day;
    final int day = math.min(template.nextDueAt.day, lastDay);
    return DateTime(month.year, month.month, day, current.hour, current.minute);
  }
}
