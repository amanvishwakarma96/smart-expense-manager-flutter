import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/recurring_transaction_repository.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

void main() {
  group('RecurringTransactionRepository.nextOccurrence', () {
    test('weekly schedules advance exactly seven days', () {
      final DateTime result = RecurringTransactionRepository.nextOccurrence(
        current: DateTime(2026, 8, 5, 9, 30),
        frequency: RecurringFrequency.weekly,
        scheduleDay: DateTime.wednesday,
      );

      expect(result, DateTime(2026, 8, 12, 9, 30));
    });

    test('monthly schedules retain their selected day', () {
      final DateTime result = RecurringTransactionRepository.nextOccurrence(
        current: DateTime(2026, 8, 15, 7, 45),
        frequency: RecurringFrequency.monthly,
        scheduleDay: 15,
      );

      expect(result, DateTime(2026, 9, 15, 7, 45));
    });

    test('month-end schedules clamp to the last available day', () {
      final DateTime result = RecurringTransactionRepository.nextOccurrence(
        current: DateTime(2027, 1, 31, 10, 0),
        frequency: RecurringFrequency.monthly,
        scheduleDay: 31,
      );

      expect(result, DateTime(2027, 2, 28, 10, 0));
    });

    test('month-end schedules respect leap years', () {
      final DateTime result = RecurringTransactionRepository.nextOccurrence(
        current: DateTime(2028, 1, 31, 10, 0),
        frequency: RecurringFrequency.monthly,
        scheduleDay: 31,
      );

      expect(result, DateTime(2028, 2, 29, 10, 0));
    });
  });
}
