import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('new backup snapshots persist purpose while old snapshots remain valid', () {
    final String source = File(
      'lib/features/settings/services/local_backup_service.dart',
    ).readAsStringSync();

    expect(source, contains('snapshotVersion = 5'));
    expect(source, contains("'purpose': transactionPurposeFromCode"));
    expect(source, contains('rawVersion >= 5'));
    expect(source, contains('defaultTransactionPurpose(type)'));
    expect(source, contains('_transactionPurpose(map['));
  });
}
