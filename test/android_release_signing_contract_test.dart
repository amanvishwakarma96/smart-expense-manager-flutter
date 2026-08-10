import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('release build never falls back to the Android debug key', () {
    final String gradle = File(
      'android/app/build.gradle.kts',
    ).readAsStringSync();

    expect(gradle, isNot(contains('signingConfigs.getByName("debug")')));
    expect(gradle, contains('ANDROID_KEYSTORE_PATH'));
    expect(gradle, contains('ANDROID_KEYSTORE_PASSWORD'));
    expect(gradle, contains('ANDROID_KEY_ALIAS'));
    expect(gradle, contains('ANDROID_KEY_PASSWORD'));
    expect(gradle, contains('Android release signing is not configured'));
  });

  test('release signing secrets are not used by pull request builds', () {
    final String workflow = File(
      '.github/workflows/flutter-ci.yml',
    ).readAsStringSync();

    expect(workflow, contains("if: github.event_name != 'pull_request'"));
    expect(workflow, contains(r'${{ secrets.ANDROID_KEYSTORE_BASE64 }}'));
    expect(workflow, contains(r'${{ secrets.ANDROID_KEYSTORE_PASSWORD }}'));
    expect(workflow, contains(r'${{ secrets.ANDROID_KEY_ALIAS }}'));
    expect(workflow, contains(r'${{ secrets.ANDROID_KEY_PASSWORD }}'));
    expect(workflow, contains('flutter build apk --release'));
    expect(workflow, contains('flutter build appbundle --release'));
    expect(workflow, contains('PiggyAI-Android-Release-'));
  });

  test('signing files remain outside source control', () {
    final String gitignore = File('.gitignore').readAsStringSync();

    expect(gitignore, contains('android/key.properties'));
    expect(gitignore, contains('*.jks'));
    expect(gitignore, contains('*.keystore'));
  });
}
