import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/core/utils/formatters.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/presentation/transaction_semantics_widgets.dart';

Future<void> showManualTransactionDialog(BuildContext context) {
  return showTransactionEditorDialog(context);
}

Future<void> showTransactionEditorDialog(
  BuildContext context, {
  ExpenseTransaction? transaction,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (BuildContext context) =>
        _TransactionEditorSheet(transaction: transaction),
  );
}

class _TransactionEditorSheet extends ConsumerStatefulWidget {
  const _TransactionEditorSheet({this.transaction});

  final ExpenseTransaction? transaction;

  @override
  ConsumerState<_TransactionEditorSheet> createState() =>
      _TransactionEditorSheetState();
}

class _TransactionEditorSheetState
    extends ConsumerState<_TransactionEditorSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _merchantController;
  late TransactionType _type;
  late TransactionPurpose _purpose;
  late DateTime _timestamp;
  int? _categoryId;
  bool _saving = false;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final ExpenseTransaction? transaction = widget.transaction;
    _amountController = TextEditingController(
      text: transaction?.amount.toStringAsFixed(2) ?? '',
    );
    _merchantController = TextEditingController(
      text: transaction?.merchant ?? '',
    );
    _type = transaction?.type ?? TransactionType.debit;
    _purpose = transaction?.purpose ?? defaultTransactionPurpose(_type);
    _timestamp = transaction?.timestamp ?? DateTime.now();
    _categoryId = transaction?.categoryId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _timestamp,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      helpText: 'Choose transaction date',
    );
    if (selected == null || !mounted) {
      return;
    }
    setState(() {
      _timestamp = DateTime(
        selected.year,
        selected.month,
        selected.day,
        _timestamp.hour,
        _timestamp.minute,
      );
    });
  }

  void _changeType(TransactionType type) {
    setState(() {
      _type = type;
      if (!transactionPurposesFor(type).contains(_purpose)) {
        _purpose = defaultTransactionPurpose(type);
      }
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _saving = true);
    final double amount = double.parse(_amountController.text.trim());
    final String merchant = _merchantController.text.trim();
    final repository = ref.read(transactionRepositoryProvider);
    if (_isEditing) {
      await repository.updateConfirmed(
        id: widget.transaction!.id,
        amount: amount,
        type: _type,
        purpose: _purpose,
        merchant: merchant,
        timestamp: _timestamp,
        categoryId: _categoryId,
      );
    } else {
      await repository.addManualTransaction(
        amount: amount,
        type: _type,
        purpose: _purpose,
        merchant: merchant,
        timestamp: _timestamp,
        categoryId: _categoryId,
      );
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<CategoryModel>> categories = ref.watch(
      categoriesProvider,
    );
    final Color accent = _type == TransactionType.debit
        ? AppPalette.peach
        : AppPalette.mint;

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
              AnimatedContainer(
                duration: 260.ms,
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.68),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        _type == TransactionType.debit
                            ? Icons.north_east_rounded
                            : Icons.south_west_rounded,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _isEditing
                                ? 'Tune this transaction'
                                : 'Add a money moment',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _isEditing
                                ? 'Direction, purpose and category stay separate so your totals remain accurate.'
                                : 'Saved privately on this device in $defaultCurrencyCode.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().slideY(begin: 0.08, end: 0),
              const SizedBox(height: 18),
              SegmentedButton<TransactionType>(
                segments: const <ButtonSegment<TransactionType>>[
                  ButtonSegment<TransactionType>(
                    value: TransactionType.debit,
                    label: Text('Debit'),
                    icon: Icon(Icons.north_east_rounded),
                  ),
                  ButtonSegment<TransactionType>(
                    value: TransactionType.credit,
                    label: Text('Credit'),
                    icon: Icon(Icons.south_west_rounded),
                  ),
                ],
                selected: <TransactionType>{_type},
                onSelectionChanged: (Set<TransactionType> value) {
                  _changeType(value.first);
                },
              ),
              const SizedBox(height: 14),
              TransactionPurposeField(
                key: ValueKey<String>('${_type.name}-${_purpose.name}'),
                type: _type,
                value: _purpose,
                onChanged: (TransactionPurpose value) {
                  setState(() => _purpose = value);
                },
              ),
              const SizedBox(height: 14),
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
              TextFormField(
                controller: _merchantController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Merchant, person or note',
                  prefixIcon: Icon(Icons.storefront_rounded),
                ),
                validator: (String? value) => (value?.trim().isEmpty ?? true)
                    ? 'Enter a merchant, person or note'
                    : null,
              ),
              const SizedBox(height: 12),
              categories.when(
                loading: () => const LinearProgressIndicator(),
                error: (Object error, StackTrace stackTrace) =>
                    const Text('Categories unavailable'),
                data: (List<CategoryModel> items) {
                  return DropdownButtonFormField<int>(
                    initialValue: _categoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category_rounded),
                      helperText:
                          'Confirmed category choices build local merchant confidence.',
                    ),
                    items: items
                        .map((CategoryModel item) {
                          return DropdownMenuItem<int>(
                            value: item.id,
                            child: Text(item.name),
                          );
                        })
                        .toList(growable: false),
                    onChanged: (int? value) =>
                        setState(() => _categoryId = value),
                  );
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(22),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Transaction date',
                    prefixIcon: Icon(Icons.calendar_month_rounded),
                  ),
                  child: Text(transactionDayFormat.format(_timestamp)),
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
                    : Icon(
                        _isEditing
                            ? Icons.auto_fix_high_rounded
                            : Icons.check_rounded,
                      ),
                label: Text(_isEditing ? 'Save changes' : 'Save locally'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
