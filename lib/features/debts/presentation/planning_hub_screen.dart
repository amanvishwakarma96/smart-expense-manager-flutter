import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/presentation/debt_overview_screen.dart';
import 'package:smart_expense_manager/features/goals/domain/savings_goal.dart';
import 'package:smart_expense_manager/features/goals/presentation/goals_calendar_screen.dart';

class PlanningHubScreen extends ConsumerWidget {
  const PlanningHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool privacy = ref.watch(privacyModeProvider);
    final List<SavingsGoal> goals =
        ref.watch(savingsGoalsProvider).value ?? const <SavingsGoal>[];
    final List<DebtAccount> debts =
        ref.watch(debtAccountsProvider).value ?? const <DebtAccount>[];
    final double youOwe = debts
        .where((DebtAccount item) => item.kind.youOwe)
        .fold(0, (double sum, DebtAccount item) => sum + item.outstanding);
    final double owedToYou = debts
        .where((DebtAccount item) => !item.kind.youOwe)
        .fold(0, (double sum, DebtAccount item) => sum + item.outstanding);
    String amount(double value) =>
        privacy ? '$defaultCurrencySymbol •••••' : inrCurrency.format(value);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: AppPalette.heroGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.route_rounded, size: 40),
                SizedBox(height: 12),
                Text(
                  'Plan your money',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 4),
                Text(
                  'Savings goals, cash-flow calendar, debts and loans — all local.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _PlanCard(
            color: AppPalette.mint,
            icon: Icons.savings_rounded,
            title: 'Goals & calendar',
            subtitle:
                '${goals.length} active goal${goals.length == 1 ? '' : 's'}',
            detail: 'Save toward goals and inspect daily confirmed cash flow.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const Scaffold(body: GoalsCalendarScreen()),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _PlanCard(
            color: AppPalette.peach,
            icon: Icons.handshake_rounded,
            title: 'Debts & loans',
            subtitle: debts.isEmpty
                ? 'No active private ledgers'
                : '${debts.length} active • You owe ${amount(youOwe)}',
            detail: debts.isEmpty
                ? 'Track borrowed money, money you lent, or a formal loan.'
                : 'Owed to you ${amount(owedToYou)} • tap to manage repayments.',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const DebtOverviewScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.onTap,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final String detail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 26,
                backgroundColor: color,
                child: Icon(icon),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(detail),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
