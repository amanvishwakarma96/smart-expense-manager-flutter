import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/debts/services/debt_reminder_service.dart';

void main() {
  test('debt reminder uses 9 AM on the selected lead day', () {
    final DateTime due = DateTime(2026, 9, 20, 18, 30);

    expect(
      DebtReminderService.preferredReminderTime(dueAt: due, daysBefore: 3),
      DateTime(2026, 9, 17, 9),
    );
  });

  test('missed debt reminder window moves to one minute from now', () {
    final DateTime now = DateTime(2026, 9, 19, 12);
    final DateTime due = DateTime(2026, 9, 20, 18);

    expect(
      DebtReminderService.scheduleTime(dueAt: due, daysBefore: 3, now: now),
      now.add(const Duration(minutes: 1)),
    );
  });

  test('debt reminder is not scheduled after the due instant', () {
    final DateTime now = DateTime(2026, 9, 20, 18);

    expect(
      DebtReminderService.scheduleTime(
        dueAt: DateTime(2026, 9, 20, 18),
        daysBefore: 1,
        now: now,
      ),
      isNull,
    );
  });

  test('notification IDs are stable per debt ledger', () {
    expect(
      DebtReminderService.notificationIdFor(42),
      DebtReminderService.notificationIdFor(42),
    );
    expect(
      DebtReminderService.notificationIdFor(42),
      isNot(DebtReminderService.notificationIdFor(43)),
    );
  });
}
