import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/dashboard/domain/spending_forecast.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

ExpenseTransaction transaction({
  required int id,
  required double amount,
  required TransactionType type,
  required DateTime timestamp,
  bool isRecurring = false,
}) {
  return ExpenseTransaction(
    id: id,
    amount: amount,
    type: type,
    merchant: 'Test',
    timestamp: timestamp,
    status: TransactionStatus.confirmed,
    accountTail: '',
    originalSmsText: '',
    isRecurring: isRecurring,
  );
}

void main() {
  const SpendingForecastService service = SpendingForecastService();

  test('projects variable spending from observed local history', () {
    final DateTime now = DateTime(2026, 8, 5, 12);
    final SpendingForecast result = service.calculate(
      now: now,
      transactions: <ExpenseTransaction>[
        transaction(
          id: 1,
          amount: 500,
          type: TransactionType.debit,
          timestamp: DateTime(2026, 8, 1),
        ),
        transaction(
          id: 2,
          amount: 250,
          type: TransactionType.credit,
          timestamp: DateTime(2026, 8, 3),
        ),
      ],
      recurring: const <RecurringTransaction>[],
      categories: <CategoryModel>[
        CategoryModel(name: 'Food', monthlyBudgetLimit: 5000),
      ],
    );

    expect(result.historyDays, 5);
    expect(result.variableSpend, 3000);
    expect(result.projectedIncome, 1500);
    expect(result.projectedNet, -1500);
    expect(result.confidence, ForecastConfidence.low);
  });

  test('adds upcoming weekly and monthly recurring occurrences', () {
    final DateTime now = DateTime(2026, 8, 5, 12);
    final SpendingForecast result = service.calculate(
      now: now,
      transactions: const <ExpenseTransaction>[],
      recurring: <RecurringTransaction>[
        RecurringTransaction(
          id: 1,
          amount: 100,
          type: TransactionType.debit,
          merchant: 'Weekly',
          frequency: RecurringFrequency.weekly,
          nextDueAt: DateTime(2026, 8, 6, 9),
          isActive: true,
        ),
        RecurringTransaction(
          id: 2,
          amount: 1000,
          type: TransactionType.debit,
          merchant: 'Monthly',
          frequency: RecurringFrequency.monthly,
          nextDueAt: DateTime(2026, 8, 10, 9),
          isActive: true,
        ),
        RecurringTransaction(
          id: 3,
          amount: 2000,
          type: TransactionType.credit,
          merchant: 'Income',
          frequency: RecurringFrequency.monthly,
          nextDueAt: DateTime(2026, 8, 7, 9),
          isActive: true,
        ),
      ],
      categories: const <CategoryModel>[],
    );

    expect(result.recurringSpend, 1500);
    expect(result.projectedSpend, 1500);
    expect(result.projectedIncome, 2000);
    expect(result.projectedNet, 500);
  });

  test('ignores recurring history to avoid double counting', () {
    final DateTime now = DateTime(2026, 8, 30);
    final SpendingForecast result = service.calculate(
      now: now,
      transactions: <ExpenseTransaction>[
        transaction(
          id: 1,
          amount: 5000,
          type: TransactionType.debit,
          timestamp: DateTime(2026, 8, 1),
          isRecurring: true,
        ),
      ],
      recurring: const <RecurringTransaction>[],
      categories: const <CategoryModel>[],
    );

    expect(result.variableSpend, 0);
    expect(result.projectedSpend, 0);
  });

  test('uses high confidence after at least 45 observed days', () {
    final DateTime now = DateTime(2026, 8, 30);
    final SpendingForecast result = service.calculate(
      now: now,
      transactions: <ExpenseTransaction>[
        transaction(
          id: 1,
          amount: 6000,
          type: TransactionType.debit,
          timestamp: DateTime(2026, 7, 15),
        ),
      ],
      recurring: const <RecurringTransaction>[],
      categories: const <CategoryModel>[],
    );

    expect(result.historyDays, 47);
    expect(result.confidence, ForecastConfidence.high);
  });
}
