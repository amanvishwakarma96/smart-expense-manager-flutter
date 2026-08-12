import 'dart:math' as math;

import 'package:smart_expense_manager/features/debts/domain/debt_repayment_plan.dart';

class RepaymentScheduleService {
  const RepaymentScheduleService();

  static const int maxProjectionPeriods = 600;
  static const int previewPeriods = 12;

  RepaymentProjection project({
    required DebtRepaymentPlan plan,
    required double currentOutstanding,
    required double totalRepaid,
    DateTime? now,
  }) {
    final DateTime today = _dateOnly(now ?? DateTime.now());
    final double outstanding = math.max(0, currentOutstanding);
    final double paidSincePlan = math.max(
      0,
      totalRepaid - plan.baselineRepaidAmount,
    );

    if (outstanding <= 0.01) {
      return RepaymentProjection(
        health: RepaymentHealth.settled,
        currentOutstanding: 0,
        paidSincePlan: paidSincePlan,
        expectedPaidByNow: 0,
        overdueAmount: 0,
        nextDueDate: null,
        estimatedPayoffDate: null,
        estimatedRemainingPayments: 0,
        estimatedRemainingInterest: 0,
        installments: const <RepaymentInstallment>[],
      );
    }

    final double installment = plan.installmentAmount;
    if (installment <= 0) {
      throw ArgumentError.value(
        installment,
        'installmentAmount',
        'Installment amount must be greater than zero',
      );
    }

    final int dueCount = _dueCountThrough(
      firstDueDate: plan.firstDueDate,
      cadence: plan.cadence,
      through: today,
    );
    final double expectedPaidByNow = dueCount * installment;
    final double overdueAmount = math.max(0, expectedPaidByNow - paidSincePlan);
    final int coveredInstallments = (paidSincePlan / installment).floor();
    final DateTime earliestUnpaidDue = _dueDateAt(
      firstDueDate: plan.firstDueDate,
      cadence: plan.cadence,
      index: coveredInstallments,
    );
    final int currentOrFutureIndex = _currentOrFutureDueIndex(
      firstDueDate: plan.firstDueDate,
      cadence: plan.cadence,
      dueCount: dueCount,
      today: today,
    );
    final int projectionStartIndex = coveredInstallments > currentOrFutureIndex
        ? coveredInstallments
        : currentOrFutureIndex;

    final double ratePerPeriod = plan.annualInterestRatePct <= 0
        ? 0
        : plan.annualInterestRatePct /
              100 /
              plan.cadence.periodsPerYear.toDouble();
    final double firstInterest = outstanding * ratePerPeriod;
    if (ratePerPeriod > 0 && installment <= firstInterest + 0.005) {
      return RepaymentProjection(
        health: RepaymentHealth.paymentTooLow,
        currentOutstanding: outstanding,
        paidSincePlan: paidSincePlan,
        expectedPaidByNow: expectedPaidByNow,
        overdueAmount: overdueAmount,
        nextDueDate: earliestUnpaidDue,
        estimatedPayoffDate: null,
        estimatedRemainingPayments: null,
        estimatedRemainingInterest: null,
        installments: const <RepaymentInstallment>[],
      );
    }

    final List<RepaymentInstallment> preview = <RepaymentInstallment>[];
    double remaining = outstanding;
    double interestTotal = 0;
    int periods = 0;
    DateTime? payoffDate;

    while (remaining > 0.01 && periods < maxProjectionPeriods) {
      final double interest = remaining * ratePerPeriod;
      final double payment = math.min(installment, remaining + interest);
      final double principal = math.max(0, payment - interest);
      remaining = math.max(0, remaining - principal);
      interestTotal += interest;
      final DateTime dueDate = _dueDateAt(
        firstDueDate: plan.firstDueDate,
        cadence: plan.cadence,
        index: projectionStartIndex + periods,
      );
      if (preview.length < previewPeriods) {
        preview.add(
          RepaymentInstallment(
            number: periods + 1,
            dueDate: dueDate,
            payment: payment,
            principal: principal,
            interest: interest,
            remainingAfter: remaining,
          ),
        );
      }
      periods += 1;
      if (remaining <= 0.01) {
        payoffDate = dueDate;
      }
    }

    final DateTime nextDue = earliestUnpaidDue;
    final RepaymentHealth health;
    if (overdueAmount > 0.01 && nextDue.isBefore(today)) {
      health = RepaymentHealth.overdue;
    } else if (_sameDay(nextDue, today)) {
      health = RepaymentHealth.dueToday;
    } else {
      health = RepaymentHealth.onTrack;
    }

    return RepaymentProjection(
      health: health,
      currentOutstanding: outstanding,
      paidSincePlan: paidSincePlan,
      expectedPaidByNow: expectedPaidByNow,
      overdueAmount: overdueAmount,
      nextDueDate: nextDue,
      estimatedPayoffDate: payoffDate,
      estimatedRemainingPayments: payoffDate == null ? null : periods,
      estimatedRemainingInterest: payoffDate == null ? null : interestTotal,
      installments: List<RepaymentInstallment>.unmodifiable(preview),
    );
  }

  int _currentOrFutureDueIndex({
    required DateTime firstDueDate,
    required RepaymentCadence cadence,
    required int dueCount,
    required DateTime today,
  }) {
    if (dueCount == 0) {
      return 0;
    }
    final int lastDueIndex = dueCount - 1;
    final DateTime lastDue = _dueDateAt(
      firstDueDate: firstDueDate,
      cadence: cadence,
      index: lastDueIndex,
    );
    return _sameDay(lastDue, today) ? lastDueIndex : dueCount;
  }

  int _dueCountThrough({
    required DateTime firstDueDate,
    required RepaymentCadence cadence,
    required DateTime through,
  }) {
    final DateTime first = _dateOnly(firstDueDate);
    if (first.isAfter(through)) {
      return 0;
    }
    int count = 0;
    while (count < maxProjectionPeriods) {
      final DateTime due = _dueDateAt(
        firstDueDate: first,
        cadence: cadence,
        index: count,
      );
      if (due.isAfter(through)) {
        break;
      }
      count += 1;
    }
    return count;
  }

  DateTime _dueDateAt({
    required DateTime firstDueDate,
    required RepaymentCadence cadence,
    required int index,
  }) {
    final DateTime first = _dateOnly(firstDueDate);
    if (cadence == RepaymentCadence.weekly) {
      return first.add(Duration(days: index * 7));
    }
    final int rawMonth = first.month - 1 + index;
    final int year = first.year + rawMonth ~/ 12;
    final int month = rawMonth % 12 + 1;
    final int lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, math.min(first.day, lastDay));
  }

  DateTime _dateOnly(DateTime value) => DateTime(value.year, value.month, value.day);

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
