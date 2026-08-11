import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/presentation/debt_account_editor_screen.dart';
import 'package:smart_expense_manager/features/debts/presentation/debt_detail_screen.dart';

class DebtOverviewScreen extends ConsumerWidget {
  const DebtOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool privacyMode = ref.watch(privacyModeProvider);
    final AsyncValue<List<DebtAccount>> debts = ref.watch(debtAccountsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Debts & loans')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => const DebtAccountEditorScreen(),
          ),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      body: SafeArea(
        child: debts.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (Object error, StackTrace stackTrace) => const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text('Debt ledgers could not be opened. Your local data remains on-device.'),
            ),
          ),
          data: (List<DebtAccount> items) {
            if (items.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const Icon(Icons.handshake_rounded, size: 68),
                      const SizedBox(height: 16),
                      Text(
                        'Nothing owed, nothing tracked',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Track money you borrowed, lent to someone, or owe on a loan. PiggyAI never creates a debt record automatically.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            final double youOwe = items
                .where((DebtAccount item) => item.kind.youOwe)
                .fold(0, (double sum, DebtAccount item) => sum + item.outstanding);
            final double owedToYou = items
                .where((DebtAccount item) => !item.kind.youOwe)
                .fold(0, (double sum, DebtAccount item) => sum + item.outstanding);
            String amount(double value) => privacyMode
                ? '$defaultCurrencySymbol •••••'
                : inrCurrency.format(value);
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _SummaryTile(
                        label: 'You owe',
                        value: amount(youOwe),
                        color: AppPalette.peach,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _SummaryTile(
                        label: 'Owed to you',
                        value: amount(owedToYou),
                        color: AppPalette.mint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ...items.map(
                  (DebtAccount item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _DebtCard(
                      account: item,
                      privacyMode: privacyMode,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => DebtDetailScreen(debtId: item.id),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 5),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DebtCard extends StatelessWidget {
  const _DebtCard({
    required this.account,
    required this.privacyMode,
    required this.onTap,
  });

  static final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  final DebtAccount account;
  final bool privacyMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String amount = privacyMode
        ? '$defaultCurrencySymbol •••••'
        : inrCurrency.format(account.outstanding);
    final DateTime? dueDate = account.dueDate;
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: account.kind.youOwe
                        ? AppPalette.peach
                        : AppPalette.mint,
                    child: Icon(
                      account.kind == DebtKind.loan
                          ? Icons.account_balance_rounded
                          : Icons.handshake_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          account.counterparty,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        Text(account.kind.label),
                      ],
                    ),
                  ),
                  Text(
                    account.isSettled ? 'Settled' : amount,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: account.progress,
                minHeight: 8,
                borderRadius: BorderRadius.circular(99),
              ),
              if (dueDate != null) ...<Widget>[
                const SizedBox(height: 8),
                Text('Due ${_dateFormat.format(dueDate)}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
