import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_repayment_plan.dart';
import 'package:smart_expense_manager/features/debts/presentation/repayment_plan_editor_screen.dart';

class RepaymentPlanCard extends ConsumerWidget {
  const RepaymentPlanCard({
    super.key,
    required this.account,
    required this.privacyMode,
  });

  static final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  final DebtAccount account;
  final bool privacyMode;

  String _amount(double value) =>
      privacyMode ? '$defaultCurrencySymbol •••••' : inrCurrency.format(value);

  Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref, {
    DebtRepaymentPlan? plan,
  }) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RepaymentPlanEditorScreen(
          account: account,
          existingPlan: plan,
        ),
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    DebtRepaymentPlan plan,
  ) async {
    final bool confirmed = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            title: const Text('Delete repayment plan?'),
            content: const Text(
              'Only the planning schedule will be removed. The debt ledger, linked transactions, and repayment history stay unchanged.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Delete plan'),
              ),
            ],
          ),
        ) ??
        false;
    if (confirmed) {
      await ref.read(debtRepaymentPlanRepositoryProvider).deleteForDebt(plan.debtId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(debtRepaymentPlanProvider(account.id)).when(
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'Loading repayment plan',
                ),
              ),
            ),
          ),
          error: (Object error, StackTrace stackTrace) => Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Repayment plan could not be loaded.',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => ref.invalidate(
                      debtRepaymentPlanProvider(account.id),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (DebtRepaymentPlan? plan) {
            if (plan == null) {
              return Card(
                color: AppPalette.sky,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'EMI & repayment plan',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Estimate upcoming installments and payoff timing without creating transactions automatically.',
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => _openEditor(context, ref),
                        icon: const Icon(Icons.calculate_rounded),
                        label: const Text('Set up plan'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final RepaymentProjection projection = ref
                .read(repaymentScheduleServiceProvider)
                .project(
                  plan: plan,
                  currentOutstanding: account.outstanding,
                  totalRepaid: account.repaidBalance,
                );
            final String healthLabel = plan.isPaused
                ? 'Paused'
                : switch (projection.health) {
                    RepaymentHealth.onTrack => 'On track',
                    RepaymentHealth.dueToday => 'Due today',
                    RepaymentHealth.overdue => 'Behind plan',
                    RepaymentHealth.settled => 'Settled',
                    RepaymentHealth.paymentTooLow => 'Payment too low',
                  };
            final Color healthColor = plan.isPaused
                ? AppPalette.lilac
                : switch (projection.health) {
                    RepaymentHealth.overdue || RepaymentHealth.paymentTooLow =>
                      AppPalette.peach,
                    RepaymentHealth.settled => AppPalette.mint,
                    _ => AppPalette.sky,
                  };

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        const Expanded(
                          child: Text(
                            'EMI & repayment plan',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: healthColor,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            healthLabel,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${plan.cadence.label} • ${_amount(plan.installmentAmount)}${plan.annualInterestRatePct > 0 ? ' • ${plan.annualInterestRatePct.toStringAsFixed(2)}% APR' : ''}',
                    ),
                    if (!plan.isPaused && projection.nextDueDate != null) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        '${projection.health == RepaymentHealth.overdue ? 'Earliest unpaid due' : 'Next due'} ${_dateFormat.format(projection.nextDueDate!)}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                    if (!plan.isPaused &&
                        projection.health == RepaymentHealth.overdue &&
                        projection.overdueAmount > 0.01) ...<Widget>[
                      const SizedBox(height: 6),
                      Text(
                        'Behind plan by ${_amount(projection.overdueAmount)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                    if (!plan.isPaused &&
                        projection.health == RepaymentHealth.dueToday &&
                        projection.overdueAmount > 0.01) ...<Widget>[
                      const SizedBox(height: 6),
                      Text(
                        'Scheduled due today ${_amount(projection.overdueAmount)}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                    if (!plan.isPaused &&
                        projection.estimatedPayoffDate != null) ...<Widget>[
                      const SizedBox(height: 6),
                      Text(
                        'Estimated payoff ${_dateFormat.format(projection.estimatedPayoffDate!)} • ${projection.estimatedRemainingPayments} payments left',
                      ),
                    ],
                    if (!plan.isPaused &&
                        projection.estimatedRemainingInterest != null &&
                        plan.annualInterestRatePct > 0) ...<Widget>[
                      const SizedBox(height: 6),
                      Text(
                        'Projected remaining interest ${_amount(projection.estimatedRemainingInterest!)}',
                      ),
                    ],
                    if (!plan.isPaused &&
                        projection.health == RepaymentHealth.paymentTooLow) ...<Widget>[
                      const SizedBox(height: 8),
                      const Text(
                        'The planned installment does not cover one period of projected interest. Increase the payment or revise the APR.',
                      ),
                    ],
                    if (!plan.isPaused && projection.installments.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 14),
                      const Divider(),
                      const SizedBox(height: 6),
                      const Text(
                        'Next projected installments',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 8),
                      ...projection.installments.take(3).map(
                        (RepaymentInstallment item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(_dateFormat.format(item.dueDate)),
                              ),
                              Text(
                                _amount(item.payment),
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    const Text(
                      'Projection only. Record or link the real repayment separately after it happens.',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        OutlinedButton.icon(
                          onPressed: () => _openEditor(context, ref, plan: plan),
                          icon: const Icon(Icons.edit_rounded),
                          label: const Text('Edit plan'),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => ref
                              .read(debtRepaymentPlanRepositoryProvider)
                              .setPaused(account.id, !plan.isPaused),
                          icon: Icon(
                            plan.isPaused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                          ),
                          label: Text(plan.isPaused ? 'Resume' : 'Pause'),
                        ),
                        TextButton.icon(
                          onPressed: () => _delete(context, ref, plan),
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: const Text('Delete plan'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
  }
}
