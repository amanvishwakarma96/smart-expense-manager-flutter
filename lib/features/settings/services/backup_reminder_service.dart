import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:smart_expense_manager/features/settings/domain/backup_reminder_state.dart';

class BackupReminderPolicy {
  const BackupReminderPolicy();

  static const Duration staleAfter = Duration(days: 30);
  static const Duration snoozeDuration = Duration(days: 90);

  bool shouldRemind({
    required int confirmedTransactionCount,
    required DateTime now,
    required BackupReminderState state,
  }) {
    if (confirmedTransactionCount <= 0) {
      return false;
    }
    final DateTime? snoozedUntil = state.snoozedUntil;
    if (snoozedUntil != null && now.isBefore(snoozedUntil)) {
      return false;
    }
    final DateTime? lastBackup = state.lastSuccessfulBackupAt;
    if (lastBackup == null) {
      return true;
    }
    return !now.isBefore(lastBackup.add(staleAfter));
  }
}

class BackupReminderService {
  BackupReminderService({BackupReminderPolicy? policy})
    : policy = policy ?? const BackupReminderPolicy();

  final BackupReminderPolicy policy;

  static const String _fileName = 'piggyai_backup_reminder.json';
  static const String _lastBackupKey = 'lastSuccessfulBackupAt';
  static const String _snoozedUntilKey = 'snoozedUntil';

  Future<BackupReminderState> load() async {
    try {
      final File file = await _stateFile();
      if (!await file.exists()) {
        return const BackupReminderState();
      }
      final Object? decoded = jsonDecode(await file.readAsString());
      if (decoded is! Map<String, dynamic>) {
        return const BackupReminderState();
      }
      return BackupReminderState(
        lastSuccessfulBackupAt: _parseDate(decoded[_lastBackupKey]),
        snoozedUntil: _parseDate(decoded[_snoozedUntilKey]),
      );
    } on Object {
      return const BackupReminderState();
    }
  }

  Future<void> recordSuccessfulBackup({DateTime? now}) async {
    final BackupReminderState current = await load();
    await _write(
      BackupReminderState(
        lastSuccessfulBackupAt: now ?? DateTime.now(),
        snoozedUntil: current.snoozedUntil,
      ),
    );
  }

  Future<void> snooze({DateTime? now}) async {
    final DateTime resolvedNow = now ?? DateTime.now();
    final BackupReminderState current = await load();
    await _write(
      BackupReminderState(
        lastSuccessfulBackupAt: current.lastSuccessfulBackupAt,
        snoozedUntil: resolvedNow.add(BackupReminderPolicy.snoozeDuration),
      ),
    );
  }

  Future<File> _stateFile() async {
    final Directory directory = await getApplicationSupportDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> _write(BackupReminderState state) async {
    try {
      final File file = await _stateFile();
      await file.writeAsString(
        jsonEncode(<String, String?>{
          _lastBackupKey: state.lastSuccessfulBackupAt?.toIso8601String(),
          _snoozedUntilKey: state.snoozedUntil?.toIso8601String(),
        }),
        flush: true,
      );
    } on Object {
      // Reminder metadata must never block backup creation or app use.
    }
  }

  DateTime? _parseDate(Object? value) {
    if (value is! String || value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }
}
