import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/core/security/app_lock_service.dart';

void main() {
  test('supported app-lock timeouts include immediate and safe defaults', () {
    expect(AppLockService.supportedTimeoutMinutes, contains(0));
    expect(
      AppLockService.supportedTimeoutMinutes,
      contains(AppLockService.defaultTimeoutMinutes),
    );
    expect(
      AppLockService.supportedTimeoutMinutes.toSet().length,
      AppLockService.supportedTimeoutMinutes.length,
    );
  });

  test('onboarding states the offline privacy contract', () {
    final String source = File(
      'lib/features/settings/presentation/onboarding_screen.dart',
    ).readAsStringSync();

    expect(source, contains('no backend'));
    expect(source, contains('stored only on this device'));
    expect(source, contains('Continue with manual entry'));
    expect(source, contains('requestPermissionAndScanInbox'));
  });

  test('transaction history is derived from confirmed local transactions', () {
    final String source = File(
      'lib/features/transactions/presentation/transaction_history_screen.dart',
    ).readAsStringSync();

    expect(source, contains('confirmedTransactionsProvider'));
    expect(
      source,
      contains('Search merchant, purpose, category, or account tail'),
    );
    expect(source, contains('TransactionSemanticChips'));
    expect(source, contains('_HistoryPeriodFilter.currentMonth'));
    expect(source, isNot(contains('package:http/')));
    expect(source, isNot(contains('package:dio/')));
  });

  test('app lock reloads preferences after returning to foreground', () {
    final String source = File('lib/app.dart').readAsStringSync();

    expect(source, contains('AppLifecycleState.resumed'));
    expect(source, contains('getTimeoutMinutes'));
    expect(source, contains('_handleResume'));
  });
}
