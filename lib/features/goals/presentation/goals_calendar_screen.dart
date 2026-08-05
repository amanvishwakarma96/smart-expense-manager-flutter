import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/goals/domain/savings_goal.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

enum _GoalsMode { goals, calendar }

class GoalsCalendarScreen extends ConsumerStatefulWidget {
  const GoalsCalendarScreen({super.key});

  @override
  ConsumerState<GoalsCalendarScreen> createState() =>
      _GoalsCalendarScreenState();
}

class _GoalsCalendarScreenState extends ConsumerState<GoalsCalendarScreen> {
  static final DateFormat _goalDateFormat = DateFormat('d MMM yyyy');

  _GoalsMode _mode = _GoalsMode.goals;
  DateTime _calendarMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  Future<void> _editGoal([SavingsGoal? goal]) async {
    final TextEditingController nameController = TextEditingController(
      text: goal?.name ?? '',
    );
    final TextEditingController targetController = TextEditingController(
      text: goal == null ? '' : goal.targetAmount.toStringAsFixed(0),
    );
    final TextEditingController savedController = TextEditingController(
      text: goal == null ? '0' : goal.savedAmount.toStringAsFixed(0),
    );
    DateTime? targetDate = goal?.targetDate;
    String color = goal?.hexColor ?? 'CBB8FF';
    String iconName = goal?.iconName ?? 'savings';
    String? errorText;

    final _GoalDraft? draft = await showModalBottomSheet<_GoalDraft>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext sheetContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            Future<void> pickDate() async {
              final DateTime now = DateTime.now();
              final DateTime? picked = await showDatePicker(
                context: sheetContext,
                initialDate: targetDate ?? now.add(const Duration(days: 90)),
                firstDate: DateTime(now.year, now.month, now.day),
                lastDate: DateTime(now.year + 20),
              );
              if (picked != null && sheetContext.mounted) {
                setSheetState(() => targetDate = picked);
              }
            }

            void submit() {
              final String name = nameController.text.trim();
              final double? target = double.tryParse(
                targetController.text.trim(),
              );
              final double? saved = double.tryParse(
                savedController.text.trim(),
              );
              if (name.isEmpty ||
                  target == null ||
                  target <= 0 ||
                  saved == null ||
                  saved < 0) {
                setSheetState(() {
                  errorText =
                      'Enter a name, a target above zero, and valid savings.';
                });
                return;
              }
              Navigator.of(sheetContext).pop(
                _GoalDraft(
                  name: name,
                  targetAmount: target,
                  savedAmount: saved,
                  targetDate: targetDate,
                  hexColor: color,
                  iconName: iconName,
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                24 + MediaQuery.viewInsetsOf(sheetContext).bottom,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      goal == null ? 'Create a happy goal ✨' : 'Tune your goal',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Goal names are encrypted before they are stored.',
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: nameController,
                      autofocus: goal == null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Goal name',
                        hintText: 'Dream trip, emergency fund…',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: targetController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Target',
                              prefixText: '₹ ',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: savedController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Already saved',
                              prefixText: '₹ ',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: pickDate,
                      icon: const Icon(Icons.event_rounded),
                      label: Text(
                        targetDate == null
                            ? 'Add an optional target date'
                            : 'Target ${_goalDateFormat.format(targetDate!)}',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Pick a mood',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _goalColors.map((String value) {
                        final bool selected = color == value;
                        return InkWell(
                          onTap: () => setSheetState(() => color = value),
                          borderRadius: BorderRadius.circular(99),
                          child: AnimatedContainer(
                            duration: 180.ms,
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: colorFromHex(value),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected
                                    ? AppPalette.ink
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: selected
                                ? const Icon(Icons.check_rounded, size: 20)
                                : null,
                          ),
                        );
                      }).toList(growable: false),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Choose an icon',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: _goalIcons.map((String value) {
                        return ChoiceChip(
                          selected: iconName == value,
                          onSelected: (_) {
                            setSheetState(() => iconName = value);
                          },
                          avatar: Icon(_goalIcon(value), size: 18),
                          label: Text(_goalIconLabel(value)),
                        );
                      }).toList(growable: false),
                    ),
                    if (errorText != null) ...<Widget>[
                      const SizedBox(height: 12),
                      Text(
                        errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: submit,
                        icon: const Icon(Icons.auto_awesome_rounded),
                        label: Text(goal == null ? 'Create goal' : 'Save goal'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    nameController.dispose();
    targetController.dispose();
    savedController.dispose();

    if (draft == null) {
      return;
    }
    await ref.read(savingsGoalRepositoryProvider).save(
          id: goal?.id,
          name: draft.name,
          targetAmount: draft.targetAmount,
          savedAmount: draft.savedAmount,
          targetDate: draft.targetDate,
          hexColor: draft.hexColor,
          iconName: draft.iconName,
        );
    if (mounted) {
      _message(goal == null ? 'Your new goal is ready 🌱' : 'Goal updated');
    }
  }

  Future<void> _addContribution(SavingsGoal goal) async {
    final TextEditingController controller = TextEditingController();
    final double? amount = await showDialog<double>(
      context: context,
      builder: (BuildContext dialogContext) {
        String? errorText;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            void submit() {
              final double? value = double.tryParse(controller.text.trim());
              if (value == null || value <= 0) {
                setDialogState(() => errorText = 'Enter an amount above zero.');
                return;
              }
              Navigator.of(dialogContext).pop(value);
            }

            return AlertDialog(
              title: Text('Add to ${goal.name}'),
              content: TextField(
                controller: controller,
                autofocus: true,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onSubmitted: (_) => submit(),
                decoration: InputDecoration(
                  labelText: 'Contribution',
                  prefixText: '₹ ',
                  errorText: errorText,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: submit,
                  child: const Text('Add savings'),
                ),
              ],
            );
          },
        );
      },
    );
    controller.dispose();
    if (amount == null) {
      return;
    }
    await ref.read(savingsGoalRepositoryProvider).addContribution(
          goal.id,
          amount,
        );
    if (mounted) {
      _message(
        goal.progress < 1
            ? 'Nice! Your goal just moved forward ⭐'
            : 'Goal complete—amazing work! 🎉',
      );
    }
  }

  Future<void> _archiveGoal(SavingsGoal goal) async {
    final bool archive = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Archive this goal?'),
              content: Text(
                '${goal.name} will leave the active list but remain in your '
                'encrypted local database and backups.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Archive'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (!archive) {
      return;
    }
    await ref.read(savingsGoalRepositoryProvider).setArchived(goal.id, true);
    if (mounted) {
      _message('Goal archived on this device.');
    }
  }

  Future<void> _deleteGoal(SavingsGoal goal) async {
    final bool remove = await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Delete this goal permanently?'),
              content: Text(
                '${goal.name} and its saved progress will be removed from this '
                'device. This cannot be undone.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (!remove) {
      return;
    }
    await ref.read(savingsGoalRepositoryProvider).delete(goal.id);
    if (mounted) {
      _message('Goal deleted locally.');
    }
  }

  void _previousMonth() {
    setState(() {
      _calendarMonth = DateTime(
        _calendarMonth.year,
        _calendarMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    final DateTime next = DateTime(
      _calendarMonth.year,
      _calendarMonth.month + 1,
    );
    final DateTime current = DateTime(DateTime.now().year, DateTime.now().month);
    if (!next.isAfter(current)) {
      setState(() => _calendarMonth = next);
    }
  }

  void _showDayTransactions(
    DateTime date,
    List<ExpenseTransaction> transactions,
    bool privacyMode,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                DateFormat('EEEE, d MMMM').format(date),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 14),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: transactions.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (BuildContext context, int index) {
                    final ExpenseTransaction item = transactions[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: item.isDebit
                            ? AppPalette.peach
                            : AppPalette.mint,
                        child: Icon(
                          item.isDebit
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                        ),
                      ),
                      title: Text(item.merchant),
                      subtitle: Text(
                        item.isRecurring ? 'Recurring • reviewed' : 'Confirmed',
                      ),
                      trailing: Text(
                        privacyMode
                            ? '₹ •••'
                            : '${item.isDebit ? '-' : '+'}${inrCurrency.format(item.amount)}',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool privacyMode = ref.watch(privacyModeProvider);
    final AsyncValue<List<SavingsGoal>> goals = ref.watch(savingsGoalsProvider);
    final AsyncValue<List<ExpenseTransaction>> transactions = ref.watch(
      confirmedTransactionsProvider,
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
        children: <Widget>[
          _GoalsHero(
            mode: _mode,
            onModeChanged: (_GoalsMode value) => setState(() => _mode = value),
          ),
          const SizedBox(height: 18),
          if (_mode == _GoalsMode.goals)
            goals.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object error, StackTrace stackTrace) => const _ErrorCard(
                title: 'Goals are resting',
                message: 'Restart PiggyAI and try opening your local goals again.',
              ),
              data: (List<SavingsGoal> items) => _GoalsView(
                goals: items,
                privacyMode: privacyMode,
                onCreate: () => _editGoal(),
                onEdit: _editGoal,
                onContribute: _addContribution,
                onArchive: _archiveGoal,
                onDelete: _deleteGoal,
              ),
            )
          else
            transactions.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object error, StackTrace stackTrace) => const _ErrorCard(
                title: 'Calendar is unavailable',
                message: 'Your transactions remain safely stored on-device.',
              ),
              data: (List<ExpenseTransaction> items) => _CashFlowCalendar(
                month: _calendarMonth,
                transactions: items,
                privacyMode: privacyMode,
                onPreviousMonth: _previousMonth,
                onNextMonth: _nextMonth,
                onDayTap: (DateTime date, List<ExpenseTransaction> dayItems) {
                  _showDayTransactions(date, dayItems, privacyMode);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _GoalsHero extends StatelessWidget {
  const _GoalsHero({required this.mode, required this.onModeChanged});

  final _GoalsMode mode;
  final ValueChanged<_GoalsMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppPalette.heroGradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.savings_rounded, size: 30),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Dreams & daily flow',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Save with tiny wins and understand every day at a glance.',
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SegmentedButton<_GoalsMode>(
            segments: const <ButtonSegment<_GoalsMode>>[
              ButtonSegment<_GoalsMode>(
                value: _GoalsMode.goals,
                icon: Icon(Icons.flag_rounded),
                label: Text('Goals'),
              ),
              ButtonSegment<_GoalsMode>(
                value: _GoalsMode.calendar,
                icon: Icon(Icons.calendar_month_rounded),
                label: Text('Calendar'),
              ),
            ],
            selected: <_GoalsMode>{mode},
            onSelectionChanged: (Set<_GoalsMode> selected) {
              onModeChanged(selected.first);
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color?>((states) {
                return states.contains(WidgetState.selected)
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.34);
              }),
              side: const WidgetStatePropertyAll<BorderSide>(BorderSide.none),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.05, end: 0);
  }
}

class _GoalsView extends StatelessWidget {
  const _GoalsView({
    required this.goals,
    required this.privacyMode,
    required this.onCreate,
    required this.onEdit,
    required this.onContribute,
    required this.onArchive,
    required this.onDelete,
  });

  final List<SavingsGoal> goals;
  final bool privacyMode;
  final VoidCallback onCreate;
  final ValueChanged<SavingsGoal> onEdit;
  final ValueChanged<SavingsGoal> onContribute;
  final ValueChanged<SavingsGoal> onArchive;
  final ValueChanged<SavingsGoal> onDelete;

  @override
  Widget build(BuildContext context) {
    if (goals.isEmpty) {
      return _PlayfulEmptyGoals(onCreate: onCreate);
    }

    final double totalSaved = goals.fold(
      0,
      (double value, SavingsGoal item) => value + item.savedAmount,
    );
    final double totalTarget = goals.fold(
      0,
      (double value, SavingsGoal item) => value + item.targetAmount,
    );
    final int stars = goals.fold(
      0,
      (int value, SavingsGoal item) => value + item.earnedMilestones,
    );
    final int completed = goals.where((SavingsGoal item) => item.isComplete).length;

    return Column(
      children: <Widget>[
        _RewardSummary(
          totalSaved: totalSaved,
          totalTarget: totalTarget,
          stars: stars,
          completed: completed,
          privacyMode: privacyMode,
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create another goal'),
          ),
        ),
        const SizedBox(height: 14),
        ...goals.indexed.map((entry) {
          final int index = entry.$1;
          final SavingsGoal goal = entry.$2;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _GoalCard(
              goal: goal,
              privacyMode: privacyMode,
              onEdit: () => onEdit(goal),
              onContribute: () => onContribute(goal),
              onArchive: () => onArchive(goal),
              onDelete: () => onDelete(goal),
            )
                .animate()
                .fadeIn(delay: (80 * index).ms)
                .slideY(begin: 0.04, end: 0),
          );
        }),
      ],
    );
  }
}

class _RewardSummary extends StatelessWidget {
  const _RewardSummary({
    required this.totalSaved,
    required this.totalTarget,
    required this.stars,
    required this.completed,
    required this.privacyMode,
  });

  final double totalSaved;
  final double totalTarget;
  final int stars;
  final int completed;
  final bool privacyMode;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Your pocket constellation',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$stars milestone star${stars == 1 ? '' : 's'} earned',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppPalette.lemon,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.star_rounded),
                      const SizedBox(width: 5),
                      Text(
                        stars.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            LinearProgressIndicator(
              value: totalTarget <= 0
                  ? 0
                  : math.min(totalSaved / totalTarget, 1),
              minHeight: 12,
              borderRadius: BorderRadius.circular(99),
            ),
            const SizedBox(height: 8),
            Text(
              privacyMode
                  ? '₹ ••••• saved across your active goals'
                  : '${inrCurrency.format(totalSaved)} of ${inrCurrency.format(totalTarget)} saved',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            if (completed > 0) ...<Widget>[
              const SizedBox(height: 8),
              Text('🎉 $completed completed goal${completed == 1 ? '' : 's'}'),
            ],
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.privacyMode,
    required this.onEdit,
    required this.onContribute,
    required this.onArchive,
    required this.onDelete,
  });

  final SavingsGoal goal;
  final bool privacyMode;
  final VoidCallback onEdit;
  final VoidCallback onContribute;
  final VoidCallback onArchive;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final Color color = colorFromHex(goal.hexColor);
    final DateTime? targetDate = goal.targetDate;
    final int daysLeft = targetDate == null
        ? 0
        : targetDate.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            color.withValues(alpha: 0.92),
            color.withValues(alpha: 0.48),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: 0.72)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white.withValues(alpha: 0.78),
                child: Icon(_goalIcon(goal.iconName), size: 27),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      goal.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    if (goal.isComplete)
                      const Text(
                        'Goal complete! You did it 🎊',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      )
                    else if (targetDate != null)
                      Text(
                        daysLeft >= 0
                            ? '$daysLeft day${daysLeft == 1 ? '' : 's'} remaining'
                            : 'Target date passed—keep going gently',
                      )
                    else
                      const Text('No deadline, just steady progress'),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (String value) {
                  switch (value) {
                    case 'edit':
                      onEdit();
                    case 'archive':
                      onArchive();
                    case 'delete':
                      onDelete();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return const <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text('Edit goal'),
                    ),
                    PopupMenuItem<String>(
                      value: 'archive',
                      child: Text('Archive goal'),
                    ),
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text('Delete permanently'),
                    ),
                  ];
                },
              ),
            ],
          ),
          const SizedBox(height: 17),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 14,
              backgroundColor: Colors.white.withValues(alpha: 0.72),
              color: AppPalette.lavenderDeep,
            ),
          ),
          const SizedBox(height: 9),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  privacyMode
                      ? '₹ ••••• saved'
                      : '${inrCurrency.format(goal.savedAmount)} saved',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                privacyMode
                    ? '₹ ••••• target'
                    : '${inrCurrency.format(goal.remaining)} left',
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: List<Widget>.generate(5, (int index) {
              final bool earned = index < goal.earnedMilestones;
              return Padding(
                padding: const EdgeInsets.only(right: 7),
                child: AnimatedContainer(
                  duration: 220.ms,
                  width: 31,
                  height: 31,
                  decoration: BoxDecoration(
                    color: earned
                        ? AppPalette.sunshine
                        : Colors.white.withValues(alpha: 0.58),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    earned ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 20,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: goal.isComplete ? null : onContribute,
              icon: Icon(
                goal.isComplete
                    ? Icons.emoji_events_rounded
                    : Icons.add_rounded,
              ),
              label: Text(
                goal.isComplete ? 'Goal achieved' : 'Add savings',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayfulEmptyGoals extends StatelessWidget {
  const _PlayfulEmptyGoals({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          children: <Widget>[
            Container(
              width: 108,
              height: 108,
              decoration: const BoxDecoration(
                gradient: AppPalette.heroGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.rocket_launch_rounded, size: 52),
            ).animate(onPlay: (AnimationController controller) {
              controller.repeat(reverse: true);
            }).scale(
              duration: 1200.ms,
              begin: const Offset(0.96, 0.96),
              end: const Offset(1.04, 1.04),
            ),
            const SizedBox(height: 18),
            Text(
              'Give your money a tiny mission',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a private savings goal and celebrate every small step. '
              'Everything stays on this device.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('Create my first goal'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CashFlowCalendar extends StatelessWidget {
  const _CashFlowCalendar({
    required this.month,
    required this.transactions,
    required this.privacyMode,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onDayTap,
  });

  final DateTime month;
  final List<ExpenseTransaction> transactions;
  final bool privacyMode;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final void Function(DateTime, List<ExpenseTransaction>) onDayTap;

  @override
  Widget build(BuildContext context) {
    final List<ExpenseTransaction> monthItems = transactions
        .where((ExpenseTransaction item) {
          return item.timestamp.year == month.year &&
              item.timestamp.month == month.month;
        })
        .toList(growable: false);
    final double spent = monthItems
        .where((ExpenseTransaction item) => item.isDebit)
        .fold(0, (double value, ExpenseTransaction item) => value + item.amount);
    final double income = monthItems
        .where((ExpenseTransaction item) => !item.isDebit)
        .fold(0, (double value, ExpenseTransaction item) => value + item.amount);
    final DateTime currentMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month,
    );
    final bool canMoveForward = month.isBefore(currentMonth);

    return Column(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton.filledTonal(
                      onPressed: onPreviousMonth,
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    Expanded(
                      child: Text(
                        monthYearFormat.format(month),
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: canMoveForward ? onNextMonth : null,
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _CalendarMetric(
                        label: 'Income',
                        value: privacyMode
                            ? '₹ •••'
                            : inrCurrency.format(income),
                        color: AppPalette.mint,
                        icon: Icons.south_west_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CalendarMetric(
                        label: 'Spent',
                        value: privacyMode
                            ? '₹ •••'
                            : inrCurrency.format(spent),
                        color: AppPalette.peach,
                        icon: Icons.north_east_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _CalendarMetric(
                        label: 'Net',
                        value: privacyMode
                            ? '₹ •••'
                            : inrCurrency.format(income - spent),
                        color: AppPalette.lavender,
                        icon: Icons.balance_rounded,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    _WeekdayLabel('Mon'),
                    _WeekdayLabel('Tue'),
                    _WeekdayLabel('Wed'),
                    _WeekdayLabel('Thu'),
                    _WeekdayLabel('Fri'),
                    _WeekdayLabel('Sat'),
                    _WeekdayLabel('Sun'),
                  ],
                ),
                const SizedBox(height: 8),
                _CalendarGrid(
                  month: month,
                  transactions: monthItems,
                  privacyMode: privacyMode,
                  onDayTap: onDayTap,
                ),
              ],
            ),
          ),
        ),
        if (monthItems.isEmpty) ...<Widget>[
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppPalette.lemon,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              children: <Widget>[
                Icon(Icons.calendar_today_rounded, size: 36),
                SizedBox(height: 8),
                Text(
                  'A quiet month so far 🌤️',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                ),
                SizedBox(height: 4),
                Text(
                  'Confirmed transactions will paint this calendar with local '
                  'income and spending signals.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _CalendarMetric extends StatelessWidget {
  const _CalendarMetric({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, size: 20),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          FittedBox(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.month,
    required this.transactions,
    required this.privacyMode,
    required this.onDayTap,
  });

  final DateTime month;
  final List<ExpenseTransaction> transactions;
  final bool privacyMode;
  final void Function(DateTime, List<ExpenseTransaction>) onDayTap;

  @override
  Widget build(BuildContext context) {
    final DateTime firstDay = DateTime(month.year, month.month);
    final int leadingCells = firstDay.weekday - 1;
    final int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final int usedCells = leadingCells + daysInMonth;
    final int cellCount = ((usedCells / 7).ceil()) * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cellCount,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 0.78,
      ),
      itemBuilder: (BuildContext context, int index) {
        final int day = index - leadingCells + 1;
        if (day < 1 || day > daysInMonth) {
          return const SizedBox.shrink();
        }
        final DateTime date = DateTime(month.year, month.month, day);
        final List<ExpenseTransaction> dayItems = transactions
            .where((ExpenseTransaction item) {
              return item.timestamp.year == date.year &&
                  item.timestamp.month == date.month &&
                  item.timestamp.day == date.day;
            })
            .toList(growable: false);
        final double debit = dayItems
            .where((ExpenseTransaction item) => item.isDebit)
            .fold(
              0,
              (double value, ExpenseTransaction item) => value + item.amount,
            );
        final double credit = dayItems
            .where((ExpenseTransaction item) => !item.isDebit)
            .fold(
              0,
              (double value, ExpenseTransaction item) => value + item.amount,
            );
        final bool today = _sameDate(date, DateTime.now());
        final Color background = debit > 0 && credit > 0
            ? AppPalette.lavender
            : debit > 0
            ? AppPalette.peach
            : credit > 0
            ? AppPalette.mint
            : AppPalette.canvas;

        return InkWell(
          onTap: dayItems.isEmpty ? null : () => onDayTap(date, dayItems),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: today ? AppPalette.lavenderDeep : Colors.transparent,
                width: today ? 2 : 1,
              ),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  day.toString(),
                  style: TextStyle(
                    fontWeight: today ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
                const Spacer(),
                if (dayItems.isNotEmpty) ...<Widget>[
                  Icon(
                    debit > credit
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 13,
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    child: Text(
                      privacyMode
                          ? '•••'
                          : _compactAmount(math.max(debit, credit)),
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  static bool _sameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String _compactAmount(double value) {
    if (value >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(1)}L';
    }
    if (value >= 1000) {
      return '₹${(value / 1000).toStringAsFixed(1)}K';
    }
    return '₹${value.toStringAsFixed(0)}';
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            const Icon(Icons.cloud_off_rounded, size: 48),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _GoalDraft {
  const _GoalDraft({
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.hexColor,
    required this.iconName,
    this.targetDate,
  });

  final String name;
  final double targetAmount;
  final double savedAmount;
  final DateTime? targetDate;
  final String hexColor;
  final String iconName;
}

const List<String> _goalColors = <String>[
  'CBB8FF',
  '9FD8CB',
  'FFB7A1',
  'A8D8FF',
  'FFCAD4',
  'FFD98E',
];

const List<String> _goalIcons = <String>[
  'savings',
  'flight',
  'home',
  'car',
  'school',
];

IconData _goalIcon(String name) {
  return switch (name) {
    'flight' => Icons.flight_takeoff_rounded,
    'home' => Icons.home_rounded,
    'car' => Icons.directions_car_rounded,
    'school' => Icons.school_rounded,
    _ => Icons.savings_rounded,
  };
}

String _goalIconLabel(String name) {
  return switch (name) {
    'flight' => 'Trip',
    'home' => 'Home',
    'car' => 'Car',
    'school' => 'Learn',
    _ => 'Save',
  };
}
