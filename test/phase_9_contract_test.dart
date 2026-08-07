import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('weekly challenge UI is playful and privacy aware', () {
    final String source = File(
      'lib/features/challenges/presentation/weekly_money_challenge_card.dart',
    ).readAsStringSync();

    expect(source, contains('Weekly money quest'));
    expect(source, contains('Reward shelf'));
    expect(source, contains('privacyMode'));
    expect(source, contains(r"'$defaultCurrencySymbol •••••'"));
    expect(source, contains('flutter_animate'));
  });

  test('weekly quests never modify transaction or budget records', () {
    final String repository = File(
      'lib/features/challenges/data/repositories/'
      'weekly_challenge_repository.dart',
    ).readAsStringSync();

    expect(repository, contains('transactionModels'));
    expect(repository, isNot(contains('transactionModels.put')));
    expect(repository, isNot(contains('categoryModels.put')));
    expect(repository, isNot(contains('monthlyBudgetLimit =')));
  });

  test('challenge engine remains local-only', () {
    final String domain = File(
      'lib/features/challenges/domain/weekly_challenge.dart',
    ).readAsStringSync();
    final String repository = File(
      'lib/features/challenges/data/repositories/'
      'weekly_challenge_repository.dart',
    ).readAsStringSync();

    for (final String source in <String>[domain, repository]) {
      expect(source, isNot(contains('package:http/')));
      expect(source, isNot(contains('package:dio/')));
      expect(source, isNot(contains('dart:io')));
    }
  });

  test('full local deletion clears challenge history', () {
    final String source = File(
      'lib/features/transactions/data/repositories/'
      'transaction_repository.dart',
    ).readAsStringSync();

    expect(source, contains('weeklyChallengeModels.clear()'));
  });
}
