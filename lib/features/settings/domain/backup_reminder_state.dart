class BackupReminderState {
  const BackupReminderState({this.lastSuccessfulBackupAt, this.snoozedUntil});

  final DateTime? lastSuccessfulBackupAt;
  final DateTime? snoozedUntil;

  BackupReminderState copyWith({
    DateTime? lastSuccessfulBackupAt,
    DateTime? snoozedUntil,
  }) {
    return BackupReminderState(
      lastSuccessfulBackupAt:
          lastSuccessfulBackupAt ?? this.lastSuccessfulBackupAt,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
    );
  }
}
