import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('possible duplicates stay in review for an explicit user decision', () {
    final String model = File(
      'lib/features/transactions/data/models/transaction_model.dart',
    ).readAsStringSync();
    final String repository = File(
      'lib/features/transactions/data/repositories/transaction_repository.dart',
    ).readAsStringSync();
    final String review = File(
      'lib/features/transactions/presentation/pending_transactions_screen.dart',
    ).readAsStringSync();

    expect(model, contains('int? possibleDuplicateOf;'));
    expect(repository, contains('possibleDuplicateOf: possibleDuplicateOf'));
    expect(review, contains('Possible duplicate'));
    expect(review, contains("label: 'Confirm'"));
    expect(review, contains("label: 'Remove'"));
    expect(repository, isNot(contains('delete(possibleDuplicateOf')));
  });

  test('duplicate detector remains deterministic and local-only', () {
    final String source = File(
      'lib/features/transactions/services/duplicate_transaction_detector.dart',
    ).readAsStringSync();

    expect(source, contains('amountTolerance = 1'));
    expect(source, contains('Duration(minutes: 5)'));
    expect(source, contains('_levenshtein'));
    expect(source, isNot(contains('package:http/')));
    expect(source, isNot(contains('package:dio/')));
    expect(source, isNot(contains('HttpClient(')));
  });

  test('learned merchant confidence is encrypted and confirmation-gated', () {
    final String model = File(
      'lib/features/transactions/data/models/merchant_learning_model.dart',
    ).readAsStringSync();
    final String repository = File(
      'lib/features/transactions/data/repositories/merchant_rule_repository.dart',
    ).readAsStringSync();
    final String transactions = File(
      'lib/features/transactions/data/repositories/transaction_repository.dart',
    ).readAsStringSync();
    final String settings = File(
      'lib/features/settings/presentation/merchant_rules_card.dart',
    ).readAsStringSync();

    expect(model, contains('String encryptedMerchant;'));
    expect(model, isNot(contains('String merchant;')));
    expect(repository, contains('recordConfirmedCategory'));
    expect(repository, contains('highestConfidenceCategory'));
    expect(repository, contains('await _cipher.encrypt(pattern)'));
    expect(transactions, contains('categoryManuallyAssigned'));
    expect(settings, contains('Learned from confirmations'));
    expect(settings, contains('Clear learned mapping'));
  });

  test('subscription detection is read-only and opens the existing editor', () {
    final String service = File(
      'lib/features/dashboard/services/subscription_detector_service.dart',
    ).readAsStringSync();
    final String card = File(
      'lib/features/dashboard/presentation/subscription_suggestions_card.dart',
    ).readAsStringSync();
    final String editor = File(
      'lib/features/transactions/presentation/recurring_transaction_editor.dart',
    ).readAsStringSync();

    expect(service, contains('lookbackDays = 90'));
    expect(service, contains('jitterDays = 3'));
    expect(service, contains('item.status != TransactionStatus.confirmed'));
    expect(service, isNot(contains('.save(')));
    expect(service, isNot(contains('.put(')));
    expect(card, contains('Looks like a subscription'));
    expect(card, contains('Set up as recurring'));
    expect(card, contains('showRecurringTransactionEditor'));
    expect(editor, contains('Nothing is created until you press Save'));
  });
}
