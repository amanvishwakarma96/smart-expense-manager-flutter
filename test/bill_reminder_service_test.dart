import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/settings/services/bill_reminder_service.dart';

void main() {
  group('BillReminderService timing', () {
    test('uses 9 AM on the selected lead day', () {
      final DateTime reminder = BillReminderService.preferredReminderTime(
        dueAt: DateTime(2026, 8, 20),
        daysBefore: 3,
      );

      expect(reminder, DateTime(2026, 8, 17, 9));
    });

    test('moves a missed reminder window to one minute from now', () {
      final DateTime now = DateTime(2026, 8, 19, 15, 30);
      final DateTime? scheduled = BillReminderService.scheduleTime(
        dueAt: DateTime(2026, 8, 20),
        daysBefore: 3,
        now: now,
      );

      expect(scheduled, now.add(const Duration(minutes: 1)));
    });

    test('does not schedule a reminder after the due instant', () {
      final DateTime? scheduled = BillReminderService.scheduleTime(
        dueAt: DateTime(2026, 8, 20),
        daysBefore: 1,
        now: DateTime(2026, 8, 20, 1),
      );

      expect(scheduled, isNull);
    });

    test('notification IDs are stable per recurring template', () {
      expect(BillReminderService.notificationIdFor(42), 700042);
      expect(
        BillReminderService.notificationIdFor(42),
        BillReminderService.notificationIdFor(42),
      );
    });
  });
}
