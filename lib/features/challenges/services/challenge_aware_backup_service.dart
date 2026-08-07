import 'dart:typed_data';

import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/challenges/data/repositories/weekly_challenge_repository.dart';
import 'package:smart_expense_manager/features/settings/services/bill_reminder_service.dart';
import 'package:smart_expense_manager/features/settings/services/local_backup_service.dart';

class ChallengeAwareBackupService extends LocalBackupService {
  ChallengeAwareBackupService({
    required Isar isar,
    required SecureCipherService cipher,
    required WeeklyChallengeRepository challenges,
    BillReminderService? reminderService,
  }) : _challenges = challenges,
       super(
         isar: isar,
         cipher: cipher,
         reminderService: reminderService,
       );

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
