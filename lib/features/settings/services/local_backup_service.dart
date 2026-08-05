import 'dart:typed_data';

import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/settings/services/encrypted_backup_codec.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/recurring_transaction_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

class BackupSnapshotSummary {
  const BackupSnapshotSummary({
    required this.transactions,
    required this.categories,
    required this.merchantRules,
    this.recurringTransactions = 0,
  });

  final int transactions;
  final int categories;
  final int merchantRules;
  final int recurringTransactions;
}

class BackupExportResult extends BackupSnapshotSummary {
  const BackupExportResult({
    required this.bytes,
    required this.fileName,
    required super.transactions,
    required super.categories,
    required super.merchantRules,
    super.recurringTransactions,
  });

  final Uint8List bytes;
  final String fileName;
}

class LocalBackupService {
  LocalBackupService({
    required Isar isar,
    required SecureCipherService cipher,
    EncryptedBackupCodec? codec,
  }) : this._(isar, cipher, codec ?? EncryptedBackupCodec());

  LocalBackupService._(this._isar, this._cipher, this._codec);

  static const int snapshotVersion = 2;
  static const Set<int> supportedSnapshotVersions = <int>{1, 2};

  final Isar _isar;
  final SecureCipherService _cipher;
  final EncryptedBackupCodec _codec;

  Future<BackupExportResult> createEncryptedBackup(String password) async {
    final List<CategoryModel> categories = await _isar.categoryModels
        .where()
        .findAll();
    final List<MerchantRuleModel> rules = await _isar.merchantRuleModels
        .where()
        .findAll();
    final List<TransactionModel> transactions = await _isar.transactionModels
        .where()
        .findAll();
    final List<RecurringTransactionModel> recurring = await _isar
        .recurringTransactionModels
        .where()
        .findAll();

    final List<Map<String, Object?>> transactionPayload =
        <Map<String, Object?>>[];
    for (final TransactionModel item in transactions) {
      transactionPayload.add(<String, Object?>{
        'id': item.id,
        'amount': item.amount,
        'type': item.type.name,
        'merchant': await _cipher.decrypt(item.encryptedMerchant),
        'timestamp': item.timestamp.toUtc().toIso8601String(),
        'categoryId': item.categoryId,
        'status': item.status.name,
        'originalSmsText': await _cipher.decrypt(item.encryptedOriginalSmsText),
        'accountTail': await _cipher.decrypt(item.encryptedAccountTail),
        'smsFingerprint': item.smsFingerprint,
        'isManual': item.isManual,
        'isRecurring': item.isRecurring,
      });
    }

    final List<Map<String, Object?>> recurringPayload =
        <Map<String, Object?>>[];
    for (final RecurringTransactionModel item in recurring) {
      recurringPayload.add(<String, Object?>{
        'id': item.id,
        'amount': item.amount,
        'type': item.type.name,
        'merchant': await _cipher.decrypt(item.encryptedMerchant),
        'categoryId': item.categoryId,
        'frequency': item.frequency.name,
        'scheduleDay': item.scheduleDay,
        'nextDueAt': item.nextDueAt.toUtc().toIso8601String(),
        'isActive': item.isActive,
      });
    }

    final Map<String, Object?> payload = <String, Object?>{
      'snapshotVersion': snapshotVersion,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'categories': categories
          .map(
            (CategoryModel item) => <String, Object?>{
              'id': item.id,
              'name': item.name,
              'iconName': item.iconName,
              'hexColor': item.hexColor,
              'monthlyBudgetLimit': item.monthlyBudgetLimit,
            },
          )
          .toList(growable: false),
      'merchantRules': rules
          .map(
            (MerchantRuleModel item) => <String, Object?>{
              'id': item.id,
              'merchantPattern': item.merchantPattern,
              'mappedCategoryId': item.mappedCategoryId,
            },
          )
          .toList(growable: false),
      'recurringTransactions': recurringPayload,
      'transactions': transactionPayload,
    };

    final Uint8List bytes = await _codec.encrypt(
      payload: payload,
      password: password,
    );
    final DateTime now = DateTime.now();
    final String date =
        '${now.year.toString().padLeft(4, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}';
    return BackupExportResult(
      bytes: bytes,
      fileName: 'piggyai-backup-$date.piggybackup',
      transactions: transactions.length,
      categories: categories.length,
      merchantRules: rules.length,
      recurringTransactions: recurring.length,
    );
  }

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

    final List<Map<String, Object?>> categoryMaps = _mapList(
      payload['categories'],
      'categories',
    );
    final List<Map<String, Object?>> ruleMaps = _mapList(
      payload['merchantRules'],
      'merchantRules',
    );
    final List<Map<String, Object?>> transactionMaps = _mapList(
      payload['transactions'],
      'transactions',
    );
    final List<Map<String, Object?>> recurringMaps = rawVersion >= 2
        ? _mapList(payload['recurringTransactions'], 'recurringTransactions')
        : const <Map<String, Object?>>[];
    if (categoryMaps.isEmpty) {
      throw const FormatException('Backup does not contain any categories');
    }

    final List<CategoryModel> categories = categoryMaps
        .map(
          (Map<String, Object?> map) => CategoryModel(
            id: _positiveInt(map['id'], 'category.id'),
            name: _requiredString(map['name'], 'category.name'),
            iconName: _requiredString(map['iconName'], 'category.iconName'),
            hexColor: _requiredString(map['hexColor'], 'category.hexColor'),
            monthlyBudgetLimit: _nonNegativeNumber(
              map['monthlyBudgetLimit'],
              'category.monthlyBudgetLimit',
            ),
          ),
        )
        .toList(growable: false);
    final Set<int> categoryIds = categories
        .map((CategoryModel item) => item.id)
        .toSet();
    if (categoryIds.length != categories.length) {
      throw const FormatException('Backup contains duplicate category IDs');
    }

    final Set<int> ruleIds = <int>{};
    final List<MerchantRuleModel> rules = ruleMaps.map((map) {
      final int id = _positiveInt(map['id'], 'merchantRule.id');
      if (!ruleIds.add(id)) {
        throw const FormatException(
          'Backup contains duplicate merchant rule IDs',
        );
      }
      final int categoryId = _categoryReference(
        map['mappedCategoryId'],
        categoryIds,
        'merchantRule.mappedCategoryId',
      );
      return MerchantRuleModel(
        id: id,
        merchantPattern: _requiredString(
          map['merchantPattern'],
          'merchantRule.merchantPattern',
        ),
        mappedCategoryId: categoryId,
      );
    }).toList(growable: false);

    final Set<int> recurringIds = <int>{};
    final List<RecurringTransactionModel> recurring =
        <RecurringTransactionModel>[];
    for (final Map<String, Object?> map in recurringMaps) {
      final int id = _positiveInt(map['id'], 'recurring.id');
      if (!recurringIds.add(id)) {
        throw const FormatException(
          'Backup contains duplicate recurring transaction IDs',
        );
      }
      final RecurringFrequency frequency = _recurringFrequency(
        map['frequency'],
      );
      final int scheduleDay = _positiveInt(
        map['scheduleDay'],
        'recurring.scheduleDay',
      );
      final int maxScheduleDay = frequency == RecurringFrequency.weekly ? 7 : 31;
      if (scheduleDay > maxScheduleDay) {
        throw const FormatException('Recurring schedule day is invalid');
      }
      recurring.add(
        RecurringTransactionModel(
          id: id,
          amount: _positiveNumber(map['amount'], 'recurring.amount'),
          type: _transactionType(map['type']),
          encryptedMerchant: await _cipher.encrypt(
            _requiredString(map['merchant'], 'recurring.merchant'),
          ),
          categoryId: _nullableCategoryReference(
            map['categoryId'],
            categoryIds,
            'recurring.categoryId',
          ),
          frequency: frequency,
          scheduleDay: scheduleDay,
          nextDueAt: _dateTime(map['nextDueAt'], 'recurring.nextDueAt'),
          isActive: _bool(map['isActive'], 'recurring.isActive'),
        ),
      );
    }

    final Set<int> transactionIds = <int>{};
    final Set<String> fingerprints = <String>{};
    final List<TransactionModel> transactions = <TransactionModel>[];
    for (final Map<String, Object?> map in transactionMaps) {
      final int id = _positiveInt(map['id'], 'transaction.id');
      if (!transactionIds.add(id)) {
        throw const FormatException(
          'Backup contains duplicate transaction IDs',
        );
      }
      final String? fingerprint = _nullableString(map['smsFingerprint']);
      if (fingerprint != null && !fingerprints.add(fingerprint)) {
        throw const FormatException(
          'Backup contains duplicate SMS fingerprints',
        );
      }
      transactions.add(
        TransactionModel(
          id: id,
          amount: _positiveNumber(map['amount'], 'transaction.amount'),
          type: _transactionType(map['type']),
          encryptedMerchant: await _cipher.encrypt(
            _requiredString(map['merchant'], 'transaction.merchant'),
          ),
          timestamp: _dateTime(map['timestamp'], 'transaction.timestamp'),
          categoryId: _nullableCategoryReference(
            map['categoryId'],
            categoryIds,
            'transaction.categoryId',
          ),
          status: _transactionStatus(map['status']),
          encryptedOriginalSmsText: await _cipher.encrypt(
            _nullableString(map['originalSmsText']) ?? '',
          ),
          encryptedAccountTail: await _cipher.encrypt(
            _nullableString(map['accountTail']) ?? '',
          ),
          smsFingerprint: fingerprint,
          isManual: _bool(map['isManual'], 'transaction.isManual'),
          isRecurring: _optionalBool(map['isRecurring']),
        ),
      );
    }

    await _isar.writeTxn(() async {
      await _isar.transactionModels.clear();
      await _isar.recurringTransactionModels.clear();
      await _isar.merchantRuleModels.clear();
      await _isar.categoryModels.clear();
      await _isar.categoryModels.putAll(categories);
      await _isar.merchantRuleModels.putAll(rules);
      await _isar.recurringTransactionModels.putAll(recurring);
      await _isar.transactionModels.putAll(transactions);
    });

    return BackupSnapshotSummary(
      transactions: transactions.length,
      categories: categories.length,
      merchantRules: rules.length,
      recurringTransactions: recurring.length,
    );
  }

  List<Map<String, Object?>> _mapList(Object? value, String name) {
    if (value is! List<dynamic>) {
      throw FormatException('Backup $name is invalid');
    }
    return value.map((Object? item) {
      if (item is! Map<String, dynamic>) {
        throw FormatException('Backup $name contains an invalid item');
      }
      return item.cast<String, Object?>();
    }).toList(growable: false);
  }

  int _positiveInt(Object? value, String name) {
    if (value is int && value > 0) {
      return value;
    }
    throw FormatException('$name must be a positive integer');
  }

  int _categoryReference(Object? value, Set<int> ids, String name) {
    final int id = _positiveInt(value, name);
    if (!ids.contains(id)) {
      throw FormatException('$name references an unknown category');
    }
    return id;
  }

  int? _nullableCategoryReference(
    Object? value,
    Set<int> ids,
    String name,
  ) {
    if (value == null) {
      return null;
    }
    return _categoryReference(value, ids, name);
  }

  double _number(Object? value, String name) {
    if (value is num) {
      return value.toDouble();
    }
    throw FormatException('$name must be numeric');
  }

  double _nonNegativeNumber(Object? value, String name) {
    final double parsed = _number(value, name);
    if (parsed < 0) {
      throw FormatException('$name must not be negative');
    }
    return parsed;
  }

  double _positiveNumber(Object? value, String name) {
    final double parsed = _number(value, name);
    if (parsed <= 0) {
      throw FormatException('$name must be greater than zero');
    }
    return parsed;
  }

  bool _bool(Object? value, String name) {
    if (value is bool) {
      return value;
    }
    throw FormatException('$name must be true or false');
  }

  bool _optionalBool(Object? value) {
    if (value == null) {
      return false;
    }
    return _bool(value, 'optional boolean');
  }

  DateTime _dateTime(Object? value, String name) {
    return DateTime.parse(_requiredString(value, name)).toLocal();
  }

  TransactionType _transactionType(Object? value) {
    final String name = _requiredString(value, 'transaction.type');
    for (final TransactionType type in TransactionType.values) {
      if (type.name == name) {
        return type;
      }
    }
    throw FormatException('Unknown transaction type: $name');
  }

  TransactionStatus _transactionStatus(Object? value) {
    final String name = _requiredString(value, 'transaction.status');
    for (final TransactionStatus status in TransactionStatus.values) {
      if (status.name == name) {
        return status;
      }
    }
    throw FormatException('Unknown transaction status: $name');
  }

  RecurringFrequency _recurringFrequency(Object? value) {
    final String name = _requiredString(value, 'recurring.frequency');
    for (final RecurringFrequency frequency in RecurringFrequency.values) {
      if (frequency.name == name) {
        return frequency;
      }
    }
    throw FormatException('Unknown recurring frequency: $name');
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
}
