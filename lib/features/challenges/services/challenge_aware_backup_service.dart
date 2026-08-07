import 'dart:typed_data';

import 'package:smart_expense_manager/features/challenges/data/repositories/weekly_challenge_repository.dart';
import 'package:smart_expense_manager/features/settings/services/local_backup_service.dart';

class ChallengeAwareBackupService extends LocalBackupService {
  ChallengeAwareBackupService(
    this._challenges, {
    required super.isar,
    required super.cipher,
    super.reminderService,
  });

  final WeeklyChallengeRepository _challenges;

  @override
  Future<BackupSnapshotSummary> restoreEncryptedBackup({
    required Uint8List bytes,
    required String password,
  }) async {
    final BackupSnapshotSummary summary = await super.restoreEncryptedBackup(
      bytes: bytes,
      password: password,
    );
    await _challenges.clearAll();
    return summary;
  }
}
