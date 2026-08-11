import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Phase 12 production metadata remains documented', () {
    final String pubspec = File('pubspec.yaml').readAsStringSync();
    final String changelog = File('CHANGELOG.md').readAsStringSync();

    expect(pubspec, isNot(contains('version: 0.1.0+1')));
    expect(changelog, contains('## [0.10.0] - Unreleased'));
    expect(
      changelog,
      contains('Android app metadata is aligned to `0.10.0+10`'),
    );
  });

  test('Android release remains offline and must use release signing', () {
    final String manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final String gradle = File(
      'android/app/build.gradle.kts',
    ).readAsStringSync();

    expect(manifest, isNot(contains('android.permission.INTERNET')));
    expect(
      gradle,
      isNot(contains('signingConfig = signingConfigs.getByName("debug")')),
    );
    expect(gradle, contains('ANDROID_KEYSTORE_PATH'));
  });

  test('CI creates both signed tester and Play artifacts', () {
    final String workflow = File(
      '.github/workflows/flutter-ci.yml',
    ).readAsStringSync();

    expect(workflow, contains('flutter build apk --release'));
    expect(workflow, contains('flutter build appbundle --release'));
    expect(workflow, contains('SHA256SUMS.txt'));
    expect(workflow, contains('APK-SIGNATURE.txt'));
    expect(workflow, contains('AAB-SIGNATURE.txt'));
  });
}
