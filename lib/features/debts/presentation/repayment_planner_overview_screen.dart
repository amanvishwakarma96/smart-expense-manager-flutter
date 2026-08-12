import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/presentation/repayment_plan_card.dart';

class RepaymentPlannerOverviewScreen extends ConsumerWidget {
  const RepaymentPlannerOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool privacyMode = ref.watch(privacyModeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('EMI & repayment planner')),
      body: SafeArea(
        child: ref.watch(debtAccountsProvider).when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object error, StackTrace stackTrace) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Text('Could not load debt ledgers.'),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => ref.invalidate(debtAccountsProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (List<DebtAccount> debts) {
                if (debts.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Create a debt or loan ledger first. Repayment plans attach to an existing private ledger.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 100),
                  itemCount: debts.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 18),
                  itemBuilder: (BuildContext context, int index) {
                    final DebtAccount account = debts[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      account.counterparty,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    Text(account.kind.label),
                                  ],
                                ),
                              ),
                              Text(
                                privacyMode
                                    ? '$defaultCurrencySymbol •••••'
                                    : inrCurrency.format(account.outstanding),
                                style: const TextStyle(fontWeight: FontWeight.w900),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        RepaymentPlanCard(
                          account: account,
                          privacyMode: privacyMode,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
      ),
    );
  }
}
