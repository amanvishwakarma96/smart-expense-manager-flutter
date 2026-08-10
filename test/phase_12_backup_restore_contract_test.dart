import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('backup inspection stays read-only and independent of Isar', () {
    final String source = File(
      'lib/features/settings/services/backup_inspection_service.dart',
    ).readAsStringSync();

    expect(source, isNot(contains('isar_community')));
    expect(source, isNot(contains('writeTxn')));
    expect(source, isNot(contains('.put(')));
    expect(source, contains('EncryptedBackupCodec'));
  });

  test('restore UI inspects and previews before destructive replacement', () {
    final String source = File(
      'lib/features/settings/presentation/backup_settings_card.dart',
    ).readAsStringSync();

    expect(
      source.indexOf('_inspectionService.inspect'),
      lessThan(source.indexOf('_confirmReplacement(inspection)')),
    );
    expect(
      source.indexOf('_confirmReplacement(inspection)'),
      lessThan(source.indexOf('.restoreEncryptedBackup')),
    );
    expect(source, contains('Review backup before replacing data'));
    expect(source, contains('Keep current data'));
  });
}
