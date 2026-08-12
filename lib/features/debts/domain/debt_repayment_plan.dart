enum RepaymentCadence { weekly, monthly }

enum RepaymentHealth { onTrack, dueToday, overdue, settled, paymentTooLow }

extension RepaymentCadenceDetails on RepaymentCadence {
  String get label => switch (this) {
    RepaymentCadence.weekly => 'Weekly',
    RepaymentCadence.monthly => 'Monthly',
  };

  int get periodsPerYear => switch (this) {
    RepaymentCadence.weekly => 52,
    RepaymentCadence.monthly => 12,
  };
}

class DebtRepaymentPlan {
  const DebtRepaymentPlan({
    required this.id,
    required this.debtId,
    required this.cadence,
    required this.installmentAmount,
    required this.annualInterestRatePct,
    required this.firstDueDate,
    required this.startingOutstanding,
    required this.baselineRepaidAmount,
    required this.isPaused,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final int debtId;
  final RepaymentCadence cadence;
  final double installmentAmount;
  final double annualInterestRatePct;
  final DateTime firstDueDate;
  final double startingOutstanding;
  final double baselineRepaidAmount;
  final bool isPaused;
  final DateTime createdAt;
  final DateTime updatedAt;
}

class RepaymentInstallment {
  const RepaymentInstallment({
    required this.number,
    required this.dueDate,
    required this.payment,
    required this.principal,
    required this.interest,
    required this.remainingAfter,
  });

  final int number;
  final DateTime dueDate;
  final double payment;
  final double principal;
  final double interest;
  final double remainingAfter;
}

class RepaymentProjection {
  const RepaymentProjection({
    required this.health,
    required this.currentOutstanding,
    required this.paidSincePlan,
    required this.expectedPaidByNow,
    required this.overdueAmount,
    required this.nextDueDate,
    required this.estimatedPayoffDate,
    required this.estimatedRemainingPayments,
    required this.estimatedRemainingInterest,
    required this.installments,
  });

  final RepaymentHealth health;
  final double currentOutstanding;
  final double paidSincePlan;
  final double expectedPaidByNow;
  final double overdueAmount;
  final DateTime? nextDueDate;
  final DateTime? estimatedPayoffDate;
  final int? estimatedRemainingPayments;
  final double? estimatedRemainingInterest;
  final List<RepaymentInstallment> installments;
}
