import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/dashboard/domain/safe_to_spend.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

void main() {
  const SafeToSpendService service = SafeToSpendService();

  test('uses the lower of cash and budget after upcoming bills', () {
    final SafeToSpendPlan plan = service.calculate(
      now: DateTime(2026, 8, 10, 12),
      transactions: <ExpenseTransaction>[
        _transaction(
          id: 1,
          amount: 50000,
          type: TransactionType.credit,
          timestamp: DateTime(2026, 8, 1),
        ),
        _transaction(
          id: 2,
          amount: 10000,
          type: TransactionType.debit,
          timestamp: DateTime(2026, 8, 5),
        ),
      ],
      recurring: <RecurringTransaction>[
        _recurring(
          id: 1,
          amount: 5000,
          type: TransactionType.debit,
          dueAt: DateTime(2026, 8, 20),
        ),
      ],
      categories: <CategoryModel>[
        CategoryModel(name: 'Monthly', monthlyBudgetLimit: 30000),
      ],
    );

    expect(plan.basis, SafeToSpendBasis.incomeAndBudget);
    expect(plan.upcomingBillTotal, 5000);
    expect(plan.safeToSpend, 15000);
    expect(plan.daysRemaining, 22);
  });

  test('falls back to remaining budgets when no income is recorded', () {
    final SafeToSpendPlan plan = service.calculate(
      now: DateTime(2026, 8, 10),
      transactions: <ExpenseTransaction>[
        _transaction(
          id: 1,
          amount: 2000,
          type: TransactionType.debit,
          timestamp: DateTime(2026, 8, 3),
        ),
      ],
      recurring: <RecurringTransaction>[
        _recurring(
          id: 1,
          amount: 3000,
          type: TransactionType.debit,
          dueAt: DateTime(2026, 8, 20),
        ),
      ],
      categories: <CategoryModel>[
        CategoryModel(name: 'Monthly', monthlyBudgetLimit: 10000),
      ],
    );

    expect(plan.basis, SafeToSpendBasis.budgetOnly);
    expect(plan.safeToSpend, 5000);
  });

  test('does not assume future recurring income', () {
    final SafeToSpendPlan plan = service.calculate(
      now: DateTime(2026, 8, 10),
      transactions: const <ExpenseTransaction>[],
      recurring: <RecurringTransaction>[
        _recurring(
          id: 1,
          amount: 50000,
          type: TransactionType.credit,
          dueAt: DateTime(2026, 8, 15),
        ),
      ],
      categories: const <CategoryModel>[],
    );

    expect(plan.basis, SafeToSpendBasis.unavailable);
    expect(plan.safeToSpend, 0);
    expect(plan.upcomingBillTotal, 0);
  });

  test('counts every weekly debit due before month end', () {
    final SafeToSpendPlan plan = service.calculate(
      now: DateTime(2026, 8, 10),
      transactions: const <ExpenseTransaction>[],
      recurring: <RecurringTransaction>[
        _recurring(
          id: 1,
          amount: 1000,
          type: TransactionType.debit,
          dueAt: DateTime(2026, 8, 12),
          frequency: RecurringFrequency.weekly,
        ),
      ],
      categories: <CategoryModel>[
        CategoryModel(name: 'Monthly', monthlyBudgetLimit: 10000),
      ],
    );

    expect(plan.upcomingBills.length, 3);
    expect(plan.upcomingBillTotal, 3000);
    expect(plan.safeToSpend, 7000);
  });
}

ExpenseTransaction _transaction({
  required int id,
  required double amount,
  required TransactionType type,
  required DateTime timestamp,
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
  );
}

RecurringTransaction _recurring({
  required int id,
  required double amount,
  required TransactionType type,
  required DateTime dueAt,
  RecurringFrequency frequency = RecurringFrequency.monthly,
}) {
  return RecurringTransaction(
    id: id,
    amount: amount,
    type: type,
    merchant: 'Scheduled item',
    frequency: frequency,
    nextDueAt: dueAt,
    isActive: true,
  );
}
