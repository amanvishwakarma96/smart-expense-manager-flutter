import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android manifests do not request internet access', () {
    final List<File> manifests = Directory('android/app/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where((File file) => file.path.endsWith('AndroidManifest.xml'))
        .toList();

    expect(manifests, isNotEmpty);
    for (final File manifest in manifests) {
      expect(
        manifest.readAsStringSync(),
        isNot(contains('android.permission.INTERNET')),
        reason: 'INTERNET permission found in ${manifest.path}',
      );
    }
  });

  test('application source has no raw console logging', () {
    final List<File> sourceFiles = <Directory>[
      Directory('lib'),
      Directory('android/app/src/main/kotlin'),
    ]
        .where((Directory directory) => directory.existsSync())
        .expand((Directory directory) => directory.listSync(recursive: true))
        .whereType<File>()
        .toList();

    for (final File file in sourceFiles) {
      final String source = file.readAsStringSync();
      expect(source, isNot(contains('print(')));
      expect(source, isNot(contains('debugPrint(')));
      expect(source, isNot(contains('Log.d(')));
      expect(source, isNot(contains('Log.i(')));
    }
  });

  test('application source does not import HTTP clients', () {
    final List<File> dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((File file) => file.path.endsWith('.dart'))
        .toList();

    for (final File file in dartFiles) {
      final String source = file.readAsStringSync();
      expect(source, isNot(contains("package:http/")));
      expect(source, isNot(contains("package:dio/")));
      expect(source, isNot(contains('HttpClient(')));
    }
  });

  test('manual entry is independent from SMS permission', () {
    final String source = File(
      'lib/features/transactions/data/repositories/transaction_repository.dart',
    ).readAsStringSync();
    final int start = source.indexOf('Future<int> addManualTransaction');
    final int end = source.indexOf('Future<void> confirm', start);
    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final String method = source.substring(start, end);
    expect(method, isNot(contains('Permission')));
    expect(method, isNot(contains('Sms')));
  });
}
