import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bill notification text never accesses financial details', () {
    final String source = File(
      'lib/features/settings/services/bill_reminder_service.dart',
    ).readAsStringSync();

    expect(source, contains("title: 'Scheduled payment coming up'"));
    expect(source, contains('inexactAllowWhileIdle'));
    expect(source, isNot(contains('encryptedMerchant')));
    expect(source, isNot(contains('model.amount')));
    expect(source, isNot(contains('model.encryptedAccountTail')));
    expect(source, isNot(contains('model.encryptedOriginalSmsText')));
  });

  test('scheduled reminders avoid exact alarm and internet permissions', () {
    final String manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();

    expect(manifest, contains('RECEIVE_BOOT_COMPLETED'));
    expect(manifest, contains('ScheduledNotificationReceiver'));
    expect(manifest, contains('ScheduledNotificationBootReceiver'));
    expect(manifest, isNot(contains('SCHEDULE_EXACT_ALARM')));
    expect(manifest, isNot(contains('USE_EXACT_ALARM')));
    expect(manifest, isNot(contains('android.permission.INTERNET')));
  });

  test('reminder permission is requested only from the opt-in editor flow', () {
    final String source = File(
      'lib/features/transactions/presentation/recurring_transaction_editor.dart',
    ).readAsStringSync();

    expect(source, contains('if (reminderEnabled)'));
    expect(source, contains('requestPermission()'));
    expect(source, contains('saved without a reminder'));
  });

  test('backup v5 retains v4 reminder preferences', () {
    final String source = File(
      'lib/features/settings/services/local_backup_service.dart',
    ).readAsStringSync();

    expect(source, contains('snapshotVersion = 5'));
    expect(
      source,
      contains('supportedSnapshotVersions = <int>{1, 2, 3, 4, 5}'),
    );
    expect(source, contains("'reminderEnabled': item.reminderEnabled"));
    expect(source, contains("'reminderDaysBefore': item.reminderDaysBefore"));
    expect(source, contains('rawVersion >= 4'));
  });

  test('safe-to-spend view masks every displayed amount', () {
    final String source = File(
      'lib/features/dashboard/presentation/safe_to_spend_card.dart',
    ).readAsStringSync();

    expect(source, contains('privacyMode'));
    expect(source, contains("'\$defaultCurrencySymbol •••••'"));
    expect(source, contains('_amount(plan.upcomingBillTotal)'));
    expect(source, contains('_amount(bill.amount)'));
  });

  test('full deletion cancels scheduled recurring reminders', () {
    final String source = File(
      'lib/features/transactions/data/repositories/'
      'transaction_repository.dart',
    ).readAsStringSync();

    expect(source, contains('cancelForTemplate(id)'));
    expect(source, contains('recurringTransactionModels.clear()'));
  });
}
