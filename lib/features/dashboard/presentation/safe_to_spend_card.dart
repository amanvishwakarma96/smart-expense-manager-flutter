import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/dashboard/domain/safe_to_spend.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

class SafeToSpendCard extends StatelessWidget {
  const SafeToSpendCard({
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
    final SafeToSpendPlan plan = const SafeToSpendService().calculate(
      transactions: transactions,
      recurring: recurring,
      categories: categories,
    );
    final String safeAmount = _amount(plan.safeToSpend);
    final String dailyAmount = _amount(plan.safePerDay);
    final List<UpcomingBill> visibleBills = plan.upcomingBills
        .take(3)
        .toList(growable: false);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[AppPalette.mint, AppPalette.sky, AppPalette.lemon],
        ),
        borderRadius: BorderRadius.circular(30),
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
                  color: Colors.white.withValues(alpha: 0.68),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: const Icon(Icons.beach_access_rounded),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Safe-to-spend pocket',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Text('A conservative local plan for this month.'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (plan.basis == SafeToSpendBasis.unavailable) ...<Widget>[
            const Text(
              'Add a monthly budget or confirm income to unlock this estimate.',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ] else ...<Widget>[
            const Text(
              'Available after scheduled bills',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              safeAmount,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppPalette.ink,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '$dailyAmount per day for ${plan.daysRemaining} day'
              '${plan.daysRemaining == 1 ? '' : 's'} remaining',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            Text(_basisExplanation(plan.basis)),
          ],
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: <Widget>[
                const Icon(Icons.event_available_rounded),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    plan.upcomingBills.isEmpty
                        ? 'No active scheduled expenses remain this month.'
                        : '${plan.upcomingBills.length} upcoming payment'
                              '${plan.upcomingBills.length == 1 ? '' : 's'} reserve ${_amount(plan.upcomingBillTotal)}.',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          ),
          if (visibleBills.isNotEmpty) ...<Widget>[
            const SizedBox(height: 12),
            ...visibleBills.map((UpcomingBill bill) {
              return Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.65),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(Icons.receipt_long_rounded, size: 18),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            bill.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          Text(transactionDayFormat.format(bill.dueAt)),
                        ],
                      ),
                    ),
                    Text(
                      _amount(bill.amount),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              );
            }),
          ],
          const SizedBox(height: 13),
          const Text(
            'This estimate never assumes future income and never changes your records.',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 110.ms).slideY(begin: 0.06, end: 0);
  }

  String _amount(double value) {
    return privacyMode
        ? '$defaultCurrencySymbol •••••'
        : inrCurrency.format(value);
  }

  static String _basisExplanation(SafeToSpendBasis basis) {
    return switch (basis) {
      SafeToSpendBasis.incomeAndBudget =>
        'Uses the lower of cash remaining and budget remaining.',
      SafeToSpendBasis.incomeOnly =>
        'Uses confirmed income minus confirmed spending and scheduled bills.',
      SafeToSpendBasis.budgetOnly =>
        'Uses remaining category budgets minus scheduled bills.',
      SafeToSpendBasis.unavailable => '',
    };
  }
}
