import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('forecast remains deterministic and local-only', () {
    final String source = File(
      'lib/features/dashboard/domain/spending_forecast.dart',
    ).readAsStringSync();

    expect(source, contains('historyWindowDays = 60'));
    expect(source, contains('forecastWindowDays = 30'));
    expect(source, contains('!item.isRecurring'));
    expect(source, isNot(contains('package:http/')));
    expect(source, isNot(contains('package:dio/')));
    expect(source, isNot(contains('HttpClient(')));
  });

  test('forecast card obeys privacy masking', () {
    final String source = File(
      'lib/features/dashboard/presentation/spending_forecast_card.dart',
    ).readAsStringSync();

    expect(source, contains('privacyMode'));
    expect(source, contains("'$defaultCurrencySymbol •••••'"));
    expect(source, contains('calculated only on this device'));
  });

  test('category deletion checks every local reference type', () {
    final String source = File(
      'lib/features/transactions/data/repositories/category_repository.dart',
    ).readAsStringSync();

    expect(source, contains('transactionModels'));
    expect(source, contains('recurringTransactionModels'));
    expect(source, contains('merchantRuleModels'));
    expect(source, contains('CategoryDeleteResult.inUse'));
    expect(source, contains('CategoryDeleteResult.lastCategory'));
  });

  test('merchant matching prefers longer specific rules', () {
    final String source = File(
      'lib/features/transactions/data/repositories/'
      'merchant_rule_repository.dart',
    ).readAsStringSync();

    expect(source, contains('b.merchantPattern.length.compareTo'));
    expect(source, contains('normalized.contains(rule.merchantPattern)'));
    expect(source, contains('watchAll()'));
  });

  test('settings exposes full category and rule management', () {
    final String settings = File(
      'lib/features/settings/presentation/settings_screen.dart',
    ).readAsStringSync();
    final String categoryCard = File(
      'lib/features/settings/presentation/category_management_card.dart',
    ).readAsStringSync();
    final String ruleCard = File(
      'lib/features/settings/presentation/merchant_rules_card.dart',
    ).readAsStringSync();

    expect(settings, contains('CategoryManagementCard'));
    expect(settings, contains('MerchantRulesCard'));
    expect(categoryCard, contains('New category'));
    expect(categoryCard, contains('Delete'));
    expect(ruleCard, contains('New merchant rule'));
    expect(ruleCard, contains('Edit rule'));
  });

  test('phase 7 does not introduce internet permission', () {
    final List<File> manifests = Directory('android/app/src')
        .listSync(recursive: true)
        .whereType<File>()
        .where((File file) => file.path.endsWith('AndroidManifest.xml'))
        .toList();

    for (final File manifest in manifests) {
      expect(
        manifest.readAsStringSync(),
        isNot(contains('android.permission.INTERNET')),
      );
    }
  });
}
