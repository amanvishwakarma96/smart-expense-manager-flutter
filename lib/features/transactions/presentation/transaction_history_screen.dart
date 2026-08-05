import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/core/widgets/playful_empty_state.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/presentation/manual_transaction_dialog.dart';

enum _HistoryTypeFilter { all, debit, credit }

enum _HistoryPeriodFilter { currentMonth, last90Days, all }

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  _HistoryTypeFilter _typeFilter = _HistoryTypeFilter.all;
  _HistoryPeriodFilter _periodFilter = _HistoryPeriodFilter.currentMonth;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _deleteTransaction(ExpenseTransaction transaction) async {
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Remove this transaction?'),
              content: Text(
                '${transaction.merchant} will be deleted only from this device.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Keep it'),
                ),
                FilledButton.icon(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  icon: const Icon(Icons.delete_rounded),
                  label: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
    if (!confirmed) {
      return;
    }
    await ref.read(transactionRepositoryProvider).delete(transaction.id);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<ExpenseTransaction>> transactions = ref.watch(
      confirmedTransactionsProvider,
    );
    final List<CategoryModel> categories =
        ref.watch(categoriesProvider).value ?? const <CategoryModel>[];
    final bool privacyMode = ref.watch(privacyModeProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Money moments',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      const Text('Tap any card to edit it locally.'),
                    ],
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppPalette.sunshine,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded),
                ).animate().scale(
                  begin: const Offset(0.8, 0.8),
                  curve: Curves.easeOutBack,
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search merchant, category, or account tail',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  _FilterChip(
                    label: 'All',
                    selected: _typeFilter == _HistoryTypeFilter.all,
                    onSelected: () {
                      setState(() => _typeFilter = _HistoryTypeFilter.all);
                    },
                  ),
                  _FilterChip(
                    label: 'Expenses',
                    selected: _typeFilter == _HistoryTypeFilter.debit,
                    onSelected: () {
                      setState(() => _typeFilter = _HistoryTypeFilter.debit);
                    },
                  ),
                  _FilterChip(
                    label: 'Income',
                    selected: _typeFilter == _HistoryTypeFilter.credit,
                    onSelected: () {
                      setState(() => _typeFilter = _HistoryTypeFilter.credit);
                    },
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<_HistoryPeriodFilter>(
                    initialValue: _periodFilter,
                    onSelected: (_HistoryPeriodFilter value) {
                      setState(() => _periodFilter = value);
                    },
                    itemBuilder: (BuildContext context) {
                      return const <PopupMenuEntry<_HistoryPeriodFilter>>[
                        PopupMenuItem<_HistoryPeriodFilter>(
                          value: _HistoryPeriodFilter.currentMonth,
                          child: Text('Current month'),
                        ),
                        PopupMenuItem<_HistoryPeriodFilter>(
                          value: _HistoryPeriodFilter.last90Days,
                          child: Text('Last 90 days'),
                        ),
                        PopupMenuItem<_HistoryPeriodFilter>(
                          value: _HistoryPeriodFilter.all,
                          child: Text('All time'),
                        ),
                      ];
                    },
                    child: Chip(
                      avatar: const Icon(
                        Icons.calendar_month_rounded,
                        size: 18,
                      ),
                      label: Text(_periodLabel(_periodFilter)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: transactions.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object error, StackTrace stackTrace) =>
                    const PlayfulEmptyState(
                      icon: Icons.receipt_long_rounded,
                      title: 'History is taking a tiny break',
                      message:
                          'Your financial data is still safe on this device.',
                      accentColor: AppPalette.rose,
                    ),
                data: (List<ExpenseTransaction> items) {
                  final List<ExpenseTransaction> filtered = _filterTransactions(
                    items,
                    categories,
                  );
                  if (filtered.isEmpty) {
                    return PlayfulEmptyState(
                      icon: Icons.search_rounded,
                      title: 'Nothing matched yet',
                      message:
                          'Try another search, type, or date filter. Your next money moment may be hiding nearby.',
                      actionLabel: 'Clear filters',
                      onAction: () {
                        _searchController.clear();
                        setState(() {
                          _typeFilter = _HistoryTypeFilter.all;
                          _periodFilter = _HistoryPeriodFilter.currentMonth;
                        });
                      },
                      accentColor: AppPalette.sky,
                    );
                  }
                  final double expenseTotal = filtered
                      .where((ExpenseTransaction item) => item.isDebit)
                      .fold(
                        0,
                        (double total, ExpenseTransaction item) =>
                            total + item.amount,
                      );
                  final double incomeTotal = filtered
                      .where((ExpenseTransaction item) => !item.isDebit)
                      .fold(
                        0,
                        (double total, ExpenseTransaction item) =>
                            total + item.amount,
                      );

                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: filtered.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return _HistorySummary(
                          expenseTotal: expenseTotal,
                          incomeTotal: incomeTotal,
                          count: filtered.length,
                          privacyMode: privacyMode,
                        );
                      }
                      final ExpenseTransaction transaction =
                          filtered[index - 1];
                      return _HistoryCard(
                            transaction: transaction,
                            category: _categoryFor(
                              transaction.categoryId,
                              categories,
                            ),
                            privacyMode: privacyMode,
                            onEdit: () => showTransactionEditorDialog(
                              context,
                              transaction: transaction,
                            ),
                            onDelete: () => _deleteTransaction(transaction),
                          )
                          .animate()
                          .fadeIn(delay: (index * 35).ms)
                          .slideX(begin: 0.04, end: 0);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ExpenseTransaction> _filterTransactions(
    List<ExpenseTransaction> items,
    List<CategoryModel> categories,
  ) {
    final DateTime now = DateTime.now();
    final DateTime ninetyDaysAgo = now.subtract(const Duration(days: 90));
    final String query = _searchController.text.trim().toLowerCase();

    return items
        .where((ExpenseTransaction item) {
          final bool matchesType = switch (_typeFilter) {
            _HistoryTypeFilter.all => true,
            _HistoryTypeFilter.debit => item.isDebit,
            _HistoryTypeFilter.credit => !item.isDebit,
          };
          if (!matchesType) {
            return false;
          }

          final bool matchesPeriod = switch (_periodFilter) {
            _HistoryPeriodFilter.currentMonth =>
              item.timestamp.year == now.year &&
                  item.timestamp.month == now.month,
            _HistoryPeriodFilter.last90Days => !item.timestamp.isBefore(
              ninetyDaysAgo,
            ),
            _HistoryPeriodFilter.all => true,
          };
          if (!matchesPeriod) {
            return false;
          }

          if (query.isEmpty) {
            return true;
          }
          final CategoryModel? category = _categoryFor(
            item.categoryId,
            categories,
          );
          return item.merchant.toLowerCase().contains(query) ||
              item.accountTail.toLowerCase().contains(query) ||
              (category?.name.toLowerCase().contains(query) ?? false);
        })
        .toList(growable: false);
  }

  CategoryModel? _categoryFor(int? categoryId, List<CategoryModel> categories) {
    for (final CategoryModel category in categories) {
      if (category.id == categoryId) {
        return category;
      }
    }
    return null;
  }

  String _periodLabel(_HistoryPeriodFilter filter) {
    return switch (filter) {
      _HistoryPeriodFilter.currentMonth => 'This month',
      _HistoryPeriodFilter.last90Days => '90 days',
      _HistoryPeriodFilter.all => 'All time',
    };
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
      ),
    );
  }
}

class _HistorySummary extends StatelessWidget {
  const _HistorySummary({
    required this.expenseTotal,
    required this.incomeTotal,
    required this.count,
    required this.privacyMode,
  });

  final double expenseTotal;
  final double incomeTotal;
  final int count;
  final bool privacyMode;

  @override
  Widget build(BuildContext context) {
    String amount(double value) =>
        privacyMode ? '$defaultCurrencySymbol ••••' : inrCurrency.format(value);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppPalette.heroGradient,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _SummaryValue(
              label: 'Spent',
              value: amount(expenseTotal),
              icon: Icons.arrow_outward_rounded,
            ),
          ),
          Container(
            width: 1,
            height: 52,
            color: Colors.white.withValues(alpha: 0.62),
          ),
          Expanded(
            child: _SummaryValue(
              label: 'Received',
              value: amount(incomeTotal),
              icon: Icons.call_received_rounded,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.66),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '$count',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.08, end: 0);
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 16),
              const SizedBox(width: 5),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.transaction,
    required this.category,
    required this.privacyMode,
    required this.onEdit,
    required this.onDelete,
  });

  final ExpenseTransaction transaction;
  final CategoryModel? category;
  final bool privacyMode;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final Color accent = category == null
        ? AppPalette.sky
        : colorFromHex(category!.hexColor);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  transaction.isDebit
                      ? Icons.north_east_rounded
                      : Icons.south_west_rounded,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      transaction.merchant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category?.name ?? 'Uncategorized'} · '
                      '${transactionDateFormat.format(transaction.timestamp)}',
                    ),
                    if (transaction.accountTail.isNotEmpty)
                      Text('Account •••• ${transaction.accountTail}'),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    privacyMode
                        ? '$defaultCurrencySymbol •••'
                        : '${transaction.isDebit ? '-' : '+'}'
                              '${inrCurrency.format(transaction.amount)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: transaction.isDebit
                          ? Theme.of(context).colorScheme.error
                          : AppPalette.mintDeep,
                    ),
                  ),
                  PopupMenuButton<_HistoryAction>(
                    tooltip: 'Transaction actions',
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.more_horiz_rounded, size: 20),
                    onSelected: (_HistoryAction action) {
                      switch (action) {
                        case _HistoryAction.edit:
                          onEdit();
                        case _HistoryAction.delete:
                          onDelete();
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return const <PopupMenuEntry<_HistoryAction>>[
                        PopupMenuItem<_HistoryAction>(
                          value: _HistoryAction.edit,
                          child: ListTile(
                            leading: Icon(Icons.edit_rounded),
                            title: Text('Edit'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem<_HistoryAction>(
                          value: _HistoryAction.delete,
                          child: ListTile(
                            leading: Icon(Icons.delete_outline_rounded),
                            title: Text('Delete'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _HistoryAction { edit, delete }
