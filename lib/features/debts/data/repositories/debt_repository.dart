import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/debts/data/models/debt_account_model.dart';
import 'package:smart_expense_manager/features/debts/data/models/debt_ledger_entry_model.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/services/debt_transaction_linker.dart';
import 'package:smart_expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class DebtRepository {
  DebtRepository(Isar isar, SecureCipherService cipher) : this._(isar, cipher);

  DebtRepository._(this._isar, this._cipher);

  final Isar _isar;
  final SecureCipherService _cipher;

  Stream<List<DebtAccount>> watchActive() {
    return _isar.debtAccountModels
        .where()
        .watch(fireImmediately: true)
        .asyncMap((List<DebtAccountModel> models) async {
          final List<DebtAccountModel> active = models
              .where((DebtAccountModel item) => !item.isArchived)
              .toList(growable: false)
            ..sort((DebtAccountModel a, DebtAccountModel b) {
              final DateTime? aDue = a.dueDate;
              final DateTime? bDue = b.dueDate;
              if (aDue == null && bDue == null) {
                return b.updatedAt.compareTo(a.updatedAt);
              }
              if (aDue == null) {
                return 1;
              }
              if (bDue == null) {
                return -1;
              }
              return aDue.compareTo(bDue);
            });
          return Future.wait(active.map(_toDomain));
        });
  }

  Future<DebtAccount?> getById(int id) async {
    final DebtAccountModel? model = await _isar.debtAccountModels.get(id);
    return model == null ? null : _toDomain(model);
  }

  Future<int> create({
    required DebtKind kind,
    required String counterparty,
    required double openingBalance,
    DateTime? dueDate,
    String note = '',
    bool reminderEnabled = false,
    int reminderDaysBefore = 1,
  }) async {
    final String normalizedCounterparty = counterparty.trim();
    if (normalizedCounterparty.isEmpty) {
      throw ArgumentError.value(
        counterparty,
        'counterparty',
        'Counterparty must not be empty',
      );
    }
    if (openingBalance <= 0) {
      throw ArgumentError.value(
        openingBalance,
        'openingBalance',
        'Opening balance must be greater than zero',
      );
    }
    _validateReminder(reminderEnabled, reminderDaysBefore, dueDate);
    final DebtAccountModel model = DebtAccountModel(
      kind: kind,
      encryptedCounterparty: await _cipher.encrypt(normalizedCounterparty),
      openingBalance: openingBalance,
      dueDate: dueDate,
      encryptedNote: await _cipher.encrypt(note.trim()),
      reminderEnabled: reminderEnabled,
      reminderDaysBefore: reminderDaysBefore,
    );
    return _isar.writeTxn(() => _isar.debtAccountModels.put(model));
  }

  Future<void> update({
    required int id,
    required DebtKind kind,
    required String counterparty,
    required double openingBalance,
    DateTime? dueDate,
    String note = '',
    bool reminderEnabled = false,
    int reminderDaysBefore = 1,
  }) async {
    final DebtAccountModel? model = await _isar.debtAccountModels.get(id);
    if (model == null) {
      return;
    }
    final String normalizedCounterparty = counterparty.trim();
    if (normalizedCounterparty.isEmpty) {
      throw ArgumentError.value(
        counterparty,
        'counterparty',
        'Counterparty must not be empty',
      );
    }
    if (openingBalance <= 0) {
      throw ArgumentError.value(
        openingBalance,
        'openingBalance',
        'Opening balance must be greater than zero',
      );
    }
    _validateReminder(reminderEnabled, reminderDaysBefore, dueDate);
    model
      ..kind = kind
      ..encryptedCounterparty = await _cipher.encrypt(normalizedCounterparty)
      ..openingBalance = openingBalance
      ..dueDate = dueDate
      ..encryptedNote = await _cipher.encrypt(note.trim())
      ..reminderEnabled = reminderEnabled
      ..reminderDaysBefore = reminderDaysBefore
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.debtAccountModels.put(model));
  }

  Future<int> addManualMovement({
    required int debtId,
    required DebtMovementType type,
    required double amount,
    required DateTime occurredAt,
    String note = '',
  }) async {
    final DebtAccountModel? account = await _isar.debtAccountModels.get(debtId);
    if (account == null || account.isArchived) {
      throw StateError('Debt account is not available');
    }
    if (amount <= 0) {
      throw ArgumentError.value(amount, 'amount', 'Amount must be greater than zero');
    }
    final DebtLedgerEntryModel entry = DebtLedgerEntryModel(
      debtId: debtId,
      type: type,
      amount: amount,
      occurredAt: occurredAt,
      encryptedNote: await _cipher.encrypt(note.trim()),
    );
    return _isar.writeTxn(() async {
      final int id = await _isar.debtLedgerEntryModels.put(entry);
      account.updatedAt = DateTime.now();
      await _isar.debtAccountModels.put(account);
      return id;
    });
  }

  Future<int> linkConfirmedTransaction({
    required int debtId,
    required int transactionId,
  }) async {
    final DebtAccountModel? account = await _isar.debtAccountModels.get(debtId);
    if (account == null || account.isArchived) {
      throw StateError('Debt account is not available');
    }
    final TransactionModel? transaction = await _isar.transactionModels.get(
      transactionId,
    );
    if (transaction == null || transaction.status != TransactionStatus.confirmed) {
      throw StateError('Only confirmed transactions can be linked');
    }
    final List<DebtLedgerEntryModel> existing = await _isar
        .debtLedgerEntryModels
        .where()
        .findAll();
    if (existing.any(
      (DebtLedgerEntryModel item) =>
          item.linkedTransactionId == transactionId,
    )) {
      throw StateError('Transaction is already linked to a debt or loan');
    }
    final TransactionPurpose purpose = transactionPurposeFromCode(
      transaction.purposeCode,
      transaction.type,
    );
    final DebtMovementType? movement = DebtTransactionLinker.movementFor(
      kind: account.kind,
      type: transaction.type,
      purpose: purpose,
    );
    if (movement == null) {
      throw StateError('Transaction purpose does not match this debt account');
    }
    final DebtLedgerEntryModel entry = DebtLedgerEntryModel(
      debtId: debtId,
      type: movement,
      amount: transaction.amount,
      occurredAt: transaction.timestamp,
      linkedTransactionId: transaction.id,
      encryptedNote: await _cipher.encrypt(''),
    );
    return _isar.writeTxn(() async {
      final int id = await _isar.debtLedgerEntryModels.put(entry);
      account.updatedAt = DateTime.now();
      await _isar.debtAccountModels.put(account);
      return id;
    });
  }

  Future<List<ExpenseTransaction>> linkableConfirmedTransactions(
    int debtId,
  ) async {
    final DebtAccountModel? account = await _isar.debtAccountModels.get(debtId);
    if (account == null || account.isArchived) {
      return const <ExpenseTransaction>[];
    }
    final Set<int> linkedIds = (await _isar.debtLedgerEntryModels
            .where()
            .findAll())
        .map((DebtLedgerEntryModel item) => item.linkedTransactionId)
        .whereType<int>()
        .toSet();
    final List<TransactionModel> transactions = await _isar.transactionModels
        .where()
        .findAll();
    final List<TransactionModel> relevant = transactions.where(
      (TransactionModel item) {
        if (item.status != TransactionStatus.confirmed ||
            linkedIds.contains(item.id)) {
          return false;
        }
        return DebtTransactionLinker.movementFor(
              kind: account.kind,
              type: item.type,
              purpose: transactionPurposeFromCode(item.purposeCode, item.type),
            ) !=
            null;
      },
    ).toList(growable: false)
      ..sort((TransactionModel a, TransactionModel b) {
        return b.timestamp.compareTo(a.timestamp);
      });
    return Future.wait(relevant.map(_transactionToDomain));
  }

  Future<void> deleteEntry(int entryId) async {
    final DebtLedgerEntryModel? entry = await _isar.debtLedgerEntryModels.get(
      entryId,
    );
    if (entry == null) {
      return;
    }
    final DebtAccountModel? account = await _isar.debtAccountModels.get(
      entry.debtId,
    );
    await _isar.writeTxn(() async {
      await _isar.debtLedgerEntryModels.delete(entryId);
      if (account != null) {
        account.updatedAt = DateTime.now();
        await _isar.debtAccountModels.put(account);
      }
    });
  }

  Future<void> setArchived(int id, bool archived) async {
    final DebtAccountModel? model = await _isar.debtAccountModels.get(id);
    if (model == null) {
      return;
    }
    model
      ..isArchived = archived
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.debtAccountModels.put(model));
  }

  Future<void> delete(int id) async {
    final List<DebtLedgerEntryModel> entries = await _isar
        .debtLedgerEntryModels
        .where()
        .findAll();
    final List<int> entryIds = entries
        .where((DebtLedgerEntryModel item) => item.debtId == id)
        .map((DebtLedgerEntryModel item) => item.id)
        .toList(growable: false);
    await _isar.writeTxn(() async {
      await _isar.debtLedgerEntryModels.deleteAll(entryIds);
      await _isar.debtAccountModels.delete(id);
    });
  }

  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.debtLedgerEntryModels.clear();
      await _isar.debtAccountModels.clear();
    });
  }

  Future<DebtAccount> _toDomain(DebtAccountModel model) async {
    final List<DebtLedgerEntryModel> allEntries = await _isar
        .debtLedgerEntryModels
        .where()
        .findAll();
    final List<DebtLedgerEntryModel> entries = allEntries
        .where((DebtLedgerEntryModel item) => item.debtId == model.id)
        .toList(growable: false)
      ..sort((DebtLedgerEntryModel a, DebtLedgerEntryModel b) {
        return b.occurredAt.compareTo(a.occurredAt);
      });
    return DebtAccount(
      id: model.id,
      kind: model.kind,
      counterparty: await _cipher.decrypt(model.encryptedCounterparty),
      openingBalance: model.openingBalance,
      dueDate: model.dueDate,
      note: await _cipher.decrypt(model.encryptedNote),
      reminderEnabled: model.reminderEnabled,
      reminderDaysBefore: model.reminderDaysBefore,
      isArchived: model.isArchived,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      entries: await Future.wait(entries.map(_entryToDomain)),
    );
  }

  Future<DebtLedgerEntry> _entryToDomain(DebtLedgerEntryModel model) async {
    return DebtLedgerEntry(
      id: model.id,
      debtId: model.debtId,
      type: model.type,
      amount: model.amount,
      occurredAt: model.occurredAt,
      linkedTransactionId: model.linkedTransactionId,
      note: await _cipher.decrypt(model.encryptedNote),
      createdAt: model.createdAt,
    );
  }

  Future<ExpenseTransaction> _transactionToDomain(TransactionModel model) async {
    return ExpenseTransaction(
      id: model.id,
      amount: model.amount,
      type: model.type,
      purpose: transactionPurposeFromCode(model.purposeCode, model.type),
      merchant: await _cipher.decrypt(model.encryptedMerchant),
      timestamp: model.timestamp,
      categoryId: model.categoryId,
      status: model.status,
      accountTail: await _cipher.decrypt(model.encryptedAccountTail),
      originalSmsText: '',
      possibleDuplicateOf: model.possibleDuplicateOf,
      categoryManuallyAssigned: model.categoryManuallyAssigned,
      isManual: model.isManual,
      isRecurring: model.isRecurring,
    );
  }

  void _validateReminder(
    bool enabled,
    int daysBefore,
    DateTime? dueDate,
  ) {
    if (!enabled) {
      return;
    }
    if (dueDate == null) {
      throw ArgumentError('A due date is required when reminders are enabled');
    }
    if (!const <int>[1, 3, 7].contains(daysBefore)) {
      throw ArgumentError.value(daysBefore, 'daysBefore', 'Unsupported lead time');
    }
  }
}
