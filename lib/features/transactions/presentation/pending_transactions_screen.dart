import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class PendingTransactionsScreen extends ConsumerWidget {
  const PendingTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ExpenseTransaction>> pending = ref.watch(
      pendingTransactionsProvider,
    );
    final AsyncValue<List<CategoryModel>> categories = ref.watch(
      categoriesProvider,
    );
    final bool private = ref.watch(privacyModeProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Pending review',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            const Text('Swipe right to confirm or left to remove.'),
            const SizedBox(height: 18),
            Expanded(
              child: pending.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (Object error, StackTrace stackTrace) => const Center(
                  child: Text('Could not load the review inbox.'),
                ),
                data: (List<ExpenseTransaction> items) {
                  if (items.isEmpty) {
                    return const _ReviewEmptyState();
                  }
                  final List<CategoryModel> categoryItems =
                      categories.value ?? const <CategoryModel>[];
                  return ListView.separated(
                    padding: const EdgeInsets.only(bottom: 120),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (BuildContext context, int index) {
                      final ExpenseTransaction transaction = items[index];
                      return Dismissible(
                            key: ValueKey<int>(transaction.id),
                            confirmDismiss: (DismissDirection direction) async {
                              if (direction == DismissDirection.endToStart) {
                                return _confirmDelete(context);
                              }
                              return true;
                            },
                            onDismissed: (DismissDirection direction) {
                              if (direction == DismissDirection.startToEnd) {
                                unawaited(
                                  ref
                                      .read(transactionRepositoryProvider)
                                      .confirm(transaction.id),
                                );
                              } else {
                                unawaited(
                                  ref
                                      .read(transactionRepositoryProvider)
                                      .delete(transaction.id),
                                );
                              }
                            },
                            background: const _SwipeBackground(
                              alignment: Alignment.centerLeft,
                              color: AppPalette.mint,
                              icon: Icons.check_rounded,
                              label: 'Confirm',
                            ),
                            secondaryBackground: const _SwipeBackground(
                              alignment: Alignment.centerRight,
                              color: AppPalette.rose,
                              icon: Icons.delete_rounded,
                              label: 'Remove',
                            ),
                            child: _PendingCard(
                              transaction: transaction,
                              categories: categoryItems,
                              privacyMode: private,
                              onConfirm: () {
                                unawaited(
                                  ref
                                      .read(transactionRepositoryProvider)
                                      .confirm(transaction.id),
                                );
                              },
                              onEdit: () => _showEditDialog(
                                context: context,
                                ref: ref,
                                transaction: transaction,
                                categories: categoryItems,
                              ),
                            ),
                          )
                          .animate(delay: (55 * index).ms)
                          .fadeIn()
                          .slideX(begin: 0.08);
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

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Remove transaction?'),
              content: const Text('This removes only PiggyAI’s local copy.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Remove'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<void> _showEditDialog({
    required BuildContext context,
    required WidgetRef ref,
    required ExpenseTransaction transaction,
    required List<CategoryModel> categories,
  }) async {
    final _PendingEdit? edit = await showDialog<_PendingEdit>(
      context: context,
      builder: (BuildContext context) =>
          _PendingEditDialog(transaction: transaction, categories: categories),
    );
    if (edit == null) {
      return;
    }
    await ref
        .read(transactionRepositoryProvider)
        .updatePending(
          id: transaction.id,
          amount: edit.amount,
          merchant: edit.merchant,
          type: edit.type,
          categoryId: edit.categoryId,
        );
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard({
    required this.transaction,
    required this.categories,
    required this.privacyMode,
    required this.onConfirm,
    required this.onEdit,
  });

  final ExpenseTransaction transaction;
  final List<CategoryModel> categories;
  final bool privacyMode;
  final VoidCallback onConfirm;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    CategoryModel? category;
    for (final CategoryModel item in categories) {
      if (item.id == transaction.categoryId) {
        category = item;
        break;
      }
    }
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 26,
                backgroundColor: category == null
                    ? AppPalette.sky
                    : colorFromHex(category.hexColor),
                child: Icon(
                  transaction.isDebit
                      ? Icons.north_east_rounded
                      : Icons.south_west_rounded,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      transaction.merchant,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${category?.name ?? 'Choose category'} · '
                      '${transactionDateFormat.format(transaction.timestamp)}',
                    ),
                    if (transaction.accountTail.isNotEmpty)
                      Text('Account •••• ${transaction.accountTail}'),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    privacyMode
                        ? '₹ •••'
                        : inrCurrency.format(transaction.amount),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  IconButton(
                    tooltip: 'Confirm',
                    onPressed: onConfirm,
                    icon: const Icon(Icons.check_circle_rounded),
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

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Alignment alignment;
  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ReviewEmptyState extends StatelessWidget {
  const _ReviewEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.done_all_rounded, size: 72),
          SizedBox(height: 14),
          Text(
            'All caught up!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 6),
          Text('New detected transactions will appear here.'),
        ],
      ),
    );
  }
}

class _PendingEdit {
  const _PendingEdit({
    required this.amount,
    required this.merchant,
    required this.type,
    required this.categoryId,
  });

  final double amount;
  final String merchant;
  final TransactionType type;
  final int? categoryId;
}

class _PendingEditDialog extends StatefulWidget {
  const _PendingEditDialog({
    required this.transaction,
    required this.categories,
  });

  final ExpenseTransaction transaction;
  final List<CategoryModel> categories;

  @override
  State<_PendingEditDialog> createState() => _PendingEditDialogState();
}

class _PendingEditDialogState extends State<_PendingEditDialog> {
  late final TextEditingController _amountController;
  late final TextEditingController _merchantController;
  late TransactionType _type;
  int? _categoryId;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: widget.transaction.amount.toStringAsFixed(2),
    );
    _merchantController = TextEditingController(
      text: widget.transaction.merchant,
    );
    _type = widget.transaction.type;
    _categoryId = widget.transaction.categoryId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit transaction'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _merchantController,
              decoration: const InputDecoration(labelText: 'Merchant'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<TransactionType>(
              initialValue: _type,
              decoration: const InputDecoration(labelText: 'Type'),
              items: TransactionType.values
                  .map((TransactionType type) {
                    return DropdownMenuItem<TransactionType>(
                      value: type,
                      child: Text(type.name),
                    );
                  })
                  .toList(growable: false),
              onChanged: (TransactionType? value) {
                if (value != null) {
                  setState(() => _type = value);
                }
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              initialValue: _categoryId,
              decoration: const InputDecoration(labelText: 'Category'),
              items: widget.categories
                  .map((CategoryModel category) {
                    return DropdownMenuItem<int>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  })
                  .toList(growable: false),
              onChanged: (int? value) => setState(() => _categoryId = value),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final double? amount = double.tryParse(
              _amountController.text.trim(),
            );
            final String merchant = _merchantController.text.trim();
            if (amount == null || amount <= 0 || merchant.isEmpty) {
              return;
            }
            Navigator.of(context).pop(
              _PendingEdit(
                amount: amount,
                merchant: merchant,
                type: _type,
                categoryId: _categoryId,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
