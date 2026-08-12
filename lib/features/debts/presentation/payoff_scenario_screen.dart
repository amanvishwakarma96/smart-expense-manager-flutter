import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_repayment_plan.dart';
import 'package:smart_expense_manager/features/debts/services/payoff_scenario_service.dart';

class PayoffScenarioScreen extends ConsumerStatefulWidget {
  const PayoffScenarioScreen({
    super.key,
    required this.account,
    required this.plan,
  });

  final DebtAccount account;
  final DebtRepaymentPlan plan;

  @override
  ConsumerState<PayoffScenarioScreen> createState() =>
      _PayoffScenarioScreenState();
}

class _PayoffScenarioScreenState extends ConsumerState<PayoffScenarioScreen> {
  static final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  late final TextEditingController _oneTimeController;
  late final TextEditingController _recurringController;

  @override
  void initState() {
    super.initState();
    _oneTimeController = TextEditingController(text: '0');
    _recurringController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _oneTimeController.dispose();
    _recurringController.dispose();
    super.dispose();
  }

  double _readAmount(TextEditingController controller) {
    final double parsed =
        double.tryParse(controller.text.replaceAll(',', '').trim()) ?? 0;
    return math.max(0, parsed);
  }

  String _amount(double value, bool privacyMode) => privacyMode
      ? '$defaultCurrencySymbol •••••'
      : inrCurrency.format(value);

  String _payoffLabel(RepaymentProjection projection) {
    if (projection.health == RepaymentHealth.paymentTooLow) {
      return 'Payment too low for a payoff estimate';
    }
    if (projection.estimatedPayoffDate == null) {
      return projection.health == RepaymentHealth.settled
          ? 'Already settled'
          : 'No payoff estimate';
    }
    return _dateFormat.format(projection.estimatedPayoffDate!);
  }

  @override
  Widget build(BuildContext context) {
    final bool privacyMode = ref.watch(privacyModeProvider);
    final double oneTimeExtra = _readAmount(_oneTimeController);
    final double additionalPerInstallment = _readAmount(_recurringController);
    final PayoffScenarioResult result = PayoffScenarioService(
      ref.read(repaymentScheduleServiceProvider),
    ).compare(
      plan: widget.plan,
      currentOutstanding: widget.account.outstanding,
      totalRepaid: widget.account.repaidBalance,
      oneTimeExtraAmount: oneTimeExtra,
      additionalPerInstallment: additionalPerInstallment,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Payoff what-if simulator')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
          children: <Widget>[
            Text(
              widget.account.counterparty,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.plan.cadence.label} plan • ${_amount(widget.plan.installmentAmount, privacyMode)} per installment',
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Try a hypothetical extra payment',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Nothing on this screen is saved. PiggyAI does not record a payment, change the debt balance, or edit the saved repayment plan.',
                    ),
                    if (widget.plan.isPaused) ...<Widget>[
                      const SizedBox(height: 10),
                      const Text(
                        'The saved plan is paused. This comparison still uses its installment, cadence, and APR only as hypothetical assumptions.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _oneTimeController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              obscureText: privacyMode,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'One-time extra payment',
                prefixText: '$defaultCurrencySymbol ',
                helperText: 'Applied to the current outstanding only in this scenario.',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _recurringController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              obscureText: privacyMode,
              enableSuggestions: false,
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Extra per installment',
                prefixText: '$defaultCurrencySymbol ',
                helperText: 'Added to every future planned installment in this scenario.',
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 20),
            _ComparisonCard(
              title: 'Current saved plan',
              payoff: _payoffLabel(result.baseline),
              payment: _amount(widget.plan.installmentAmount, privacyMode),
              interest: result.baseline.estimatedRemainingInterest == null
                  ? null
                  : _amount(
                      result.baseline.estimatedRemainingInterest!,
                      privacyMode,
                    ),
              payments: result.baseline.estimatedRemainingPayments,
            ),
            const SizedBox(height: 12),
            _ComparisonCard(
              title: 'What-if scenario',
              payoff: _payoffLabel(result.scenario),
              payment: result.settlesImmediately
                  ? 'No future installment'
                  : _amount(
                      widget.plan.installmentAmount +
                          additionalPerInstallment,
                      privacyMode,
                    ),
              interest: result.scenario.estimatedRemainingInterest == null
                  ? null
                  : _amount(
                      result.scenario.estimatedRemainingInterest!,
                      privacyMode,
                    ),
              payments: result.scenario.estimatedRemainingPayments,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Difference',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),
                    if (result.settlesImmediately)
                      const Text(
                        'This hypothetical one-time payment clears the tracked outstanding today.',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      )
                    else if (oneTimeExtra <= 0.01 &&
                        additionalPerInstallment <= 0.01)
                      const Text(
                        'Enter an extra amount above to compare a different payoff path.',
                      )
                    else ...<Widget>[
                      if (result.daysSaved != null)
                        Text('${result.daysSaved} days earlier payoff'),
                      if (result.paymentsSaved != null)
                        Text('${result.paymentsSaved} fewer planned installments'),
                      if (result.interestSaved != null &&
                          widget.plan.annualInterestRatePct > 0)
                        Text(
                          'Projected interest saved ${_amount(result.interestSaved!, privacyMode)}',
                        ),
                      if (result.scenario.health ==
                          RepaymentHealth.paymentTooLow)
                        const Text(
                          'This scenario still does not cover one projected interest period. Increase the installment further.',
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                    ],
                    const SizedBox(height: 12),
                    const Text(
                      'Estimates use the same local APR and cadence math as the repayment planner. Lender fees, penalties, floating-rate changes, and actual prepayment rules are not modeled.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.title,
    required this.payoff,
    required this.payment,
    required this.interest,
    required this.payments,
  });

  final String title;
  final String payoff;
  final String payment;
  final String? interest;
  final int? payments;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text('Payoff: $payoff'),
            Text('Planned installment: $payment'),
            if (payments != null) Text('Remaining installments: $payments'),
            if (interest != null) Text('Projected remaining interest: $interest'),
          ],
        ),
      ),
    );
  }
}
