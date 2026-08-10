import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/challenges/domain/weekly_challenge.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class WeeklyMoneyChallengeCard extends ConsumerWidget {
  const WeeklyMoneyChallengeCard({super.key});

  Future<void> _openEditor(BuildContext context, {WeeklyChallenge? challenge}) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) =>
          _ChallengeEditorSheet(challenge: challenge),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<WeeklyChallenge> challenges =
        ref.watch(weeklyChallengesProvider).value ?? const <WeeklyChallenge>[];
    final List<ExpenseTransaction> transactions =
        ref.watch(confirmedTransactionsProvider).value ??
        const <ExpenseTransaction>[];
    final bool privacyMode = ref.watch(privacyModeProvider);
    final DateTime currentWeek = startOfChallengeWeek(DateTime.now());
    WeeklyChallenge? current;
    for (final WeeklyChallenge challenge in challenges) {
      if (challenge.weekStart == currentWeek && challenge.isActive) {
        current = challenge;
        break;
      }
    }
    final ChallengeRewardSummary rewards = summarizeChallengeRewards(
      challenges,
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: const BoxDecoration(gradient: AppPalette.heroGradient),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.66),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: const Icon(Icons.emoji_events_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Weekly money quest',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        rewards.currentStreak == 0
                            ? 'Tiny wins make strong money habits.'
                            : '🔥 ${rewards.currentStreak} week streak — keep it gentle!',
                      ),
                    ],
                  ),
                ),
                if (current != null)
                  IconButton.filledTonal(
                    tooltip: 'Edit this week’s challenge',
                    onPressed: () => _openEditor(context, challenge: current),
                    icon: const Icon(Icons.tune_rounded),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (current == null)
              _EmptyChallenge(onCreate: () => _openEditor(context))
            else
              _ActiveChallenge(
                challenge: current,
                transactions: transactions,
                privacyMode: privacyMode,
              ),
            const SizedBox(height: 16),
            Text(
              'Reward shelf',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _RewardBadge(
                  icon: Icons.auto_awesome_rounded,
                  label: 'First win',
                  unlocked: rewards.firstWinUnlocked,
                ),
                _RewardBadge(
                  icon: Icons.local_fire_department_rounded,
                  label: '3-week streak',
                  unlocked: rewards.threeWeekStreakUnlocked,
                ),
                _RewardBadge(
                  icon: Icons.star_rounded,
                  label: '5 wins',
                  unlocked: rewards.fiveWinsUnlocked,
                ),
                _RewardBadge(
                  icon: Icons.workspace_premium_rounded,
                  label: '10 wins',
                  unlocked: rewards.tenWinsUnlocked,
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.04, end: 0);
  }
}

class _EmptyChallenge extends StatelessWidget {
  const _EmptyChallenge({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.60),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Choose one mini mission for this week.',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 5),
          const Text(
            'Try a spending cap or collect no-spend days. Missing a week never changes your budgets or records.',
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.rocket_launch_rounded),
            label: const Text('Pick my challenge'),
          ),
        ],
      ),
    );
  }
}

class _ActiveChallenge extends ConsumerWidget {
  const _ActiveChallenge({
    required this.challenge,
    required this.transactions,
    required this.privacyMode,
  });

  final WeeklyChallenge challenge;
  final List<ExpenseTransaction> transactions;
  final bool privacyMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WeeklyChallengeProgress progress = evaluateWeeklyChallenge(
      challenge: challenge,
      transactions: transactions,
    );
    final bool spendingCap = challenge.type == WeeklyChallengeType.spendingCap;
    final String headline = spendingCap
        ? 'Stay under ${_money(challenge.targetAmount)} this week'
        : 'Collect ${challenge.targetDays} no-spend day${challenge.targetDays == 1 ? '' : 's'}';
    final String detail = spendingCap
        ? '${_money(progress.spent)} used so far'
        : '${progress.noSpendDays} collected across ${progress.elapsedDays} day${progress.elapsedDays == 1 ? '' : 's'}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.64),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                progress.onTrack
                    ? Icons.sentiment_very_satisfied_rounded
                    : Icons.sentiment_neutral_rounded,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  headline,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progress.progress,
            minHeight: 11,
            borderRadius: BorderRadius.circular(20),
          ),
          const SizedBox(height: 8),
          Text(detail),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  progress.onTrack
                      ? 'Nice pace. Keep choosing what matters.'
                      : 'No penalty. Adjust the plan and keep learning.',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await ref
                      .read(weeklyChallengeRepositoryProvider)
                      .deleteCurrent();
                },
                child: const Text('Skip week'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _money(double value) {
    return privacyMode
        ? '$defaultCurrencySymbol •••••'
        : inrCurrency.format(value);
  }
}

class _RewardBadge extends StatelessWidget {
  const _RewardBadge({
    required this.icon,
    required this.label,
    required this.unlocked,
  });

  final IconData icon;
  final String label;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: unlocked ? 1 : 0.42,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: unlocked ? 0.72 : 0.42),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(unlocked ? icon : Icons.lock_outline_rounded, size: 18),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _ChallengeEditorSheet extends ConsumerStatefulWidget {
  const _ChallengeEditorSheet({this.challenge});

  final WeeklyChallenge? challenge;

  @override
  ConsumerState<_ChallengeEditorSheet> createState() =>
      _ChallengeEditorSheetState();
}

class _ChallengeEditorSheetState extends ConsumerState<_ChallengeEditorSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late WeeklyChallengeType _type;
  late int _targetDays;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _type = widget.challenge?.type ?? WeeklyChallengeType.spendingCap;
    final int existingTargetDays = widget.challenge?.targetDays ?? 0;
    _targetDays = existingTargetDays <= 0 ? 2 : existingTargetDays;
    _amountController = TextEditingController(
      text: (widget.challenge?.targetAmount ?? 0) > 0
          ? widget.challenge!.targetAmount.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _saving = true);
    await ref
        .read(weeklyChallengeRepositoryProvider)
        .saveCurrent(
          type: _type,
          targetAmount: double.tryParse(_amountController.text.trim()) ?? 0,
          targetDays: _targetDays,
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Pick a tiny weekly quest ✨',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              const Text(
                'This is motivational only. It never blocks spending or changes your financial records.',
              ),
              const SizedBox(height: 18),
              SegmentedButton<WeeklyChallengeType>(
                segments: const <ButtonSegment<WeeklyChallengeType>>[
                  ButtonSegment<WeeklyChallengeType>(
                    value: WeeklyChallengeType.spendingCap,
                    icon: Icon(Icons.savings_rounded),
                    label: Text('Spend cap'),
                  ),
                  ButtonSegment<WeeklyChallengeType>(
                    value: WeeklyChallengeType.noSpendDays,
                    icon: Icon(Icons.self_improvement_rounded),
                    label: Text('No-spend days'),
                  ),
                ],
                selected: <WeeklyChallengeType>{_type},
                onSelectionChanged: (Set<WeeklyChallengeType> selected) {
                  setState(() => _type = selected.first);
                },
              ),
              const SizedBox(height: 14),
              if (_type == WeeklyChallengeType.spendingCap)
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Weekly spending cap',
                    prefixText: '$defaultCurrencySymbol ',
                    prefixIcon: Icon(Icons.currency_rupee_rounded),
                  ),
                  validator: (String? value) {
                    final double? amount = double.tryParse(value?.trim() ?? '');
                    return amount == null || amount <= 0
                        ? 'Enter a weekly amount greater than zero'
                        : null;
                  },
                )
              else
                DropdownButtonFormField<int>(
                  initialValue: _targetDays,
                  decoration: const InputDecoration(
                    labelText: 'No-spend days to collect',
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                  ),
                  items: List<DropdownMenuItem<int>>.generate(
                    7,
                    (int index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text('${index + 1} day${index == 0 ? '' : 's'}'),
                    ),
                  ),
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() => _targetDays = value);
                    }
                  },
                ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.flag_rounded),
                label: const Text('Start this week’s quest'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
