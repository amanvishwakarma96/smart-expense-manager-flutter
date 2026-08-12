import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('phase 14 release metadata is aligned', () {
    final String pubspec = File('pubspec.yaml').readAsStringSync();
    final String changelog = File('CHANGELOG.md').readAsStringSync();

    expect(pubspec, contains('version: 0.12.0+12'));
    expect(changelog, contains('## [0.12.0] - Unreleased'));
    expect(changelog, contains('Debt & Loan Manager'));
  });

  test('debt counterparty and notes are encrypted at rest', () {
    final String accountModel = File(
      'lib/features/debts/data/models/debt_account_model.dart',
    ).readAsStringSync();
    final String entryModel = File(
      'lib/features/debts/data/models/debt_ledger_entry_model.dart',
    ).readAsStringSync();
    final String repository = File(
      'lib/features/debts/data/repositories/debt_repository.dart',
    ).readAsStringSync();

    expect(accountModel, contains('String encryptedCounterparty;'));
    expect(accountModel, contains('String encryptedNote;'));
    expect(accountModel, isNot(contains('String counterparty;')));
    expect(entryModel, contains('String encryptedNote;'));
    expect(repository, contains('_cipher.encrypt(normalizedCounterparty)'));
    expect(
      repository,
      contains('_cipher.decrypt(model.encryptedCounterparty)'),
    );
  });

  test('database and planning hub expose private debt ledgers', () {
    final String database = File(
      'lib/core/database/app_database.dart',
    ).readAsStringSync();
    final String app = File('lib/app.dart').readAsStringSync();
    final String planning = File(
      'lib/features/debts/presentation/planning_hub_screen.dart',
    ).readAsStringSync();

    expect(database, contains('DebtAccountModelSchema'));
    expect(database, contains('DebtLedgerEntryModelSchema'));
    expect(app, contains('PlanningHubScreen()'));
    expect(app, contains("label: 'Plan'"));
    expect(planning, contains("title: 'Debts & loans'"));
    expect(planning, contains("title: 'Goals & calendar'"));
  });

  test('lent repayment is a credit purpose without income semantics', () {
    final String transaction = File(
      'lib/features/transactions/domain/expense_transaction.dart',
    ).readAsStringSync();

    expect(transaction, contains('lentRepayment'));
    expect(transaction, contains("'Lent money repaid'"));
    expect(transaction, contains('TransactionPurpose.lentRepayment,'));
    expect(
      transaction,
      contains('bool get countsAsIncome => this == TransactionPurpose.income;'),
    );
  });

  test(
    'debt transaction linking always requires explicit confirmed selection',
    () {
      final String repository = File(
        'lib/features/debts/data/repositories/debt_repository.dart',
      ).readAsStringSync();
      final String detail = File(
        'lib/features/debts/presentation/debt_detail_screen.dart',
      ).readAsStringSync();

      expect(repository, contains('TransactionStatus.confirmed'));
      expect(repository, contains('linkConfirmedTransaction'));
      expect(detail, contains("title: 'Link this transaction?'"));
      expect(detail, contains('The original transaction will not be edited.'));
      expect(detail, contains('This changes only the debt ledger.'));
    },
  );

  test('debt reminders are local and financial-detail free', () {
    final String reminder = File(
      'lib/features/debts/services/debt_reminder_service.dart',
    ).readAsStringSync();

    expect(reminder, contains('Debt or loan due date coming up'));
    expect(
      reminder,
      contains('Open PiggyAI to review a private local balance.'),
    );
    expect(reminder, contains('AndroidScheduleMode.inexactAllowWhileIdle'));
    expect(reminder, isNot(contains('encryptedCounterparty')));
    expect(reminder, isNot(contains('openingBalance')));
    expect(reminder, isNot(contains('accountTail')));
  });

  test('encrypted backup v6 includes and restores debt ledgers', () {
    final String backup = File(
      'lib/features/settings/services/debt_aware_backup_service.dart',
    ).readAsStringSync();
    final String providers = File(
      'lib/core/providers/app_providers.dart',
    ).readAsStringSync();

    expect(backup, contains('snapshotVersion = 6'));
    expect(backup, contains("['debtAccounts']"));
    expect(backup, contains("['debtEntries']"));
    expect(backup, contains('debtAccountModels.putAll'));
    expect(backup, contains('debtLedgerEntryModels.putAll'));
    expect(providers, contains('DebtAwareBackupService('));
  });

  test(
    'delete all clears debt ledgers and no internet permission is added',
    () {
      final String settings = File(
        'lib/features/settings/presentation/settings_screen.dart',
      ).readAsStringSync();
      final String manifest = File(
        'android/app/src/main/AndroidManifest.xml',
      ).readAsStringSync();

      expect(settings, contains('debtRepositoryProvider).clearAll()'));
      expect(manifest, isNot(contains('android.permission.INTERNET')));
    },
  );
}
