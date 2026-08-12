import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('phase 15 release metadata remains documented', () {
    final String changelog = File('CHANGELOG.md').readAsStringSync();

    expect(changelog, contains('## [0.13.0] - Unreleased'));
    expect(changelog, contains('EMI & Repayment Planner'));
  });

  test('repayment plans are registered as local Isar planning metadata', () {
    final String database = File(
      'lib/core/database/app_database.dart',
    ).readAsStringSync();
    final String model = File(
      'lib/features/debts/data/models/debt_repayment_plan_model.dart',
    ).readAsStringSync();

    expect(database, contains('DebtRepaymentPlanModelSchema'));
    expect(model, contains('@collection'));
    expect(model, contains('@Index(unique: true'));
    expect(model, contains('RepaymentCadence cadence'));
    expect(model, contains('double installmentAmount'));
    expect(model, contains('double annualInterestRatePct'));
    expect(model, isNot(contains('String merchant')));
    expect(model, isNot(contains('String account')));
  });

  test('Plan exposes EMI planning without auto-posting payments', () {
    final String hub = File(
      'lib/features/debts/presentation/planning_hub_screen.dart',
    ).readAsStringSync();
    final String editor = File(
      'lib/features/debts/presentation/repayment_plan_editor_screen.dart',
    ).readAsStringSync();
    final String card = File(
      'lib/features/debts/presentation/repayment_plan_card.dart',
    ).readAsStringSync();

    expect(hub, contains('EMI & repayment planner'));
    expect(hub, contains('RepaymentPlannerOverviewScreen'));
    expect(editor, contains('does not create an EMI transaction'));
    expect(editor, contains('change the debt balance'));
    expect(card, contains('Projection only'));
    expect(card, contains('Record or link the real repayment separately'));
  });

  test('repayment projection remains deterministic and network free', () {
    final String service = File(
      'lib/features/debts/services/repayment_schedule_service.dart',
    ).readAsStringSync();

    expect(service, contains('RepaymentProjection project'));
    expect(service, contains('periodsPerYear'));
    expect(service, contains('paymentTooLow'));
    expect(service, isNot(contains('package:http/')));
    expect(service, isNot(contains('package:dio/')));
    expect(service, isNot(contains('TransactionRepository')));
    expect(service, isNot(contains('DebtRepository')));
    expect(service, isNot(contains('Isar')));
  });

  test('repayment plan lifecycle follows its parent debt', () {
    final String source = File(
      'lib/features/debts/data/repositories/'
      'repayment_aware_debt_repository.dart',
    ).readAsStringSync();

    expect(source, contains('await super.delete(id)'));
    expect(source, contains('deleteForDebt(id)'));
    expect(source, contains('await super.clearAll()'));
    expect(source, contains('_repaymentPlans.clearAll()'));
  });

  test(
    'encrypted backup v7 includes repayment plans and old restores clear them',
    () {
      final String backup = File(
        'lib/features/settings/services/'
        'repayment_plan_aware_backup_service.dart',
      ).readAsStringSync();
      final String inspection = File(
        'lib/features/settings/services/backup_inspection_service.dart',
      ).readAsStringSync();

      expect(backup, contains('snapshotVersion = 7'));
      expect(backup, contains("['repaymentPlans']"));
      expect(
        backup,
        contains("'firstDueDate': _calendarDate(plan.firstDueDate)"),
      );
      expect(backup, contains('_calendarDateTime('));
      expect(backup, contains('debtRepaymentPlanModels.clear()'));
      expect(backup, contains('A debt contains more than one repayment plan'));
      expect(inspection, contains('repaymentPlans'));
    },
  );

  test('Phase 15 keeps Android network permission absent', () {
    final String manifest = File(
      'android/app/src/main/AndroidManifest.xml',
    ).readAsStringSync();
    final String plannerDocs = File(
      'docs/repayment-planner.md',
    ).readAsStringSync();

    expect(manifest, isNot(contains('android.permission.INTERNET')));
    expect(
      plannerDocs,
      contains('never changes financial records automatically'),
    );
    expect(plannerDocs, contains('no HTTP client'));
    expect(plannerDocs, contains('calendar-only `YYYY-MM-DD`'));
  });
}
