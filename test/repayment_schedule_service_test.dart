import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_repayment_plan.dart';
import 'package:smart_expense_manager/features/debts/services/repayment_schedule_service.dart';

void main() {
  const RepaymentScheduleService service = RepaymentScheduleService();

  DebtRepaymentPlan plan({
    RepaymentCadence cadence = RepaymentCadence.monthly,
    double installment = 1000,
    double rate = 0,
    DateTime? firstDueDate,
    double startingOutstanding = 3000,
    double baselineRepaid = 0,
  }) {
    return DebtRepaymentPlan(
      id: 1,
      debtId: 1,
      cadence: cadence,
      installmentAmount: installment,
      annualInterestRatePct: rate,
      firstDueDate: firstDueDate ?? DateTime(2026, 9, 30),
      startingOutstanding: startingOutstanding,
      baselineRepaidAmount: baselineRepaid,
      isPaused: false,
      createdAt: DateTime(2026, 8, 12),
      updatedAt: DateTime(2026, 8, 12),
    );
  }

  test('zero-interest plan projects payoff without changing ledger data', () {
    final RepaymentProjection result = service.project(
      plan: plan(),
      currentOutstanding: 2500,
      totalRepaid: 500,
      now: DateTime(2026, 8, 12),
    );

    expect(result.health, RepaymentHealth.onTrack);
    expect(result.estimatedRemainingPayments, 3);
    expect(result.estimatedRemainingInterest, 0);
    expect(result.installments.map((item) => item.payment), <double>[
      1000,
      1000,
      500,
    ]);
    expect(result.installments.last.remainingAfter, 0);
  });

  test('monthly cadence keeps the anchor day and clamps short months', () {
    final RepaymentProjection result = service.project(
      plan: plan(
        installment: 500,
        firstDueDate: DateTime(2027, 1, 31),
        startingOutstanding: 1500,
      ),
      currentOutstanding: 1500,
      totalRepaid: 0,
      now: DateTime(2027, 1, 1),
    );

    expect(result.installments[0].dueDate, DateTime(2027, 1, 31));
    expect(result.installments[1].dueDate, DateTime(2027, 2, 28));
    expect(result.installments[2].dueDate, DateTime(2027, 3, 31));
  });

  test('month-end anchor survives an already covered installment', () {
    final RepaymentProjection result = service.project(
      plan: plan(
        installment: 500,
        firstDueDate: DateTime(2027, 1, 31),
        startingOutstanding: 1500,
      ),
      currentOutstanding: 1000,
      totalRepaid: 500,
      now: DateTime(2027, 2, 1),
    );

    expect(result.nextDueDate, DateTime(2027, 2, 28));
    expect(result.installments[0].dueDate, DateTime(2027, 2, 28));
    expect(result.installments[1].dueDate, DateTime(2027, 3, 31));
  });

  test('missed scheduled amount is surfaced as overdue', () {
    final RepaymentProjection result = service.project(
      plan: plan(
        installment: 1000,
        firstDueDate: DateTime(2026, 6, 10),
        startingOutstanding: 5000,
      ),
      currentOutstanding: 4500,
      totalRepaid: 500,
      now: DateTime(2026, 8, 12),
    );

    expect(result.health, RepaymentHealth.overdue);
    expect(result.expectedPaidByNow, 3000);
    expect(result.paidSincePlan, 500);
    expect(result.overdueAmount, 2500);
    expect(result.nextDueDate, DateTime(2026, 6, 10));
  });

  test('payment too low to cover projected interest is flagged', () {
    final RepaymentProjection result = service.project(
      plan: plan(
        installment: 50,
        rate: 24,
        startingOutstanding: 10000,
      ),
      currentOutstanding: 10000,
      totalRepaid: 0,
      now: DateTime(2026, 8, 12),
    );

    expect(result.health, RepaymentHealth.paymentTooLow);
    expect(result.estimatedPayoffDate, isNull);
    expect(result.estimatedRemainingPayments, isNull);
    expect(result.installments, isEmpty);
  });

  test('interest projection splits payment into interest and principal', () {
    final RepaymentProjection result = service.project(
      plan: plan(
        installment: 1000,
        rate: 12,
        startingOutstanding: 5000,
      ),
      currentOutstanding: 5000,
      totalRepaid: 0,
      now: DateTime(2026, 8, 12),
    );

    expect(result.installments.first.interest, closeTo(50, 0.01));
    expect(result.installments.first.principal, closeTo(950, 0.01));
    expect(result.estimatedRemainingInterest, greaterThan(0));
  });

  test('settled ledger produces no future schedule', () {
    final RepaymentProjection result = service.project(
      plan: plan(),
      currentOutstanding: 0,
      totalRepaid: 3000,
      now: DateTime(2026, 8, 12),
    );

    expect(result.health, RepaymentHealth.settled);
    expect(result.nextDueDate, isNull);
    expect(result.installments, isEmpty);
  });
}
