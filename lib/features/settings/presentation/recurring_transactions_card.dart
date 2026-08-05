import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

class RecurringTransactionsCard extends ConsumerWidget {
  const RecurringTransactionsCard({super.key});

  Future<void> _openEditor(
    BuildContext context, {
    RecurringTransaction? transaction,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) => _RecurringEditorSheet(
        transaction: transaction,
      ),
    );
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    RecurringTransaction transaction,
  ) async {
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Delete recurring item?'),
              content: Text(
                '${transaction.merchant} will stop creating future review entries.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Keep'),
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
    await ref
        .read(recurringTransactionRepositoryProvider)
        .delete(transaction.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<RecurringTransaction>> recurring = ref.watch(
      recurringTransactionsProvider,
    );
    final bool privacyMode = ref.watch(privacyModeProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppPalette.rose,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.event_repeat_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Recurring money moments',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Text('Weekly or monthly, always reviewed first.'),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Add recurring transaction',
                  onPressed: () => _openEditor(context),
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
            const SizedBox(height: 14),
            recurring.when(
              loading: () => const LinearProgressIndicator(),
              error: (Object error, StackTrace stackTrace) => const Text(
                'Could not load recurring items from local storage.',
              ),
              data: (List<RecurringTransaction> items) {
                if (items.isEmpty) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppPalette.lemon,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Row(
                      children: <Widget>[
                        Icon(Icons.auto_awesome_rounded),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Add rent, salary, subscriptions, or any repeating transaction.',
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().scale(
                    begin: const Offset(0.97, 0.97),
                  );
                }
                return Column(
                  children: items.indexed.map((entry) {
                    final int index = entry.$1;
                    final RecurringTransaction item = entry.$2;
                    final Color accent = AppPalette.playfulSequence[
                      index % AppPalette.playfulSequence.length
                    ];
                    return Padding(
                      padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: accent.withValues(alpha: item.isActive ? 0.72 : 0.30),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.66),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(
                                item.isDebit
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
                                    item.merchant,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${_frequencyLabel(item.frequency)} · next ${transactionDayFormat.format(item.nextDueAt)}',
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    privacyMode
                                        ? '$defaultCurrencySymbol ••••'
                                        : inrCurrency.format(item.amount),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: item.isActive,
                              onChanged: (bool value) {
                                ref
                                    .read(recurringTransactionRepositoryProvider)
                                    .setActive(item.id, value);
                              },
                            ),
                            PopupMenuButton<_RecurringAction>(
                              onSelected: (_RecurringAction action) {
                                switch (action) {
                                  case _RecurringAction.edit:
                                    _openEditor(context, transaction: item);
                                    break;
                                  case _RecurringAction.delete:
                                    _delete(context, ref, item);
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return const <PopupMenuEntry<_RecurringAction>>[
                                  PopupMenuItem<_RecurringAction>(
                                    value: _RecurringAction.edit,
                                    child: Text('Edit'),
                                  ),
                                  PopupMenuItem<_RecurringAction>(
                                    value: _RecurringAction.delete,
                                    child: Text('Delete'),
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: (index * 45).ms).slideX(
                        begin: 0.04,
                        end: 0,
                      ),
                    );
                  }).toList(growable: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _frequencyLabel(RecurringFrequency frequency) {
    return switch (frequency) {
      RecurringFrequency.weekly => 'Weekly',
      RecurringFrequency.monthly => 'Monthly',
    };
  }
}

class _RecurringEditorSheet extends ConsumerStatefulWidget {
  const _RecurringEditorSheet({this.transaction});

  final RecurringTransaction? transaction;

  @override
  ConsumerState<_RecurringEditorSheet> createState() =>
      _RecurringEditorSheetState();
}

class _RecurringEditorSheetState
    extends ConsumerState<_RecurringEditorSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _merchantController;
  late final TextEditingController _amountController;
  late TransactionType _type;
  late RecurringFrequency _frequency;
  late DateTime _nextDueAt;
  int? _categoryId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final RecurringTransaction? item = widget.transaction;
    _merchantController = TextEditingController(text: item?.merchant ?? '');
    _amountController = TextEditingController(
      text: item?.amount.toStringAsFixed(2) ?? '',
    );
    _type = item?.type ?? TransactionType.debit;
    _frequency = item?.frequency ?? RecurringFrequency.monthly;
    _nextDueAt = item?.nextDueAt ?? DateTime.now();
    _categoryId = item?.categoryId;
  }

  @override
  void dispose() {
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _nextDueAt,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 3660)),
      helpText: 'Choose the next due date',
    );
    if (selected == null || !mounted) {
      return;
    }
    setState(() => _nextDueAt = selected);
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _saving = true);
    await ref.read(recurringTransactionRepositoryProvider).save(
          id: widget.transaction?.id,
          amount: double.parse(_amountController.text.trim()),
          type: _type,
          merchant: _merchantController.text.trim(),
          frequency: _frequency,
          nextDueAt: _nextDueAt,
          categoryId: _categoryId,
          isActive: widget.transaction?.isActive ?? true,
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<CategoryModel> categories =
        ref.watch(categoriesProvider).value ?? const <CategoryModel>[];
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 8,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: AppPalette.heroGradient,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  children: <Widget>[
                    const Icon(Icons.event_repeat_rounded, size: 38),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.transaction == null
                                ? 'Add a recurring item'
                                : 'Edit recurring item',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Text('It will land in Review before confirmation.'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SegmentedButton<TransactionType>(
                segments: const <ButtonSegment<TransactionType>>[
                  ButtonSegment<TransactionType>(
                    value: TransactionType.debit,
                    label: Text('Expense'),
                    icon: Icon(Icons.north_east_rounded),
                  ),
                  ButtonSegment<TransactionType>(
                    value: TransactionType.credit,
                    label: Text('Income'),
                    icon: Icon(Icons.south_west_rounded),
                  ),
                ],
                selected: <TransactionType>{_type},
                onSelectionChanged: (Set<TransactionType> selected) {
                  setState(() => _type = selected.first);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _merchantController,
                decoration: const InputDecoration(
                  labelText: 'Name or note',
                  prefixIcon: Icon(Icons.storefront_rounded),
                ),
                validator: (String? value) => (value?.trim().isEmpty ?? true)
                    ? 'Enter a name or note'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Amount in INR',
                  prefixText: '$defaultCurrencySymbol ',
                  prefixIcon: Icon(Icons.currency_rupee_rounded),
                ),
                validator: (String? value) {
                  final double? amount = double.tryParse(value?.trim() ?? '');
                  return amount == null || amount <= 0
                      ? 'Enter a valid amount'
                      : null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: _categoryId,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  prefixIcon: Icon(Icons.category_rounded),
                ),
                items: categories
                    .map((CategoryModel category) {
                      return DropdownMenuItem<int>(
                        value: category.id,
                        child: Text(category.name),
                      );
                    })
                    .toList(growable: false),
                onChanged: (int? value) => setState(() => _categoryId = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<RecurringFrequency>(
                initialValue: _frequency,
                decoration: const InputDecoration(
                  labelText: 'Repeats',
                  prefixIcon: Icon(Icons.repeat_rounded),
                ),
                items: const <DropdownMenuItem<RecurringFrequency>>[
                  DropdownMenuItem<RecurringFrequency>(
                    value: RecurringFrequency.weekly,
                    child: Text('Every week'),
                  ),
                  DropdownMenuItem<RecurringFrequency>(
                    value: RecurringFrequency.monthly,
                    child: Text('Every month'),
                  ),
                ],
                onChanged: (RecurringFrequency? value) {
                  if (value != null) {
                    setState(() => _frequency = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(22),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Next due date',
                    prefixIcon: Icon(Icons.calendar_month_rounded),
                  ),
                  child: Text(transactionDayFormat.format(_nextDueAt)),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(
                  widget.transaction == null ? 'Save recurring item' : 'Save changes',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _RecurringAction { edit, delete }
