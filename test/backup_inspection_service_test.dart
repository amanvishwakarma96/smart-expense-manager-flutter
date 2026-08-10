import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/settings/services/backup_inspection_service.dart';
import 'package:smart_expense_manager/features/settings/services/encrypted_backup_codec.dart';

void main() {
  late EncryptedBackupCodec codec;
  late BackupInspectionService service;

  setUp(() {
    codec = EncryptedBackupCodec(iterations: 100000);
    service = BackupInspectionService(codec: codec);
  });

  test(
    'inspects a supported encrypted snapshot without restoring it',
    () async {
      final Uint8List bytes = await codec.encrypt(
        password: 'strong-password',
        payload: <String, Object?>{
          'snapshotVersion': 5,
          'createdAt': '2026-08-10T08:00:00.000Z',
          'categories': <Object?>[
            <String, Object?>{'id': 1, 'name': 'Food'},
          ],
          'merchantRules': <Object?>[],
          'transactions': <Object?>[
            <String, Object?>{'id': 1},
            <String, Object?>{'id': 2},
          ],
          'recurringTransactions': <Object?>[
            <String, Object?>{'id': 1},
          ],
          'savingsGoals': <Object?>[],
        },
      );

      final BackupInspection result = await service.inspect(
        bytes: bytes,
        password: 'strong-password',
      );

      expect(result.snapshotVersion, 5);
      expect(result.transactions, 2);
      expect(result.categories, 1);
      expect(result.recurringTransactions, 1);
      expect(result.createdAt.toUtc(), DateTime.utc(2026, 8, 10, 8));
    },
  );

  test('rejects unsupported snapshot versions before confirmation', () async {
    final Uint8List bytes = await codec.encrypt(
      password: 'strong-password',
      payload: <String, Object?>{
        'snapshotVersion': 99,
        'createdAt': '2026-08-10T08:00:00.000Z',
        'categories': <Object?>[
          <String, Object?>{'id': 1},
        ],
        'merchantRules': <Object?>[],
        'transactions': <Object?>[],
      },
    );

    expect(
      () => service.inspect(bytes: bytes, password: 'strong-password'),
      throwsA(isA<FormatException>()),
    );
  });

  test('requires at least one category in preview', () async {
    final Uint8List bytes = await codec.encrypt(
      password: 'strong-password',
      payload: <String, Object?>{
        'snapshotVersion': 5,
        'createdAt': '2026-08-10T08:00:00.000Z',
        'categories': <Object?>[],
        'merchantRules': <Object?>[],
        'transactions': <Object?>[],
        'recurringTransactions': <Object?>[],
        'savingsGoals': <Object?>[],
      },
    );

    expect(
      () => service.inspect(bytes: bytes, password: 'strong-password'),
      throwsA(isA<FormatException>()),
    );
  });
}
