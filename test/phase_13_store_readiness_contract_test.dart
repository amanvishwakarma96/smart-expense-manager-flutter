import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Phase 13 release metadata remains documented', () {
    final String changelog = File('CHANGELOG.md').readAsStringSync();

    expect(changelog, contains('## [0.11.0] - Unreleased'));
    expect(changelog, contains('Android 16 / API level 36'));
    expect(changelog, contains('Agree & continue'));
    expect(
      changelog,
      contains('App version metadata is advanced to `0.11.0+11`'),
    );
  });

  test('privacy policy is available locally inside Settings', () {
    final String settings = File(
      'lib/features/settings/presentation/settings_screen.dart',
    ).readAsStringSync();
    final String policy = File(
      'lib/features/settings/presentation/privacy_policy_screen.dart',
    ).readAsStringSync();

    expect(settings, contains("Text('Read privacy policy')"));
    expect(settings, contains('PrivacyPolicyScreen'));
    expect(policy, contains('Privacy-first by design'));
    expect(policy, contains('No collection or sharing'));
    expect(policy, contains('SMS access on Android'));
    expect(policy, contains('Manual entry works'));
    expect(policy, contains('without SMS permission'));
  });

  test('store submission documents remain present and privacy-first', () {
    final String publicPolicy = File(
      'docs/store/privacy-policy.md',
    ).readAsStringSync();
    final String playGuide = File(
      'docs/store/google-play-release.md',
    ).readAsStringSync();
    final String appStoreGuide = File(
      'docs/store/app-store-release.md',
    ).readAsStringSync();
    final String listing = File(
      'docs/store/store-listing-copy.md',
    ).readAsStringSync();

    expect(publicPolicy, contains('does not transmit user financial data'));
    expect(playGuide, contains('SMS-based money management'));
    expect(playGuide, contains('READ_SMS'));
    expect(playGuide, contains('RECEIVE_SMS'));
    expect(appStoreGuide, contains('Xcode 26'));
    expect(appStoreGuide, contains('does not access SMS'));
    expect(listing, contains('on-device bank SMS detection'));
  });

  test('store readiness does not add Android network permission', () {
    final String manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();

    expect(manifest, isNot(contains('android.permission.INTERNET')));
  });
}
