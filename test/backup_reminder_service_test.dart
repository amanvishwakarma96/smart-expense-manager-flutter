import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/settings/domain/backup_reminder_state.dart';
import 'package:smart_expense_manager/features/settings/services/backup_reminder_service.dart';

void main() {
  const BackupReminderPolicy policy = BackupReminderPolicy();
  final DateTime now = DateTime(2026, 8, 10, 12);

  test(
    'no backup ever triggers once at least one confirmed transaction exists',
    () {
      expect(
        policy.shouldRemind(
          confirmedTransactionCount: 1,
          now: now,
          state: const BackupReminderState(),
        ),
        isTrue,
      );
      expect(
        policy.shouldRemind(
          confirmedTransactionCount: 0,
          now: now,
          state: const BackupReminderState(),
        ),
        isFalse,
      );
    },
  );

  test('recent backup suppresses reminder until the 30-day boundary', () {
    expect(
      policy.shouldRemind(
        confirmedTransactionCount: 3,
        now: now,
        state: BackupReminderState(
          lastSuccessfulBackupAt: now.subtract(const Duration(days: 29)),
        ),
      ),
      isFalse,
    );
    expect(
      policy.shouldRemind(
        confirmedTransactionCount: 3,
        now: now,
        state: BackupReminderState(
          lastSuccessfulBackupAt: now.subtract(const Duration(days: 30)),
        ),
      ),
      isTrue,
    );
  });

  test('snoozed reminder stays hidden for 90 days', () {
    final DateTime snoozedUntil = now.add(const Duration(days: 90));
    final BackupReminderState state = BackupReminderState(
      snoozedUntil: snoozedUntil,
    );

    expect(
      policy.shouldRemind(
        confirmedTransactionCount: 2,
        now: now.add(const Duration(days: 89)),
        state: state,
      ),
      isFalse,
    );
    expect(
      policy.shouldRemind(
        confirmedTransactionCount: 2,
        now: snoozedUntil,
        state: state,
      ),
      isTrue,
    );
  });
}
