import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/settings/services/encrypted_backup_codec.dart';

void main() {
  group('EncryptedBackupCodec', () {
    test('round-trips financial data without clear-text leakage', () async {
      final EncryptedBackupCodec codec = EncryptedBackupCodec(
        iterations: 100000,
      );
      final Map<String, Object?> payload = <String, Object?>{
        'snapshotVersion': 1,
        'transactions': <Map<String, Object?>>[
          <String, Object?>{
            'merchant': 'PRIVATE MERCHANT',
            'amount': 1250.50,
            'accountTail': '7788',
          },
        ],
      };

      final encrypted = await codec.encrypt(
        payload: payload,
        password: 'strong-password',
      );
      final String envelope = utf8.decode(encrypted);

      expect(envelope, isNot(contains('PRIVATE MERCHANT')));
      expect(envelope, isNot(contains('7788')));
      expect(
        await codec.decrypt(
          encryptedBytes: encrypted,
          password: 'strong-password',
        ),
        payload,
      );
    });

    test('rejects an incorrect password', () async {
      final EncryptedBackupCodec codec = EncryptedBackupCodec(
        iterations: 100000,
      );
      final encrypted = await codec.encrypt(
        payload: <String, Object?>{'snapshotVersion': 1},
        password: 'correct-password',
      );

      expect(
        codec.decrypt(encryptedBytes: encrypted, password: 'wrong-password'),
        throwsA(isA<BackupPasswordException>()),
      );
    });
  });
}
