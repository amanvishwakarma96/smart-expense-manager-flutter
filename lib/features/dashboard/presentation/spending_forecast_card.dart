import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/dashboard/domain/spending_forecast.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

class SpendingForecastCard extends StatelessWidget {
  const SpendingForecastCard({
    required this.transactions,
    required this.recurring,
    required this.categories,
    required this.privacyMode,
    super.key,
  });

  final List<ExpenseTransaction> transactions;
  final List<RecurringTransaction> recurring;
  final List<CategoryModel> categories;
  final bool privacyMode;

  @override
  Widget build(BuildContext context) {
    final SpendingForecast forecast = const SpendingForecastService().calculate(
      transactions: transactions,
      recurring: recurring,
      categories: categories,
    );
    final String confidence = switch (forecast.confidence) {
      ForecastConfidence.low => 'Early estimate',
      ForecastConfidence.medium => 'Growing confidence',
      ForecastConfidence.high => 'Strong local signal',
    };
    final String guidance = forecast.totalBudget <= 0
        ? 'Add category budgets to compare this estimate with your plan.'
        : forecast.isOverBudget
        ? 'Your current pace may cross the monthly budget. A small trim now can help.'
        : forecast.budgetUsage >= 0.85
        ? 'You are close to the planned budget. Keep an eye on flexible spending.'
        : 'Your current pace leaves comfortable room in the plan.';
    String money(double value) => privacyMode
        ? '$defaultCurrencySymbol •••••'
        : inrCurrency.format(value);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            AppPalette.sky,
            AppPalette.lavender,
            AppPalette.lemon,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.travel_explore_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Next 30 days',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '$confidence · calculated only on this device',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            money(forecast.projectedSpend),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const Text(
            'estimated spending',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          if (forecast.totalBudget > 0) ...<Widget>[
            LinearProgressIndicator(
              value: math.min(forecast.budgetUsage, 1),
              minHeight: 11,
              borderRadius: BorderRadius.circular(99),
              color: forecast.isOverBudget
                  ? AppPalette.coral
                  : AppPalette.lavenderDeep,
              backgroundColor: Colors.white.withValues(alpha: 0.58),
            ),
            const SizedBox(height: 8),
          ],
          Text(guidance),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _ForecastChip(
                icon: Icons.repeat_rounded,
                label: 'Scheduled ${money(forecast.recurringSpend)}',
              ),
              _ForecastChip(
                icon: Icons.auto_graph_rounded,
                label: 'Flexible ${money(forecast.variableSpend)}',
              ),
              _ForecastChip(
                icon: forecast.projectedNet >= 0
                    ? Icons.savings_rounded
                    : Icons.warning_amber_rounded,
                label: 'Net ${money(forecast.projectedNet.abs())}',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            forecast.historyDays == 0
                ? 'Add confirmed transactions to improve the estimate.'
                : 'Based on ${forecast.historyDays} day${forecast.historyDays == 1 ? '' : 's'} of recent history plus active recurring items.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 160.ms).slideY(begin: 0.06, end: 0);
  }
}

class _ForecastChip extends StatelessWidget {
  const _ForecastChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.66),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 17),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
