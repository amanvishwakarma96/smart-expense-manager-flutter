import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SMS access has a prominent disclosure before permission', () {
    final String disclosure = File(
      'lib/features/sms_engine/presentation/sms_permission_disclosure.dart',
    ).readAsStringSync();

    expect(disclosure, contains('Permission.sms.status'));
    expect(disclosure, contains('Use bank SMS for expense detection?'));
    expect(disclosure, contains('including new alerts received'));
    expect(disclosure, contains('while the app is not open'));
    expect(disclosure, contains('processed only on this device'));
    expect(disclosure, contains('unmatched'));
    expect(disclosure, contains('are not stored'));
    expect(disclosure, contains('does not send your SMS text'));
    expect(disclosure, contains('Manual entry works without SMS access'));
    expect(disclosure, contains("barrierDismissible: false"));
    expect(disclosure, contains("Text('Not now')"));
    expect(disclosure, contains("Text('Agree & continue')"));
  });

  test('onboarding and settings gate SMS permission with disclosure', () {
    final String onboarding = File(
      'lib/features/settings/presentation/onboarding_screen.dart',
    ).readAsStringSync();
    final String settings = File(
      'lib/features/settings/presentation/settings_screen.dart',
    ).readAsStringSync();

    for (final String source in <String>[onboarding, settings]) {
      final int disclosureIndex = source.indexOf('confirmSmsAccessIfNeeded');
      final int requestIndex = source.indexOf('requestPermissionAndScanInbox');
      expect(disclosureIndex, greaterThanOrEqualTo(0));
      expect(requestIndex, greaterThan(disclosureIndex));
    }

    expect(settings, isNot(contains('Permission.notification.request')));
  });

  test(
    'manifest requests only the SMS permissions needed for money management',
    () {
      final String manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();

      expect(manifest, contains('android.permission.READ_SMS'));
      expect(manifest, contains('android.permission.RECEIVE_SMS'));
      expect(manifest, isNot(contains('android.permission.SEND_SMS')));
      expect(manifest, isNot(contains('android.permission.WRITE_SMS')));
      expect(manifest, isNot(contains('android.permission.READ_CALL_LOG')));
    },
  );
}
