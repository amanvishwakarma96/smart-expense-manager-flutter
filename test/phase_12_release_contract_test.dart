import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('production metadata is aligned with the Phase 12 release line', () {
    final String pubspec = File('pubspec.yaml').readAsStringSync();

    expect(pubspec, contains('version: 0.10.0+10'));
    expect(pubspec, isNot(contains('version: 0.1.0+1')));
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
