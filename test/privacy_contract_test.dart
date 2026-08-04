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
        .where((File file) {
          return file.path.endsWith('.dart') || file.path.endsWith('.kt');
        })
        .toList();

    final List<RegExp> forbiddenLogCalls = <RegExp>[
      RegExp(r'\bprint\s*\('),
      RegExp(r'\bdebugPrint\s*\('),
      RegExp(r'\bLog\.d\s*\('),
      RegExp(r'\bLog\.i\s*\('),
    ];

    for (final File file in sourceFiles) {
      final String source = file.readAsStringSync();
      for (final RegExp pattern in forbiddenLogCalls) {
        expect(
          pattern.hasMatch(source),
          isFalse,
          reason: 'Raw console logging found in ${file.path}: $pattern',
        );
      }
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

  test('runtime font network fetching is disabled', () {
    final String mainSource = File('lib/main.dart').readAsStringSync();
    expect(
      mainSource,
      contains('GoogleFonts.config.allowRuntimeFetching = false'),
    );
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

  test('confirmation erases the retained original SMS text', () {
    final String source = File(
      'lib/features/transactions/data/repositories/transaction_repository.dart',
    ).readAsStringSync();
    final int start = source.indexOf('Future<void> confirm');
    final int end = source.indexOf('Future<void> updatePending', start);
    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));
    final String method = source.substring(start, end);
    expect(method, contains("encryptedOriginalSmsText = ''"));
  });
}
