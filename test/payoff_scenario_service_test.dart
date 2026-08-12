import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_repayment_plan.dart';
import 'package:smart_expense_manager/features/debts/services/payoff_scenario_service.dart';
import 'package:smart_expense_manager/features/debts/services/repayment_schedule_service.dart';

void main() {
  const PayoffScenarioService service = PayoffScenarioService(
    RepaymentScheduleService(),
  );

  DebtRepaymentPlan plan({
    double installment = 10000,
    double rate = 12,
    DateTime? firstDueDate,
  }) {
    return DebtRepaymentPlan(
      id: 1,
      debtId: 7,
      cadence: RepaymentCadence.monthly,
      installmentAmount: installment,
      annualInterestRatePct: rate,
      firstDueDate: firstDueDate ?? DateTime(2026, 9, 12),
      startingOutstanding: 100000,
      baselineRepaidAmount: 0,
      isPaused: false,
      createdAt: DateTime(2026, 8, 12),
      updatedAt: DateTime(2026, 8, 12),
    );
  }

  test('extra installment shortens payoff without mutating the saved plan', () {
    final DebtRepaymentPlan savedPlan = plan();
    final PayoffScenarioResult result = service.compare(
      plan: savedPlan,
      currentOutstanding: 100000,
      totalRepaid: 0,
      additionalPerInstallment: 5000,
      now: DateTime(2026, 8, 12),
    );

    expect(
      result.scenario.estimatedRemainingPayments!,
      lessThan(result.baseline.estimatedRemainingPayments!),
    );
    expect(
      result.scenario.estimatedPayoffDate!.isBefore(
        result.baseline.estimatedPayoffDate!,
      ),
      isTrue,
    );
    expect(result.interestSaved, greaterThan(0));
    expect(result.paymentsSaved, greaterThan(0));
    expect(result.daysSaved, greaterThan(0));
    expect(savedPlan.installmentAmount, 10000);
  });

  test('one-time prepayment reduces projected interest and outstanding', () {
    final PayoffScenarioResult result = service.compare(
      plan: plan(),
      currentOutstanding: 100000,
      totalRepaid: 0,
      oneTimeExtraAmount: 25000,
      now: DateTime(2026, 8, 12),
    );

    expect(result.adjustedOutstanding, 75000);
    expect(
      result.scenario.estimatedRemainingInterest!,
      lessThan(result.baseline.estimatedRemainingInterest!),
    );
    expect(result.interestSaved, greaterThan(0));
  });

  test('one-time amount can settle the hypothetical scenario today', () {
    final DateTime now = DateTime(2026, 8, 12, 17, 30);
    final PayoffScenarioResult result = service.compare(
      plan: plan(),
      currentOutstanding: 40000,
      totalRepaid: 0,
      oneTimeExtraAmount: 50000,
      now: now,
    );

    expect(result.settlesImmediately, isTrue);
    expect(result.scenario.health, RepaymentHealth.settled);
    expect(result.scenario.estimatedPayoffDate, DateTime(2026, 8, 12));
    expect(result.scenario.estimatedRemainingPayments, 0);
    expect(result.scenario.estimatedRemainingInterest, 0);
  });

  test('extra installment can rescue a payment-too-low baseline', () {
    final PayoffScenarioResult result = service.compare(
      plan: plan(installment: 100, rate: 24),
      currentOutstanding: 10000,
      totalRepaid: 0,
      additionalPerInstallment: 300,
      now: DateTime(2026, 8, 12),
    );

    expect(result.baseline.health, RepaymentHealth.paymentTooLow);
    expect(result.scenario.health, isNot(RepaymentHealth.paymentTooLow));
    expect(result.scenario.estimatedPayoffDate, isNotNull);
    expect(result.interestSaved, isNull);
  });

  test('zero extras reproduce the same payoff projection', () {
    final PayoffScenarioResult result = service.compare(
      plan: plan(),
      currentOutstanding: 60000,
      totalRepaid: 0,
      now: DateTime(2026, 8, 12),
    );

    expect(
      result.scenario.estimatedPayoffDate,
      result.baseline.estimatedPayoffDate,
    );
    expect(
      result.scenario.estimatedRemainingPayments,
      result.baseline.estimatedRemainingPayments,
    );
    expect(result.interestSaved, closeTo(0, 0.0001));
    expect(result.daysSaved, 0);
  });

  test('negative hypothetical amounts are rejected', () {
    expect(
      () => service.compare(
        plan: plan(),
        currentOutstanding: 10000,
        totalRepaid: 0,
        oneTimeExtraAmount: -1,
        now: DateTime(2026, 8, 12),
      ),
      throwsArgumentError,
    );
    expect(
      () => service.compare(
        plan: plan(),
        currentOutstanding: 10000,
        totalRepaid: 0,
        additionalPerInstallment: -1,
        now: DateTime(2026, 8, 12),
      ),
      throwsArgumentError,
    );
  });
}
