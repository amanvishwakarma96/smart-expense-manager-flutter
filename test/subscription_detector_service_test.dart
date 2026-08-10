import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/dashboard/services/subscription_detector_service.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

void main() {
  const SubscriptionDetectorService service = SubscriptionDetectorService();
  final DateTime now = DateTime(2026, 8, 10, 12);

  ExpenseTransaction debit(int id, String merchant, double amount, DateTime at) {
    return ExpenseTransaction(
      id: id,
      amount: amount,
      type: TransactionType.debit,
      merchant: merchant,
      timestamp: at,
      status: TransactionStatus.confirmed,
      accountTail: '7788',
      originalSmsText: '',
    );
  }

  test('detects a roughly monthly subscription with three-day jitter', () {
    final suggestions = service.detect(
      transactions: <ExpenseTransaction>[
        debit(1, 'Netflix', 649, DateTime(2026, 5, 12)),
        debit(2, 'NETFLIX', 649, DateTime(2026, 6, 10)),
        debit(3, 'Netflix', 649, DateTime(2026, 7, 11)),
        debit(4, 'Netflix', 649, DateTime(2026, 8, 10)),
      ],
      recurringTransactions: const <RecurringTransaction>[],
      now: now,
    );

    expect(suggestions, hasLength(1));
    expect(suggestions.single.frequency, RecurringFrequency.monthly);
    expect(suggestions.single.amount, 649);
  });

  test('detects a weekly subscription with allowed jitter', () {
    final suggestions = service.detect(
      transactions: <ExpenseTransaction>[
        debit(1, 'Milk Plan', 350, DateTime(2026, 7, 20)),
        debit(2, 'Milk Plan', 350, DateTime(2026, 7, 28)),
        debit(3, 'Milk Plan', 350, DateTime(2026, 8, 4)),
      ],
      recurringTransactions: const <RecurringTransaction>[],
      now: now,
    );

    expect(suggestions, hasLength(1));
    expect(suggestions.single.frequency, RecurringFrequency.weekly);
  });

  test('does not flag irregular repeated spending', () {
    final suggestions = service.detect(
      transactions: <ExpenseTransaction>[
        debit(1, 'Coffee Shop', 250, DateTime(2026, 6, 1)),
        debit(2, 'Coffee Shop', 250, DateTime(2026, 6, 16)),
        debit(3, 'Coffee Shop', 250, DateTime(2026, 7, 29)),
      ],
      recurringTransactions: const <RecurringTransaction>[],
      now: now,
    );

    expect(suggestions, isEmpty);
  });

  test('does not suggest an item already configured as recurring', () {
    final suggestions = service.detect(
      transactions: <ExpenseTransaction>[
        debit(1, 'Netflix', 649, DateTime(2026, 6, 10)),
        debit(2, 'Netflix', 649, DateTime(2026, 7, 10)),
        debit(3, 'Netflix', 649, DateTime(2026, 8, 9)),
      ],
      recurringTransactions: <RecurringTransaction>[
        RecurringTransaction(
          id: 1,
          amount: 649,
          type: TransactionType.debit,
          merchant: 'NETFLIX',
          frequency: RecurringFrequency.monthly,
          nextDueAt: DateTime(2026, 9, 9),
          isActive: true,
        ),
      ],
      now: now,
    );

    expect(suggestions, isEmpty);
  });
}
