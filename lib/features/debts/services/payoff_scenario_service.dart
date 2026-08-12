import 'dart:math' as math;

import 'package:smart_expense_manager/features/debts/domain/debt_repayment_plan.dart';
import 'package:smart_expense_manager/features/debts/services/repayment_schedule_service.dart';

class PayoffScenarioResult {
  const PayoffScenarioResult({
    required this.baseline,
    required this.scenario,
    required this.oneTimeExtraAmount,
    required this.additionalPerInstallment,
    required this.adjustedOutstanding,
    required this.interestSaved,
    required this.paymentsSaved,
    required this.daysSaved,
  });

  final RepaymentProjection baseline;
  final RepaymentProjection scenario;
  final double oneTimeExtraAmount;
  final double additionalPerInstallment;
  final double adjustedOutstanding;
  final double? interestSaved;
  final int? paymentsSaved;
  final int? daysSaved;

  bool get settlesImmediately =>
      adjustedOutstanding <= 0.01 && oneTimeExtraAmount > 0;
}

class PayoffScenarioService {
  const PayoffScenarioService(this._scheduleService);

  final RepaymentScheduleService _scheduleService;

  PayoffScenarioResult compare({
    required DebtRepaymentPlan plan,
    required double currentOutstanding,
    required double totalRepaid,
    double oneTimeExtraAmount = 0,
    double additionalPerInstallment = 0,
    DateTime? now,
  }) {
    if (oneTimeExtraAmount < 0) {
      throw ArgumentError.value(
        oneTimeExtraAmount,
        'oneTimeExtraAmount',
        'One-time extra amount cannot be negative',
      );
    }
    if (additionalPerInstallment < 0) {
      throw ArgumentError.value(
        additionalPerInstallment,
        'additionalPerInstallment',
        'Additional installment amount cannot be negative',
      );
    }

    final DateTime effectiveNow = now ?? DateTime.now();
    final RepaymentProjection baseline = _scheduleService.project(
      plan: plan,
      currentOutstanding: currentOutstanding,
      totalRepaid: totalRepaid,
      now: effectiveNow,
    );

    final double adjustedOutstanding = math.max(
      0,
      currentOutstanding - oneTimeExtraAmount,
    );

    if (adjustedOutstanding <= 0.01) {
      final DateTime today = DateTime(
        effectiveNow.year,
        effectiveNow.month,
        effectiveNow.day,
      );
      final RepaymentProjection scenario = RepaymentProjection(
        health: RepaymentHealth.settled,
        currentOutstanding: 0,
        paidSincePlan: baseline.paidSincePlan,
        expectedPaidByNow: baseline.expectedPaidByNow,
        overdueAmount: 0,
        nextDueDate: null,
        estimatedPayoffDate: today,
        estimatedRemainingPayments: 0,
        estimatedRemainingInterest: 0,
        installments: const <RepaymentInstallment>[],
      );
      return _result(
        baseline: baseline,
        scenario: scenario,
        oneTimeExtraAmount: oneTimeExtraAmount,
        additionalPerInstallment: additionalPerInstallment,
        adjustedOutstanding: adjustedOutstanding,
      );
    }

    final DebtRepaymentPlan scenarioPlan = DebtRepaymentPlan(
      id: plan.id,
      debtId: plan.debtId,
      cadence: plan.cadence,
      installmentAmount: plan.installmentAmount + additionalPerInstallment,
      annualInterestRatePct: plan.annualInterestRatePct,
      firstDueDate: plan.firstDueDate,
      startingOutstanding: plan.startingOutstanding,
      baselineRepaidAmount: plan.baselineRepaidAmount,
      isPaused: plan.isPaused,
      createdAt: plan.createdAt,
      updatedAt: plan.updatedAt,
    );

    final RepaymentProjection scenario = _scheduleService.project(
      plan: scenarioPlan,
      currentOutstanding: adjustedOutstanding,
      totalRepaid: totalRepaid,
      now: effectiveNow,
    );

    return _result(
      baseline: baseline,
      scenario: scenario,
      oneTimeExtraAmount: oneTimeExtraAmount,
      additionalPerInstallment: additionalPerInstallment,
      adjustedOutstanding: adjustedOutstanding,
    );
  }

  PayoffScenarioResult _result({
    required RepaymentProjection baseline,
    required RepaymentProjection scenario,
    required double oneTimeExtraAmount,
    required double additionalPerInstallment,
    required double adjustedOutstanding,
  }) {
    final double? interestSaved =
        baseline.estimatedRemainingInterest == null ||
            scenario.estimatedRemainingInterest == null
        ? null
        : math.max(
            0,
            baseline.estimatedRemainingInterest! -
                scenario.estimatedRemainingInterest!,
          );

    final int? paymentsSaved =
        baseline.estimatedRemainingPayments == null ||
            scenario.estimatedRemainingPayments == null
        ? null
        : math.max(
            0,
            baseline.estimatedRemainingPayments! -
                scenario.estimatedRemainingPayments!,
          );

    final int? daysSaved =
        baseline.estimatedPayoffDate == null ||
            scenario.estimatedPayoffDate == null
        ? null
        : math.max(
            0,
            baseline.estimatedPayoffDate!
                .difference(scenario.estimatedPayoffDate!)
                .inDays,
          );

    return PayoffScenarioResult(
      baseline: baseline,
      scenario: scenario,
      oneTimeExtraAmount: oneTimeExtraAmount,
      additionalPerInstallment: additionalPerInstallment,
      adjustedOutstanding: adjustedOutstanding,
      interestSaved: interestSaved,
      paymentsSaved: paymentsSaved,
      daysSaved: daysSaved,
    );
  }
}
