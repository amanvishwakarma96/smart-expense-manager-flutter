import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('phase 16 release metadata is aligned', () {
    final String pubspec = File('pubspec.yaml').readAsStringSync();
    final String docs = File('docs/payoff-simulator.md').readAsStringSync();

    expect(pubspec, contains('version: 0.14.0+14'));
    expect(docs, contains('Phase 16'));
    expect(docs, contains('Payoff what-if simulator'));
  });

  test('payoff simulator is reachable from the saved repayment plan', () {
    final String card = File(
      'lib/features/debts/presentation/repayment_plan_card.dart',
    ).readAsStringSync();
    final String screen = File(
      'lib/features/debts/presentation/payoff_scenario_screen.dart',
    ).readAsStringSync();

    expect(card, contains('PayoffScenarioScreen'));
    expect(card, contains('Try payoff options'));
    expect(screen, contains('One-time extra payment'));
    expect(screen, contains('Extra per installment'));
    expect(screen, contains('Nothing on this screen is saved'));
    expect(screen, contains('does not record a payment'));
    expect(screen, contains('change the debt balance'));
  });

  test('scenario calculator is deterministic and has no write dependencies', () {
    final String service = File(
      'lib/features/debts/services/payoff_scenario_service.dart',
    ).readAsStringSync();

    expect(service, contains('PayoffScenarioResult compare'));
    expect(service, contains('RepaymentScheduleService'));
    expect(service, contains('oneTimeExtraAmount'));
    expect(service, contains('additionalPerInstallment'));
    expect(service, isNot(contains('TransactionRepository')));
    expect(service, isNot(contains('DebtRepository')));
    expect(service, isNot(contains('Isar')));
    expect(service, isNot(contains('SharedPreferences')));
    expect(service, isNot(contains('flutter_secure_storage')));
    expect(service, isNot(contains('package:http/')));
    expect(service, isNot(contains('package:dio/')));
  });

  test('Phase 16 does not introduce Android network permission', () {
    final String manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final String docs = File('docs/payoff-simulator.md').readAsStringSync();

    expect(manifest, isNot(contains('android.permission.INTERNET')));
    expect(docs, contains('No backend'));
    expect(docs, contains('no database collection'));
    expect(docs, contains('backup snapshot version 7 remains unchanged'));
  });
}
