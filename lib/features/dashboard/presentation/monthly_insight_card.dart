import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/dashboard/presentation/spending_forecast_card.dart';
import 'package:smart_expense_manager/features/dashboard/presentation/subscription_suggestions_card.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

class MonthlyInsightCard extends ConsumerWidget {
  const MonthlyInsightCard({
    required this.transactions,
    required this.categories,
    required this.privacyMode,
    super.key,
  });

  final List<ExpenseTransaction> transactions;
  final List<CategoryModel> categories;
  final bool privacyMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<RecurringTransaction> recurring =
        ref.watch(recurringTransactionsProvider).value ??
        const <RecurringTransaction>[];
    final DateTime now = DateTime.now();
    final DateTime previousMonth = DateTime(now.year, now.month - 1);
    final List<ExpenseTransaction> current = transactions
        .where((ExpenseTransaction item) {
          return item.countsAsSpending &&
              item.timestamp.year == now.year &&
              item.timestamp.month == now.month;
        })
        .toList(growable: false);
    final List<ExpenseTransaction> previous = transactions
        .where((ExpenseTransaction item) {
          return item.countsAsSpending &&
              item.timestamp.year == previousMonth.year &&
              item.timestamp.month == previousMonth.month;
        })
        .toList(growable: false);

    final double currentSpent = current.fold(
      0,
      (double total, ExpenseTransaction item) => total + item.amount,
    );
    final double previousSpent = previous.fold(
      0,
      (double total, ExpenseTransaction item) => total + item.amount,
    );
    final double dailyAverage = currentSpent / math.max(now.day, 1);
    final Map<int, double> categorySpend = <int, double>{};
    for (final ExpenseTransaction item in current.where(
      (ExpenseTransaction item) => item.countsAgainstBudget,
    )) {
      if (item.categoryId != null) {
        categorySpend.update(
          item.categoryId!,
          (double value) => value + item.amount,
          ifAbsent: () => item.amount,
        );
      }
    }
    int? topCategoryId;
    double topCategoryAmount = 0;
    for (final MapEntry<int, double> entry in categorySpend.entries) {
      if (entry.value > topCategoryAmount) {
        topCategoryId = entry.key;
        topCategoryAmount = entry.value;
      }
    }
    final CategoryModel? topCategory = _categoryFor(topCategoryId);
    final double trendPercent = previousSpent <= 0
        ? 0
        : ((currentSpent - previousSpent) / previousSpent) * 100;
    final bool spendingImproved = trendPercent < 0;

    String amount(double value) =>
        privacyMode ? '$defaultCurrencySymbol ••••' : inrCurrency.format(value);

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
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppPalette.sunshine,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.lightbulb_rounded),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Your month in a nutshell',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Text(
                            'Transfers and borrowed money stay out of spending/income insights.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      _InsightPill(
                        color: AppPalette.sky,
                        icon: Icons.calendar_today_rounded,
                        label: 'Daily average',
                        value: amount(dailyAverage),
                      ),
                      const SizedBox(width: 10),
                      _InsightPill(
                        color: topCategory == null
                            ? AppPalette.lavender
                            : colorFromHex(topCategory.hexColor),
                        icon: Icons.emoji_events_rounded,
                        label: 'Top category',
                        value: topCategory?.name ?? 'No leader yet',
                      ),
                      const SizedBox(width: 10),
                      _InsightPill(
                        color: spendingImproved
                            ? AppPalette.mint
                            : AppPalette.peach,
                        icon: spendingImproved
                            ? Icons.trending_down_rounded
                            : Icons.trending_up_rounded,
                        label: 'Vs last month',
                        value: previousSpent <= 0
                            ? 'Building baseline'
                            : '${trendPercent.abs().toStringAsFixed(0)}% '
                                  '${spendingImproved ? 'lower' : 'higher'}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 160.ms).slideY(begin: 0.06, end: 0),
        const SizedBox(height: 14),
        SubscriptionSuggestionsCard(
          transactions: transactions,
          recurring: recurring,
          privacyMode: privacyMode,
        ),
        const SizedBox(height: 14),
        SpendingForecastCard(
          transactions: transactions,
          recurring: recurring,
          categories: categories,
          privacyMode: privacyMode,
        ),
      ],
    );
  }

  CategoryModel? _categoryFor(int? id) {
    if (id == null) {
      return null;
    }
    for (final CategoryModel category in categories) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }
}

class _InsightPill extends StatelessWidget {
  const _InsightPill({
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
      width: 154,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 22),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
