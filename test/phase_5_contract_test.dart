import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('INR remains the default application currency', () {
    final String source = File(
      'lib/core/utils/formatters.dart',
    ).readAsStringSync();

    expect(source, contains("defaultCurrencyCode = 'INR'"));
    expect(source, contains("defaultCurrencySymbol = '₹'"));
    expect(source, contains("defaultCurrencyLocale = 'en_IN'"));
  });

  test('recurring entries always enter pending review', () {
    final String source = File(
      'lib/features/transactions/data/repositories/'
      'recurring_transaction_repository.dart',
    ).readAsStringSync();

    expect(source, contains('status: TransactionStatus.pending'));
    expect(source, contains('isRecurring: true'));
    expect(source, isNot(contains('status: TransactionStatus.confirmed')));
  });

  test('recurring merchant text is encrypted before persistence', () {
    final String source = File(
      'lib/features/transactions/data/repositories/'
      'recurring_transaction_repository.dart',
    ).readAsStringSync();

    expect(source, contains('encryptedMerchant = await _cipher.encrypt'));
    expect(source, isNot(contains('String merchant;')));
  });

  test('encrypted backups include recurring schedules', () {
    final String source = File(
      'lib/features/settings/services/local_backup_service.dart',
    ).readAsStringSync();

    expect(source, contains("'recurringTransactions': recurringPayload"));
    expect(source, contains('recurringTransactionModels.putAll(recurring)'));
    expect(source, contains('supportedSnapshotVersions'));
  });

  test('playful design system keeps pastel gradients and animated states', () {
    final String themeSource = File(
      'lib/core/theme/app_theme.dart',
    ).readAsStringSync();
    final String emptyStateSource = File(
      'lib/core/widgets/playful_empty_state.dart',
    ).readAsStringSync();

    expect(themeSource, contains('heroGradient'));
    expect(themeSource, contains('playfulSequence'));
    expect(emptyStateSource, contains('flutter_animate'));
    expect(emptyStateSource, contains('Curves.easeOutBack'));
  });
}
