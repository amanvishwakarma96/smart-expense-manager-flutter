import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('goal names are encrypted before local persistence', () {
    final String model = File(
      'lib/features/goals/data/models/savings_goal_model.dart',
    ).readAsStringSync();
    final String repository = File(
      'lib/features/goals/data/repositories/savings_goal_repository.dart',
    ).readAsStringSync();

    expect(model, contains('String encryptedName;'));
    expect(model, isNot(contains('String name;')));
    expect(repository, contains('await _cipher.encrypt(normalizedName)'));
    expect(repository, contains('await _cipher.decrypt(model.encryptedName)'));
  });

  test('cash-flow calendar only consumes confirmed transaction stream', () {
    final String source = File(
      'lib/features/goals/presentation/goals_calendar_screen.dart',
    ).readAsStringSync();

    expect(source, contains('confirmedTransactionsProvider'));
    expect(source, isNot(contains('pendingTransactionsProvider')));
    expect(source, contains('privacyModeProvider'));
  });

  test('encrypted backups continue to include savings goals', () {
    final String source = File(
      'lib/features/settings/services/local_backup_service.dart',
    ).readAsStringSync();

    expect(source, contains('snapshotVersion = 5'));
    expect(
      source,
      contains('supportedSnapshotVersions = <int>{1, 2, 3, 4, 5}'),
    );
    expect(source, contains("'savingsGoals': goalPayload"));
    expect(source, contains('savingsGoalModels.putAll(goals)'));
    expect(source, contains('rawVersion >= 3'));
  });

  test('full local deletion clears savings goals', () {
    final String source = File(
      'lib/features/transactions/data/repositories/'
      'transaction_repository.dart',
    ).readAsStringSync();

    expect(source, contains('savingsGoalModels.clear()'));
  });

  test('main navigation keeps one clear goals destination through Plan', () {
    final String app = File('lib/app.dart').readAsStringSync();
    final String planning = File(
      'lib/features/debts/presentation/planning_hub_screen.dart',
    ).readAsStringSync();

    expect(app, contains('PlanningHubScreen()'));
    expect(app, contains("label: 'Plan'"));
    expect(planning, contains('GoalsCalendarScreen()'));
    expect(planning, contains("title: 'Goals & calendar'"));
    expect(app, contains('_index <= 2'));
  });

  test('phase six remains offline and playful', () {
    final String source = File(
      'lib/features/goals/presentation/goals_calendar_screen.dart',
    ).readAsStringSync();

    expect(source, contains('heroGradient'));
    expect(source, contains('milestone star'));
    expect(source, contains('flutter_animate'));
    expect(source, isNot(contains('package:http/')));
    expect(source, isNot(contains('package:dio/')));
  });
}
