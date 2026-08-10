import 'dart:typed_data';

import 'package:smart_expense_manager/features/settings/services/encrypted_backup_codec.dart';
import 'package:smart_expense_manager/features/settings/services/local_backup_service.dart';

class BackupInspection extends BackupSnapshotSummary {
  const BackupInspection({
    required this.snapshotVersion,
    required this.createdAt,
    required super.transactions,
    required super.categories,
    required super.merchantRules,
    required super.recurringTransactions,
    required super.savingsGoals,
  });

  final int snapshotVersion;
  final DateTime createdAt;
}

class BackupInspectionService {
  BackupInspectionService({EncryptedBackupCodec? codec})
    : _codec = codec ?? EncryptedBackupCodec();

  final EncryptedBackupCodec _codec;

  Future<BackupInspection> inspect({
    required Uint8List bytes,
    required String password,
  }) async {
    final Map<String, Object?> payload = await _codec.decrypt(
      encryptedBytes: bytes,
      password: password,
    );
    final Object? rawVersion = payload['snapshotVersion'];
    if (rawVersion is! int ||
        !LocalBackupService.supportedSnapshotVersions.contains(rawVersion)) {
      throw const FormatException('Unsupported PiggyAI snapshot version');
    }

    final DateTime createdAt = _requiredDate(payload['createdAt'], 'createdAt');
    final List<Object?> categories = _requiredList(
      payload['categories'],
      'categories',
    );
    if (categories.isEmpty) {
      throw const FormatException('Backup does not contain any categories');
    }

    final List<Object?> merchantRules = _requiredList(
      payload['merchantRules'],
      'merchantRules',
    );
    final List<Object?> transactions = _requiredList(
      payload['transactions'],
      'transactions',
    );
    final List<Object?> recurring = rawVersion >= 2
        ? _requiredList(payload['recurringTransactions'], 'recurringTransactions')
        : const <Object?>[];
    final List<Object?> goals = rawVersion >= 3
        ? _requiredList(payload['savingsGoals'], 'savingsGoals')
        : const <Object?>[];

    return BackupInspection(
      snapshotVersion: rawVersion,
      createdAt: createdAt,
      transactions: transactions.length,
      categories: categories.length,
      merchantRules: merchantRules.length,
      recurringTransactions: recurring.length,
      savingsGoals: goals.length,
    );
  }

  List<Object?> _requiredList(Object? value, String field) {
    if (value is! List<Object?>) {
      throw FormatException('Invalid backup $field');
    }
    return value;
  }

  DateTime _requiredDate(Object? value, String field) {
    if (value is! String) {
      throw FormatException('Invalid backup $field');
    }
    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed == null) {
      throw FormatException('Invalid backup $field');
    }
    return parsed;
  }
}
