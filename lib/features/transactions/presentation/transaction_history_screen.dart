import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

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
            Text(
              'History',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 4),
            const Text('Search and filter confirmed transactions locally.'),
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
                      avatar: const Icon(Icons.calendar_month_rounded, size: 18),
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
                error: (Object error, StackTrace stackTrace) => const Center(
                  child: Text('Could not load local transaction history.'),
                ),
                data: (List<ExpenseTransaction> items) {
                  final List<ExpenseTransaction> filtered = _filterTransactions(
                    items,
                    categories,
                  );
                  if (filtered.isEmpty) {
                    return const _HistoryEmptyState();
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return _HistoryCard(
                        transaction: filtered[index],
                        category: _categoryFor(
                          filtered[index].categoryId,
                          categories,
                        ),
                        privacyMode: privacyMode,
                      );
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

    return items.where((ExpenseTransaction item) {
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
          item.timestamp.year == now.year && item.timestamp.month == now.month,
        _HistoryPeriodFilter.last90Days =>
          !item.timestamp.isBefore(ninetyDaysAgo),
        _HistoryPeriodFilter.all => true,
      };
      if (!matchesPeriod) {
        return false;
      }

      if (query.isEmpty) {
        return true;
      }
      final CategoryModel? category = _categoryFor(item.categoryId, categories);
      return item.merchant.toLowerCase().contains(query) ||
          item.accountTail.toLowerCase().contains(query) ||
          (category?.name.toLowerCase().contains(query) ?? false);
    }).toList(growable: false);
  }

  CategoryModel? _categoryFor(
    int? categoryId,
    List<CategoryModel> categories,
  ) {
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

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.transaction,
    required this.category,
    required this.privacyMode,
  });

  final ExpenseTransaction transaction;
  final CategoryModel? category;
  final bool privacyMode;

  @override
  Widget build(BuildContext context) {
    final Color accent = category == null
        ? AppPalette.sky
        : colorFromHex(category!.hexColor);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: accent,
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
            Text(
              privacyMode
                  ? '₹ •••'
                  : '${transaction.isDebit ? '-' : '+'}'
                      '${inrCurrency.format(transaction.amount)}',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: transaction.isDebit
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryEmptyState extends StatelessWidget {
  const _HistoryEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.search_off_rounded, size: 68),
            SizedBox(height: 14),
            Text(
              'No matching transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 6),
            Text(
              'Try another search, type, or date filter.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
