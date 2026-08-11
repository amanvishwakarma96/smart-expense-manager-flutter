import 'dart:typed_data';

import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/challenges/data/repositories/weekly_challenge_repository.dart';
import 'package:smart_expense_manager/features/challenges/services/challenge_aware_backup_service.dart';
import 'package:smart_expense_manager/features/debts/data/models/debt_account_model.dart';
import 'package:smart_expense_manager/features/debts/data/models/debt_ledger_entry_model.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/services/debt_reminder_service.dart';
import 'package:smart_expense_manager/features/settings/services/bill_reminder_service.dart';
import 'package:smart_expense_manager/features/settings/services/encrypted_backup_codec.dart';
import 'package:smart_expense_manager/features/settings/services/local_backup_service.dart';

class DebtAwareBackupService extends ChallengeAwareBackupService {
  // ignore: use_super_parameters
  DebtAwareBackupService(
    WeeklyChallengeRepository challenges, {
    required Isar isar,
    required SecureCipherService cipher,
    required this._debtReminderService,
    BillReminderService? reminderService,
    EncryptedBackupCodec? codec,
  }) : _isar = isar,
       _cipher = cipher,
       _codec = codec ?? EncryptedBackupCodec(),
       super(
         challenges,
         isar: isar,
         cipher: cipher,
         reminderService: reminderService,
       );

  static const int snapshotVersion = 6;
  static const Set<int> supportedSnapshotVersions = <int>{1, 2, 3, 4, 5, 6};

  final Isar _isar;
  final SecureCipherService _cipher;
  final DebtReminderService _debtReminderService;
  final EncryptedBackupCodec _codec;

  @override
  Future<BackupExportResult> createEncryptedBackup(String password) async {
    final BackupExportResult base = await super.createEncryptedBackup(password);
    final Map<String, Object?> payload = await _codec.decrypt(
      encryptedBytes: base.bytes,
      password: password,
    );
    final List<DebtAccountModel> accounts = await _isar.debtAccountModels
        .where()
        .findAll();
    final List<DebtLedgerEntryModel> entries = await _isar
        .debtLedgerEntryModels
        .where()
        .findAll();
    accounts.sort((DebtAccountModel a, DebtAccountModel b) => a.id.compareTo(b.id));
    entries.sort(
      (DebtLedgerEntryModel a, DebtLedgerEntryModel b) => a.id.compareTo(b.id),
    );

    final List<Map<String, Object?>> accountPayload = <Map<String, Object?>>[];
    for (final DebtAccountModel account in accounts) {
      accountPayload.add(<String, Object?>{
        'id': account.id,
        'kind': account.kind.name,
        'counterparty': await _cipher.decrypt(account.encryptedCounterparty),
        'openingBalance': account.openingBalance,
        'dueDate': account.dueDate?.toUtc().toIso8601String(),
        'note': await _cipher.decrypt(account.encryptedNote),
        'reminderEnabled': account.reminderEnabled,
        'reminderDaysBefore': account.reminderDaysBefore,
        'isArchived': account.isArchived,
        'createdAt': account.createdAt.toUtc().toIso8601String(),
        'updatedAt': account.updatedAt.toUtc().toIso8601String(),
      });
    }

    final List<Map<String, Object?>> entryPayload = <Map<String, Object?>>[];
    for (final DebtLedgerEntryModel entry in entries) {
      entryPayload.add(<String, Object?>{
        'id': entry.id,
        'debtId': entry.debtId,
        'type': entry.type.name,
        'amount': entry.amount,
        'occurredAt': entry.occurredAt.toUtc().toIso8601String(),
        'linkedTransactionId': entry.linkedTransactionId,
        'note': await _cipher.decrypt(entry.encryptedNote),
        'createdAt': entry.createdAt.toUtc().toIso8601String(),
      });
    }

    payload
      ..['snapshotVersion'] = snapshotVersion
      ..['debtAccounts'] = accountPayload
      ..['debtEntries'] = entryPayload;
    final Uint8List bytes = await _codec.encrypt(
      payload: payload,
      password: password,
    );
    return BackupExportResult(
      bytes: bytes,
      fileName: base.fileName,
      transactions: base.transactions,
      categories: base.categories,
      merchantRules: base.merchantRules,
      recurringTransactions: base.recurringTransactions,
      savingsGoals: base.savingsGoals,
    );
  }

  @override
  Future<BackupSnapshotSummary> restoreEncryptedBackup({
    required Uint8List bytes,
    required String password,
  }) async {
    final Map<String, Object?> payload = await _codec.decrypt(
      encryptedBytes: bytes,
      password: password,
    );
    final Object? rawVersion = payload['snapshotVersion'];
    if (rawVersion is! int || !supportedSnapshotVersions.contains(rawVersion)) {
      throw const FormatException('Unsupported PiggyAI snapshot version');
    }

    final List<int> previousDebtIds =
        (await _isar.debtAccountModels.where().findAll())
            .map((DebtAccountModel item) => item.id)
            .toList(growable: false);

    if (rawVersion < snapshotVersion) {
      final BackupSnapshotSummary summary = await super.restoreEncryptedBackup(
        bytes: bytes,
        password: password,
      );
      await _isar.writeTxn(() async {
        await _isar.debtLedgerEntryModels.clear();
        await _isar.debtAccountModels.clear();
      });
      for (final int id in previousDebtIds) {
        await _debtReminderService.cancelForAccount(id);
      }
      return summary;
    }

    final _DebtRestoreData debtData = await _validateDebtPayload(payload);
    final Map<String, Object?> basePayload = Map<String, Object?>.from(payload);
    basePayload['snapshotVersion'] = LocalBackupService.snapshotVersion;
    basePayload.remove('debtAccounts');
    basePayload.remove('debtEntries');
    final Uint8List baseBytes = await _codec.encrypt(
      payload: basePayload,
      password: password,
    );
    final BackupSnapshotSummary summary = await super.restoreEncryptedBackup(
      bytes: baseBytes,
      password: password,
    );

    await _isar.writeTxn(() async {
      await _isar.debtLedgerEntryModels.clear();
      await _isar.debtAccountModels.clear();
      await _isar.debtAccountModels.putAll(debtData.accounts);
      await _isar.debtLedgerEntryModels.putAll(debtData.entries);
    });
    for (final int id in previousDebtIds) {
      await _debtReminderService.cancelForAccount(id);
    }
    await _debtReminderService.syncAll();
    return summary;
  }

  Future<_DebtRestoreData> _validateDebtPayload(
    Map<String, Object?> payload,
  ) async {
    final List<Map<String, Object?>> accountMaps = _mapList(
      payload['debtAccounts'],
      'debtAccounts',
    );
    final List<Map<String, Object?>> entryMaps = _mapList(
      payload['debtEntries'],
      'debtEntries',
    );
    final List<Map<String, Object?>> transactionMaps = _mapList(
      payload['transactions'],
      'transactions',
    );
    final Set<int> transactionIds = transactionMaps
        .map((Map<String, Object?> map) => _positiveInt(map['id'], 'transaction.id'))
        .toSet();

    final Set<int> accountIds = <int>{};
    final List<DebtAccountModel> accounts = <DebtAccountModel>[];
    for (final Map<String, Object?> map in accountMaps) {
      final int id = _positiveInt(map['id'], 'debt.id');
      if (!accountIds.add(id)) {
        throw const FormatException('Backup contains duplicate debt IDs');
      }
      final DebtKind kind = _debtKind(map['kind']);
      final double openingBalance = _positiveNumber(
        map['openingBalance'],
        'debt.openingBalance',
      );
      final DateTime? dueDate = _optionalDateTime(map['dueDate'], 'debt.dueDate');
      final bool reminderEnabled = _bool(
        map['reminderEnabled'],
        'debt.reminderEnabled',
      );
      final int reminderDaysBefore = _positiveInt(
        map['reminderDaysBefore'],
        'debt.reminderDaysBefore',
      );
      if (!DebtReminderService.supportedLeadDays.contains(reminderDaysBefore)) {
        throw const FormatException('Debt reminder lead time is invalid');
      }
      if (reminderEnabled && dueDate == null) {
        throw const FormatException('Debt reminder requires a due date');
      }
      final DebtAccountModel account = DebtAccountModel(
        id: id,
        kind: kind,
        encryptedCounterparty: await _cipher.encrypt(
          _requiredString(map['counterparty'], 'debt.counterparty'),
        ),
        openingBalance: openingBalance,
        dueDate: dueDate,
        encryptedNote: await _cipher.encrypt(_nullableString(map['note']) ?? ''),
        reminderEnabled: reminderEnabled,
        reminderDaysBefore: reminderDaysBefore,
        isArchived: _bool(map['isArchived'], 'debt.isArchived'),
      )
        ..createdAt = _dateTime(map['createdAt'], 'debt.createdAt')
        ..updatedAt = _dateTime(map['updatedAt'], 'debt.updatedAt');
      accounts.add(account);
    }

    final Set<int> entryIds = <int>{};
    final Set<int> linkedTransactionIds = <int>{};
    final List<DebtLedgerEntryModel> entries = <DebtLedgerEntryModel>[];
    for (final Map<String, Object?> map in entryMaps) {
      final int id = _positiveInt(map['id'], 'debtEntry.id');
      if (!entryIds.add(id)) {
        throw const FormatException('Backup contains duplicate debt entry IDs');
      }
      final int debtId = _positiveInt(map['debtId'], 'debtEntry.debtId');
      if (!accountIds.contains(debtId)) {
        throw const FormatException('Debt entry references an unknown debt');
      }
      final int? linkedTransactionId = _nullablePositiveInt(
        map['linkedTransactionId'],
        'debtEntry.linkedTransactionId',
      );
      if (linkedTransactionId != null) {
        if (!transactionIds.contains(linkedTransactionId)) {
          throw const FormatException(
            'Debt entry references an unknown transaction',
          );
        }
        if (!linkedTransactionIds.add(linkedTransactionId)) {
          throw const FormatException(
            'A transaction is linked to more than one debt entry',
          );
        }
      }
      final DebtLedgerEntryModel entry = DebtLedgerEntryModel(
        id: id,
        debtId: debtId,
        type: _movementType(map['type']),
        amount: _positiveNumber(map['amount'], 'debtEntry.amount'),
        occurredAt: _dateTime(map['occurredAt'], 'debtEntry.occurredAt'),
        linkedTransactionId: linkedTransactionId,
        encryptedNote: await _cipher.encrypt(
          _nullableString(map['note']) ?? '',
        ),
      )..createdAt = _dateTime(map['createdAt'], 'debtEntry.createdAt');
      entries.add(entry);
    }
    return _DebtRestoreData(accounts: accounts, entries: entries);
  }

  List<Map<String, Object?>> _mapList(Object? value, String name) {
    if (value is! List<dynamic>) {
      throw FormatException('Backup $name is invalid');
    }
    return value
        .map((Object? item) {
          if (item is! Map<String, dynamic>) {
            throw FormatException('Backup $name contains an invalid item');
          }
          return item.cast<String, Object?>();
        })
        .toList(growable: false);
  }

  int _positiveInt(Object? value, String name) {
    if (value is int && value > 0) {
      return value;
    }
    throw FormatException('$name must be a positive integer');
  }

  int? _nullablePositiveInt(Object? value, String name) {
    if (value == null) {
      return null;
    }
    return _positiveInt(value, name);
  }

  double _positiveNumber(Object? value, String name) {
    if (value is num && value > 0) {
      return value.toDouble();
    }
    throw FormatException('$name must be greater than zero');
  }

  bool _bool(Object? value, String name) {
    if (value is bool) {
      return value;
    }
    throw FormatException('$name must be true or false');
  }

  DateTime _dateTime(Object? value, String name) {
    return DateTime.parse(_requiredString(value, name)).toLocal();
  }

  DateTime? _optionalDateTime(Object? value, String name) {
    if (value == null) {
      return null;
    }
    return _dateTime(value, name);
  }

  String _requiredString(Object? value, String name) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    throw FormatException('$name must not be empty');
  }

  String? _nullableString(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      return value;
    }
    throw const FormatException('Expected a string or null');
  }

  DebtKind _debtKind(Object? value) {
    final String name = _requiredString(value, 'debt.kind');
    for (final DebtKind kind in DebtKind.values) {
      if (kind.name == name) {
        return kind;
      }
    }
    throw FormatException('Unknown debt kind: $name');
  }

  DebtMovementType _movementType(Object? value) {
    final String name = _requiredString(value, 'debtEntry.type');
    for (final DebtMovementType type in DebtMovementType.values) {
      if (type.name == name) {
        return type;
      }
    }
    throw FormatException('Unknown debt movement type: $name');
  }
}

class _DebtRestoreData {
  const _DebtRestoreData({required this.accounts, required this.entries});

  final List<DebtAccountModel> accounts;
  final List<DebtLedgerEntryModel> entries;
}
