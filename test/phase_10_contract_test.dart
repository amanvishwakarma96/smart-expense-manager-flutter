import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('transaction editor separates debit credit from purpose', () {
    final String source = File(
      'lib/features/transactions/presentation/manual_transaction_dialog.dart',
    ).readAsStringSync();

    expect(source, contains("label: Text('Debit')"));
    expect(source, contains("label: Text('Credit')"));
    expect(source, contains('TransactionPurposeField'));
    expect(source, contains('purpose: _purpose'));
    expect(source, contains('learnCategory'));
  });

  test('pending review surfaces direction purpose and learns categories', () {
    final String source = File(
      'lib/features/transactions/presentation/'
      'pending_transactions_screen.dart',
    ).readAsStringSync();

    expect(source, contains('TransactionSemanticChips'));
    expect(source, contains("label: Text('Debit')"));
    expect(source, contains("label: Text('Credit')"));
    expect(source, contains('Category remembered'));
    expect(source, contains('learnCategory'));
  });

  test(
    'running Android app is notified when native SMS queue receives data',
    () {
      final String receiver = File(
        'android/app/src/main/kotlin/com/smartspend/app/SmsReceiver.kt',
      ).readAsStringSync();
      final String activity = File(
        'android/app/src/main/kotlin/com/smartspend/app/MainActivity.kt',
      ).readAsStringSync();
      final String dartQueue = File(
        'lib/features/sms_engine/services/native_sms_queue_service.dart',
      ).readAsStringSync();
      final String coordinator = File(
        'lib/features/sms_engine/services/sms_engine_coordinator.dart',
      ).readAsStringSync();

      expect(receiver, contains('com.smartspend.app.SMS_QUEUED'));
      expect(activity, contains('com.smartspend.app.SMS_QUEUED'));
      expect(activity, contains('invokeMethod("smsQueued", null)'));
      expect(dartQueue, contains("call.method == 'smsQueued'"));
      expect(coordinator, contains('startAutomaticProcessing'));
      expect(coordinator, contains('_nativeQueue.queuedEvents.listen'));
    },
  );

  test('quick challenge creation no longer dereferences null challenge', () {
    final String source = File(
      'lib/features/challenges/presentation/weekly_money_challenge_card.dart',
    ).readAsStringSync();

    expect(source, contains('widget.challenge?.targetDays ?? 0'));
    expect(
      source,
      contains('existingTargetDays <= 0 ? 2 : existingTargetDays'),
    );
    expect(source, isNot(contains('widget.challenge!.targetDays')));
  });

  test('backup v5 persists semantic purpose and supports older snapshots', () {
    final String source = File(
      'lib/features/settings/services/local_backup_service.dart',
    ).readAsStringSync();

    expect(source, contains('snapshotVersion = 5'));
    expect(
      source,
      contains('supportedSnapshotVersions = <int>{1, 2, 3, 4, 5}'),
    );
    expect(source, contains("'purpose': transactionPurposeFromCode"));
    expect(source, contains('rawVersion >= 5'));
    expect(source, contains('defaultTransactionPurpose(type)'));
  });

  test('offline privacy contract remains intact', () {
    final Directory source = Directory('lib');
    for (final FileSystemEntity entity in source.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }
      final String text = entity.readAsStringSync();
      expect(text, isNot(contains('package:http/')));
      expect(text, isNot(contains('package:dio/')));
    }

    final String manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    expect(manifest, isNot(contains('android.permission.INTERNET')));
  });
}
