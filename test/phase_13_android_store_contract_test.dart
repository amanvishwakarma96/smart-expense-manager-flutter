import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android release targets API 36 for 2026 Play submissions', () {
    final String gradle = File(
      'android/app/build.gradle.kts',
    ).readAsStringSync();

    expect(gradle, contains('compileSdk = 36'));
    expect(gradle, contains('targetSdk = 36'));
    expect(gradle, contains('minSdk = 24'));
  });

  test('Android production manifest keeps network access absent', () {
    final String manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();

    expect(manifest, isNot(contains('android.permission.INTERNET')));
    expect(manifest, contains('android:usesCleartextTraffic="false"'));
    expect(manifest, contains('android:allowBackup="false"'));
  });

  test('release signing never falls back to debug signing', () {
    final String gradle = File(
      'android/app/build.gradle.kts',
    ).readAsStringSync();

    expect(gradle, contains('signingConfigs.getByName("release")'));
    expect(gradle, isNot(contains('signingConfigs.getByName("debug")')));
    expect(gradle, contains('Android release signing is not configured'));
  });

  test('CI verifies 16 KB native and APK alignment', () {
    final String workflow = File(
      '.github/workflows/flutter-ci.yml',
    ).readAsStringSync();
    final String alignmentScript = File(
      'tool/check_android_16kb.sh',
    ).readAsStringSync();

    expect(workflow, contains('Verify Android debug APK supports 16 KB pages'));
    expect(
      workflow,
      contains('Verify signed Android APK supports 16 KB pages'),
    );
    expect(alignmentScript, contains('zipalign_path'));
    expect(alignmentScript, contains('-P 16 4'));
    expect(alignmentScript, contains('llvm-objdump'));
    expect(alignmentScript, contains(r'"$exponent" -lt 14'));
  });
}
