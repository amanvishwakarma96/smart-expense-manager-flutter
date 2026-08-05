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
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  Future<void> _openGoalEditor([SavingsGoal? goal]) async {
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
    String hexColor = goal?.hexColor ?? _goalColors.first;
    String iconName = goal?.iconName ?? _goalIcons.first;
    String? errorText;

    final _GoalDraft? draft = await showDialog<_GoalDraft>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            Future<void> pickDate() async {
              final DateTime now = DateTime.now();
              final DateTime? picked = await showDatePicker(
                context: dialogContext,
                initialDate: targetDate ?? now.add(const Duration(days: 90)),
                firstDate: DateTime(now.year, now.month, now.day),
                lastDate: DateTime(now.year + 20),
              );
              if (picked != null && dialogContext.mounted) {
                setDialogState(() => targetDate = picked);
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
                setDialogState(() {
                  errorText =
                      'Enter a name, a target above zero, and valid savings.';
                });
                return;
              }
              Navigator.of(dialogContext).pop(
                _GoalDraft(
                  name: name,
                  targetAmount: target,
                  savedAmount: saved,
                  targetDate: targetDate,
                  hexColor: hexColor,
                  iconName: iconName,
                ),
              );
            }

            return AlertDialog(
              title: Text(goal == null ? 'Create a happy goal ✨' : 'Edit goal'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Goal names are encrypted before storage.'),
                    const SizedBox(height: 14),
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
                    TextField(
                      controller: targetController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Target amount',
                        prefixText: '₹ ',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: savedController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Already saved',
                        prefixText: '₹ ',
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: pickDate,
                      icon: const Icon(Icons.event_rounded),
                      label: Text(
                        targetDate == null
                            ? 'Optional target date'
                            : _goalDateFormat.format(targetDate!),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Colour',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 9,
                      children: _goalColors
                          .map((String value) {
                            final bool selected = value == hexColor;
                            return InkWell(
                              onTap: () =>
                                  setDialogState(() => hexColor = value),
                              borderRadius: BorderRadius.circular(99),
                              child: Container(
                                width: 38,
                                height: 38,
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
                                    ? const Icon(Icons.check_rounded, size: 18)
                                    : null,
                              ),
                            );
                          })
                          .toList(growable: false),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Icon',
                      style: TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 7,
                      children: _goalIcons
                          .map((String value) {
                            return ChoiceChip(
                              selected: iconName == value,
                              onSelected: (_) {
                                setDialogState(() => iconName = value);
                              },
                              avatar: Icon(_goalIcon(value), size: 17),
                              label: Text(_goalIconLabel(value)),
                            );
                          })
                          .toList(growable: false),
                    ),
                    if (errorText != null) ...<Widget>[
                      const SizedBox(height: 10),
                      Text(
                        errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: submit,
                  child: Text(goal == null ? 'Create' : 'Save'),
                ),
              ],
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
    await ref
        .read(savingsGoalRepositoryProvider)
        .save(
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
    await ref
        .read(savingsGoalRepositoryProvider)
        .addContribution(goal.id, amount);
    if (mounted) {
      _message('Nice! Your goal moved forward ⭐');
    }
  }

  Future<void> _archiveGoal(SavingsGoal goal) async {
    final bool confirmed = await _confirm(
      title: 'Archive this goal?',
      message:
          '${goal.name} will leave the active list but remain in encrypted backups.',
      action: 'Archive',
    );
    if (!confirmed) {
      return;
    }
    await ref.read(savingsGoalRepositoryProvider).setArchived(goal.id, true);
    if (mounted) {
      _message('Goal archived on this device.');
    }
  }

  Future<void> _deleteGoal(SavingsGoal goal) async {
    final bool confirmed = await _confirm(
      title: 'Delete this goal permanently?',
      message:
          '${goal.name} and its saved progress will be removed from this device.',
      action: 'Delete',
    );
    if (!confirmed) {
      return;
    }
    await ref.read(savingsGoalRepositoryProvider).delete(goal.id);
    if (mounted) {
      _message('Goal deleted locally.');
    }
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String action,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: Text(action),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  void _showDayTransactions(
    DateTime date,
    List<ExpenseTransaction> items,
    bool privacyMode,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: math.min(160 + items.length * 72, 520).toDouble(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat('EEEE, d MMMM').format(date),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (BuildContext context, int index) {
                      final ExpenseTransaction item = items[index];
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
                          item.isRecurring
                              ? 'Recurring • reviewed'
                              : 'Confirmed',
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
          ),
        );
      },
    );
  }

  void _message(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final bool privacyMode = ref.watch(privacyModeProvider);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
        children: <Widget>[
          _header(),
          const SizedBox(height: 18),
          if (_mode == _GoalsMode.goals)
            ref
                .watch(savingsGoalsProvider)
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (Object error, StackTrace stackTrace) =>
                      const _ErrorCard(
                        title: 'Goals are resting',
                        message: 'Restart PiggyAI and try opening them again.',
                      ),
                  data: (List<SavingsGoal> goals) {
                    return _goalsContent(goals, privacyMode);
                  },
                )
          else
            ref
                .watch(confirmedTransactionsProvider)
                .when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (Object error, StackTrace stackTrace) =>
                      const _ErrorCard(
                        title: 'Calendar is unavailable',
                        message: 'Your transactions remain stored on-device.',
                      ),
                  data: (List<ExpenseTransaction> items) {
                    return _calendarContent(items, privacyMode);
                  },
                ),
        ],
      ),
    );
  }

  Widget _header() {
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Dreams & daily flow',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text('Tiny savings wins and a colourful money calendar.'),
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
            selected: <_GoalsMode>{_mode},
            onSelectionChanged: (Set<_GoalsMode> value) {
              setState(() => _mode = value.first);
            },
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.05, end: 0);
  }

  Widget _goalsContent(List<SavingsGoal> goals, bool privacyMode) {
    if (goals.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(26),
          child: Column(
            children: <Widget>[
              Container(
                width: 104,
                height: 104,
                decoration: const BoxDecoration(
                  gradient: AppPalette.heroGradient,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.rocket_launch_rounded, size: 50),
              ),
              const SizedBox(height: 17),
              Text(
                'Give your money a tiny mission',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Create a private goal and celebrate every small step. '
                'Everything stays on this device.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _openGoalEditor,
                icon: const Icon(Icons.auto_awesome_rounded),
                label: const Text('Create my first goal'),
              ),
            ],
          ),
        ),
      );
    }

    final double totalSaved = goals.fold(
      0,
      (double sum, SavingsGoal item) => sum + item.savedAmount,
    );
    final double totalTarget = goals.fold(
      0,
      (double sum, SavingsGoal item) => sum + item.targetAmount,
    );
    final int stars = goals.fold(
      0,
      (int sum, SavingsGoal item) => sum + item.earnedMilestones,
    );
    final int completed = goals
        .where((SavingsGoal item) => item.isComplete)
        .length;

    return Column(
      children: <Widget>[
        Card(
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
                    Chip(
                      avatar: const Icon(Icons.star_rounded),
                      label: Text(stars.toString()),
                      backgroundColor: AppPalette.lemon,
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                LinearProgressIndicator(
                  value: totalTarget <= 0
                      ? 0
                      : math.min(totalSaved / totalTarget, 1.0),
                  minHeight: 12,
                  borderRadius: BorderRadius.circular(99),
                ),
                const SizedBox(height: 8),
                Text(
                  privacyMode
                      ? '₹ ••••• saved across active goals'
                      : '${inrCurrency.format(totalSaved)} of ${inrCurrency.format(totalTarget)} saved',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                if (completed > 0) ...<Widget>[
                  const SizedBox(height: 7),
                  Text(
                    '🎉 $completed completed goal${completed == 1 ? '' : 's'}',
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 13),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: _openGoalEditor,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Create another goal'),
          ),
        ),
        const SizedBox(height: 13),
        ...goals.indexed.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: _goalCard(entry.$2, privacyMode)
                .animate()
                .fadeIn(delay: (entry.$1 * 70).ms)
                .slideY(begin: 0.04, end: 0),
          );
        }),
      ],
    );
  }

  Widget _goalCard(SavingsGoal goal, bool privacyMode) {
    final Color color = colorFromHex(goal.hexColor);
    final int? daysLeft = goal.targetDate?.difference(DateTime.now()).inDays;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            color.withValues(alpha: 0.92),
            color.withValues(alpha: 0.50),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: color.withValues(alpha: 0.75)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white.withValues(alpha: 0.80),
                child: Icon(_goalIcon(goal.iconName), size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      goal.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      goal.isComplete
                          ? 'Goal complete! You did it 🎊'
                          : daysLeft == null
                          ? 'No deadline, just steady progress'
                          : daysLeft >= 0
                          ? '$daysLeft day${daysLeft == 1 ? '' : 's'} remaining'
                          : 'Target date passed—keep going gently',
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (String value) {
                  switch (value) {
                    case 'edit':
                      _openGoalEditor(goal);
                      break;
                    case 'archive':
                      _archiveGoal(goal);
                      break;
                    case 'delete':
                      _deleteGoal(goal);
                      break;
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
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: goal.progress,
            minHeight: 14,
            borderRadius: BorderRadius.circular(99),
            backgroundColor: Colors.white.withValues(alpha: 0.70),
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 11),
          Wrap(
            spacing: 6,
            children: List<Widget>.generate(5, (int index) {
              final bool earned = index < goal.earnedMilestones;
              return CircleAvatar(
                radius: 15,
                backgroundColor: earned
                    ? AppPalette.sunshine
                    : Colors.white.withValues(alpha: 0.58),
                child: Icon(
                  earned ? Icons.star_rounded : Icons.star_border_rounded,
                  size: 19,
                ),
              );
            }),
          ),
          const SizedBox(height: 13),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: goal.isComplete ? null : () => _addContribution(goal),
              icon: Icon(
                goal.isComplete
                    ? Icons.emoji_events_rounded
                    : Icons.add_rounded,
              ),
              label: Text(goal.isComplete ? 'Goal achieved' : 'Add savings'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _calendarContent(
    List<ExpenseTransaction> transactions,
    bool privacyMode,
  ) {
    final List<ExpenseTransaction> monthItems = transactions
        .where((ExpenseTransaction item) {
          return item.timestamp.year == _month.year &&
              item.timestamp.month == _month.month;
        })
        .toList(growable: false);
    final double spent = monthItems
        .where((ExpenseTransaction item) => item.isDebit)
        .fold(0, (double sum, ExpenseTransaction item) => sum + item.amount);
    final double income = monthItems
        .where((ExpenseTransaction item) => !item.isDebit)
        .fold(0, (double sum, ExpenseTransaction item) => sum + item.amount);
    final DateTime currentMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month,
    );

    return Column(
      children: <Widget>[
        Card(
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton.filledTonal(
                      onPressed: () {
                        setState(() {
                          _month = DateTime(_month.year, _month.month - 1);
                        });
                      },
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    Expanded(
                      child: Text(
                        monthYearFormat.format(_month),
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: _month.isBefore(currentMonth)
                          ? () {
                              setState(() {
                                _month = DateTime(
                                  _month.year,
                                  _month.month + 1,
                                );
                              });
                            }
                          : null,
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: <Widget>[
                    _metric(
                      'Income',
                      privacyMode ? '₹ •••' : inrCurrency.format(income),
                      AppPalette.mint,
                    ),
                    const SizedBox(width: 8),
                    _metric(
                      'Spent',
                      privacyMode ? '₹ •••' : inrCurrency.format(spent),
                      AppPalette.peach,
                    ),
                    const SizedBox(width: 8),
                    _metric(
                      'Net',
                      privacyMode
                          ? '₹ •••'
                          : inrCurrency.format(income - spent),
                      AppPalette.lavender,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 13),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(11),
            child: Column(
              children: <Widget>[
                const Row(
                  children: <Widget>[
                    _Weekday('Mon'),
                    _Weekday('Tue'),
                    _Weekday('Wed'),
                    _Weekday('Thu'),
                    _Weekday('Fri'),
                    _Weekday('Sat'),
                    _Weekday('Sun'),
                  ],
                ),
                const SizedBox(height: 7),
                _calendarGrid(monthItems, privacyMode),
              ],
            ),
          ),
        ),
        if (monthItems.isEmpty) ...<Widget>[
          const SizedBox(height: 13),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(19),
            decoration: BoxDecoration(
              color: AppPalette.lemon,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              children: <Widget>[
                Icon(Icons.calendar_today_rounded, size: 34),
                SizedBox(height: 7),
                Text(
                  'A quiet month so far 🌤️',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
                ),
                SizedBox(height: 4),
                Text(
                  'Confirmed transactions will colour this calendar.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _metric(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 11),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: <Widget>[
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 3),
            FittedBox(
              child: Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _calendarGrid(List<ExpenseTransaction> monthItems, bool privacyMode) {
    final DateTime firstDay = DateTime(_month.year, _month.month);
    final int leading = firstDay.weekday - 1;
    final int days = DateTime(_month.year, _month.month + 1, 0).day;
    final int cellCount = (((leading + days) / 7).ceil()) * 7;

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
        final int day = index - leading + 1;
        if (day < 1 || day > days) {
          return const SizedBox.shrink();
        }
        final DateTime date = DateTime(_month.year, _month.month, day);
        final List<ExpenseTransaction> items = monthItems
            .where((ExpenseTransaction item) {
              return item.timestamp.day == day;
            })
            .toList(growable: false);
        final double debit = items
            .where((ExpenseTransaction item) => item.isDebit)
            .fold(
              0,
              (double sum, ExpenseTransaction item) => sum + item.amount,
            );
        final double credit = items
            .where((ExpenseTransaction item) => !item.isDebit)
            .fold(
              0,
              (double sum, ExpenseTransaction item) => sum + item.amount,
            );
        final Color color = debit > 0 && credit > 0
            ? AppPalette.lavender
            : debit > 0
            ? AppPalette.peach
            : credit > 0
            ? AppPalette.mint
            : AppPalette.canvas;
        final bool today = _sameDay(date, DateTime.now());

        return InkWell(
          onTap: items.isEmpty
              ? null
              : () => _showDayTransactions(date, items, privacyMode),
          borderRadius: BorderRadius.circular(13),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(13),
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
                if (items.isNotEmpty) ...<Widget>[
                  Icon(
                    debit > credit
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    size: 13,
                  ),
                  FittedBox(
                    child: Text(
                      privacyMode
                          ? '•••'
                          : _compactAmount(math.max(debit, credit)),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
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
}

class _Weekday extends StatelessWidget {
  const _Weekday(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
      ),
    );
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
            const Icon(Icons.cloud_off_rounded, size: 46),
            const SizedBox(height: 11),
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

bool _sameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}

String _compactAmount(double value) {
  if (value >= 100000) {
    return '₹${(value / 100000).toStringAsFixed(1)}L';
  }
  if (value >= 1000) {
    return '₹${(value / 1000).toStringAsFixed(1)}K';
  }
  return '₹${value.toStringAsFixed(0)}';
}
