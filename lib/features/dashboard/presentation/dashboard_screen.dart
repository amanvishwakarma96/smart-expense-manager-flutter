import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ExpenseTransaction>> transactions =
        ref.watch(confirmedTransactionsProvider);
    final AsyncValue<List<CategoryModel>> categories =
        ref.watch(categoriesProvider);
    final int pendingCount =
        ref.watch(pendingTransactionsProvider).value?.length ?? 0;
    final bool privacyMode = ref.watch(privacyModeProvider);

    return SafeArea(
      child: transactions.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => const _EmptyState(
          icon: Icons.error_outline_rounded,
          title: 'Could not open local analytics',
          message: 'Your data is still stored only on this device.',
        ),
        data: (List<ExpenseTransaction> items) {
          return categories.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (Object error, StackTrace stackTrace) => const _EmptyState(
              icon: Icons.category_outlined,
              title: 'Categories are unavailable',
              message: 'Restart PiggyAI and try again.',
            ),
            data: (List<CategoryModel> categoryItems) {
              return _DashboardBody(
                transactions: items,
                categories: categoryItems,
                pendingCount: pendingCount,
                privacyMode: privacyMode,
                onTogglePrivacy: () {
                  ref.read(privacyModeProvider.notifier).toggle();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.transactions,
    required this.categories,
    required this.pendingCount,
    required this.privacyMode,
    required this.onTogglePrivacy,
  });

  final List<ExpenseTransaction> transactions;
  final List<CategoryModel> categories;
  final int pendingCount;
  final bool privacyMode;
  final VoidCallback onTogglePrivacy;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final List<ExpenseTransaction> thisMonth = transactions.where(
      (ExpenseTransaction item) {
        return item.timestamp.year == now.year &&
            item.timestamp.month == now.month;
      },
    ).toList(growable: false);

    final double spent = thisMonth
        .where((ExpenseTransaction item) => item.isDebit)
        .fold(0, (double sum, ExpenseTransaction item) => sum + item.amount);
    final double income = thisMonth
        .where((ExpenseTransaction item) => !item.isDebit)
        .fold(0, (double sum, ExpenseTransaction item) => sum + item.amount);
    final double budget = categories.fold(
      0,
      (double sum, CategoryModel item) => sum + item.monthlyBudgetLimit,
    );
    final Map<int, double> categorySpend = <int, double>{};
    for (final ExpenseTransaction item in thisMonth.where(
      (ExpenseTransaction item) => item.isDebit,
    )) {
      if (item.categoryId != null) {
        categorySpend.update(
          item.categoryId!,
          (double value) => value + item.amount,
          ifAbsent: () => item.amount,
        );
      }
    }

    String amount(double value) => privacyMode ? '₹ •••••' : inrCurrency.format(value);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Hello, smart spender 👋',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  const Text('Everything here is processed on your phone.'),
                ],
              ),
            ),
            IconButton.filledTonal(
              tooltip: privacyMode ? 'Show amounts' : 'Hide amounts',
              onPressed: onTogglePrivacy,
              icon: Icon(
                privacyMode
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppPalette.lavender,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Spent this month',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                amount(spent),
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              LinearProgressIndicator(
                value: budget <= 0 ? 0 : math.min(spent / budget, 1),
                minHeight: 12,
                borderRadius: BorderRadius.circular(20),
              ),
              const SizedBox(height: 8),
              Text(
                budget <= 0
                    ? 'Set category budgets in Settings.'
                    : '${amount(math.max(budget - spent, 0))} left from ${amount(budget)}',
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: 0.08, end: 0),
        const SizedBox(height: 14),
        Row(
          children: <Widget>[
            Expanded(
              child: _MetricCard(
                color: AppPalette.mint,
                icon: Icons.south_west_rounded,
                label: 'Income',
                value: amount(income),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                color: AppPalette.peach,
                icon: Icons.inbox_rounded,
                label: 'To review',
                value: pendingCount.toString(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _ChartCard(
          title: 'Where it went',
          child: _CategoryDonut(
            categories: categories,
            spending: categorySpend,
            privacyMode: privacyMode,
          ),
        ),
        const SizedBox(height: 14),
        _ChartCard(
          title: 'Last 7 days',
          child: _CashFlowChart(
            transactions: transactions,
            privacyMode: privacyMode,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.color,
    required this.icon,
    required this.label,
    required this.value,
  });

  final Color color;
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 3),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 120.ms).scale(begin: const Offset(0.96, 0.96));
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            SizedBox(height: 190, child: child),
          ],
        ),
      ),
    );
  }
}

class _CategoryDonut extends StatelessWidget {
  const _CategoryDonut({
    required this.categories,
    required this.spending,
    required this.privacyMode,
  });

  final List<CategoryModel> categories;
  final Map<int, double> spending;
  final bool privacyMode;

  @override
  Widget build(BuildContext context) {
    final List<CategoryModel> visible = categories
        .where((CategoryModel item) => (spending[item.id] ?? 0) > 0)
        .toList(growable: false);
    if (visible.isEmpty) {
      return const Center(child: Text('Confirm expenses to see your donut.'));
    }
    return Row(
      children: <Widget>[
        Expanded(
          child: PieChart(
            PieChartData(
              centerSpaceRadius: 46,
              sectionsSpace: 3,
              sections: visible.map((CategoryModel category) {
                return PieChartSectionData(
                  value: spending[category.id],
                  color: colorFromHex(category.hexColor),
                  radius: 34,
                  showTitle: false,
                );
              }).toList(growable: false),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: visible.map((CategoryModel category) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: colorFromHex(category.hexColor),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(category.name)),
                    Text(
                      privacyMode
                          ? '•••'
                          : inrCurrency.format(spending[category.id] ?? 0),
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              );
            }).toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class _CashFlowChart extends StatelessWidget {
  const _CashFlowChart({
    required this.transactions,
    required this.privacyMode,
  });

  final List<ExpenseTransaction> transactions;
  final bool privacyMode;

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    final List<FlSpot> spots = List<FlSpot>.generate(7, (int index) {
      final DateTime date = DateTime(
        today.year,
        today.month,
        today.day,
      ).subtract(Duration(days: 6 - index));
      final double spent = transactions.where((ExpenseTransaction item) {
        return item.isDebit &&
            item.timestamp.year == date.year &&
            item.timestamp.month == date.month &&
            item.timestamp.day == date.day;
      }).fold(0, (double sum, ExpenseTransaction item) => sum + item.amount);
      return FlSpot(index.toDouble(), privacyMode ? 0 : spent);
    });

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(enabled: !privacyMode),
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 5,
            color: AppPalette.mint,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppPalette.mint.withValues(alpha: 0.25),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 62),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
