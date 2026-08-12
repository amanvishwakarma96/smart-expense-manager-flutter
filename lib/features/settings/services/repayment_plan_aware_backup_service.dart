import 'dart:typed_data';

import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/challenges/data/repositories/weekly_challenge_repository.dart';
import 'package:smart_expense_manager/features/debts/data/models/debt_repayment_plan_model.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_repayment_plan.dart';
import 'package:smart_expense_manager/features/debts/services/debt_reminder_service.dart';
import 'package:smart_expense_manager/features/settings/services/bill_reminder_service.dart';
import 'package:smart_expense_manager/features/settings/services/debt_aware_backup_service.dart';
import 'package:smart_expense_manager/features/settings/services/encrypted_backup_codec.dart';
import 'package:smart_expense_manager/features/settings/services/local_backup_service.dart';

class RepaymentPlanAwareBackupService extends DebtAwareBackupService {
  // ignore: use_super_parameters
  RepaymentPlanAwareBackupService(
    WeeklyChallengeRepository challenges, {
    required Isar isar,
    required SecureCipherService cipher,
    required DebtReminderService debtReminderService,
    BillReminderService? reminderService,
    EncryptedBackupCodec? codec,
  }) : _isar = isar,
       _codec = codec ?? EncryptedBackupCodec(),
       super(
         challenges,
         isar: isar,
         cipher: cipher,
         debtReminderService: debtReminderService,
         reminderService: reminderService,
         codec: codec,
       );

  static const int snapshotVersion = 7;
  static const Set<int> supportedSnapshotVersions = <int>{1, 2, 3, 4, 5, 6, 7};

  final Isar _isar;
  final EncryptedBackupCodec _codec;

  @override
  Future<BackupExportResult> createEncryptedBackup(String password) async {
    final BackupExportResult base = await super.createEncryptedBackup(password);
    final Map<String, Object?> payload = await _codec.decrypt(
      encryptedBytes: base.bytes,
      password: password,
    );
    final List<DebtRepaymentPlanModel> plans = await _isar
        .debtRepaymentPlanModels
        .where()
        .findAll();
    plans.sort(
      (DebtRepaymentPlanModel a, DebtRepaymentPlanModel b) => a.id.compareTo(b.id),
    );

    payload
      ..['snapshotVersion'] = snapshotVersion
      ..['repaymentPlans'] = plans
          .map(
            (DebtRepaymentPlanModel plan) => <String, Object?>{
              'id': plan.id,
              'debtId': plan.debtId,
              'cadence': plan.cadence.name,
              'installmentAmount': plan.installmentAmount,
              'annualInterestRatePct': plan.annualInterestRatePct,
              'firstDueDate': _calendarDate(plan.firstDueDate),
              'startingOutstanding': plan.startingOutstanding,
              'baselineRepaidAmount': plan.baselineRepaidAmount,
              'isPaused': plan.isPaused,
              'createdAt': plan.createdAt.toUtc().toIso8601String(),
              'updatedAt': plan.updatedAt.toUtc().toIso8601String(),
            },
          )
          .toList(growable: false);

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

    if (rawVersion < snapshotVersion) {
      final BackupSnapshotSummary summary = await super.restoreEncryptedBackup(
        bytes: bytes,
        password: password,
      );
      await _isar.writeTxn(() => _isar.debtRepaymentPlanModels.clear());
      return summary;
    }

    final List<DebtRepaymentPlanModel> plans = _validatePlans(payload);
    final Map<String, Object?> basePayload = Map<String, Object?>.from(payload)
      ..['snapshotVersion'] = DebtAwareBackupService.snapshotVersion
      ..remove('repaymentPlans');
    final Uint8List baseBytes = await _codec.encrypt(
      payload: basePayload,
      password: password,
    );
    final BackupSnapshotSummary summary = await super.restoreEncryptedBackup(
      bytes: baseBytes,
      password: password,
    );

    await _isar.writeTxn(() async {
      await _isar.debtRepaymentPlanModels.clear();
      await _isar.debtRepaymentPlanModels.putAll(plans);
    });
    return summary;
  }

  List<DebtRepaymentPlanModel> _validatePlans(Map<String, Object?> payload) {
    final Object? rawPlans = payload['repaymentPlans'];
    if (rawPlans is! List<dynamic>) {
      throw const FormatException('Backup repaymentPlans is invalid');
    }
    final Object? rawDebts = payload['debtAccounts'];
    if (rawDebts is! List<dynamic>) {
      throw const FormatException('Backup debtAccounts is invalid');
    }
    final Set<int> debtIds = rawDebts.map((Object? value) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException('Backup debt account is invalid');
      }
      return _positiveInt(value['id'], 'debt.id');
    }).toSet();

    final Set<int> ids = <int>{};
    final Set<int> plannedDebtIds = <int>{};
    final List<DebtRepaymentPlanModel> plans = <DebtRepaymentPlanModel>[];
    for (final Object? value in rawPlans) {
      if (value is! Map<String, dynamic>) {
        throw const FormatException('Backup repayment plan is invalid');
      }
      final Map<String, Object?> map = value.cast<String, Object?>();
      final int id = _positiveInt(map['id'], 'repaymentPlan.id');
      final int debtId = _positiveInt(map['debtId'], 'repaymentPlan.debtId');
      if (!ids.add(id)) {
        throw const FormatException('Backup contains duplicate repayment plan IDs');
      }
      if (!debtIds.contains(debtId)) {
        throw const FormatException('Repayment plan references an unknown debt');
      }
      if (!plannedDebtIds.add(debtId)) {
        throw const FormatException('A debt contains more than one repayment plan');
      }
      final double installment = _positiveNumber(
        map['installmentAmount'],
        'repaymentPlan.installmentAmount',
      );
      final double rate = _nonNegativeNumber(
        map['annualInterestRatePct'],
        'repaymentPlan.annualInterestRatePct',
      );
      if (rate > 100) {
        throw const FormatException('Repayment plan APR exceeds 100%');
      }
      final DebtRepaymentPlanModel plan = DebtRepaymentPlanModel(
        id: id,
        debtId: debtId,
        cadence: _cadence(map['cadence']),
        installmentAmount: installment,
        annualInterestRatePct: rate,
        firstDueDate: _calendarDateTime(
          map['firstDueDate'],
          'repaymentPlan.firstDueDate',
        ),
        startingOutstanding: _nonNegativeNumber(
          map['startingOutstanding'],
          'repaymentPlan.startingOutstanding',
        ),
        baselineRepaidAmount: _nonNegativeNumber(
          map['baselineRepaidAmount'],
          'repaymentPlan.baselineRepaidAmount',
        ),
        isPaused: _bool(map['isPaused'], 'repaymentPlan.isPaused'),
      )
        ..createdAt = _dateTime(map['createdAt'], 'repaymentPlan.createdAt')
        ..updatedAt = _dateTime(map['updatedAt'], 'repaymentPlan.updatedAt');
      plans.add(plan);
    }
    return plans;
  }

  int _positiveInt(Object? value, String name) {
    if (value is int && value > 0) {
      return value;
    }
    throw FormatException('$name must be a positive integer');
  }

  double _positiveNumber(Object? value, String name) {
    if (value is num && value > 0) {
      return value.toDouble();
    }
    throw FormatException('$name must be greater than zero');
  }

  double _nonNegativeNumber(Object? value, String name) {
    if (value is num && value >= 0) {
      return value.toDouble();
    }
    throw FormatException('$name must not be negative');
  }

  bool _bool(Object? value, String name) {
    if (value is bool) {
      return value;
    }
    throw FormatException('$name must be true or false');
  }

  String _calendarDate(DateTime value) {
    final String year = value.year.toString().padLeft(4, '0');
    final String month = value.month.toString().padLeft(2, '0');
    final String day = value.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  DateTime _calendarDateTime(Object? value, String name) {
    if (value is! String) {
      throw FormatException('$name must be a calendar date');
    }
    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed == null || _calendarDate(parsed) != value) {
      throw FormatException('$name is invalid');
    }
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  DateTime _dateTime(Object? value, String name) {
    if (value is! String) {
      throw FormatException('$name must be a date string');
    }
    final DateTime? parsed = DateTime.tryParse(value);
    if (parsed == null) {
      throw FormatException('$name is invalid');
    }
    return parsed.toLocal();
  }

  RepaymentCadence _cadence(Object? value) {
    if (value is String) {
      for (final RepaymentCadence cadence in RepaymentCadence.values) {
        if (cadence.name == value) {
          return cadence;
        }
      }
    }
    throw const FormatException('Unknown repayment cadence');
  }
}
