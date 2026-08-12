import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_repayment_plan.dart';

class RepaymentPlanEditorScreen extends ConsumerStatefulWidget {
  const RepaymentPlanEditorScreen({
    super.key,
    required this.account,
    this.existingPlan,
  });

  final DebtAccount account;
  final DebtRepaymentPlan? existingPlan;

  @override
  ConsumerState<RepaymentPlanEditorScreen> createState() =>
      _RepaymentPlanEditorScreenState();
}

class _RepaymentPlanEditorScreenState
    extends ConsumerState<RepaymentPlanEditorScreen> {
  static final DateFormat _dateFormat = DateFormat('d MMM yyyy');

  late final TextEditingController _amountController;
  late final TextEditingController _rateController;
  late RepaymentCadence _cadence;
  late DateTime _firstDueDate;
  bool _saving = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    final DebtRepaymentPlan? existing = widget.existingPlan;
    _cadence = existing?.cadence ?? RepaymentCadence.monthly;
    _amountController = TextEditingController(
      text: existing == null ? '' : existing.installmentAmount.toStringAsFixed(0),
    );
    _rateController = TextEditingController(
      text: existing == null || existing.annualInterestRatePct == 0
          ? ''
          : existing.annualInterestRatePct.toStringAsFixed(2),
    );
    final DateTime today = _today();
    final DateTime candidate = existing?.firstDueDate ?? _defaultDueDate(today);
    _firstDueDate = candidate.isBefore(today) ? _defaultDueDate(today) : candidate;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  DateTime _today() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _defaultDueDate(DateTime today) {
    if (_cadence == RepaymentCadence.weekly) {
      return today.add(const Duration(days: 7));
    }
    final int rawMonth = today.month;
    final int year = today.year + rawMonth ~/ 12;
    final int month = rawMonth % 12 + 1;
    final int lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, math.min(today.day, lastDay));
  }

  Future<void> _pickFirstDueDate() async {
    final DateTime today = _today();
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _firstDueDate.isBefore(today) ? today : _firstDueDate,
      firstDate: today,
      lastDate: DateTime(today.year + 20),
    );
    if (selected != null && mounted) {
      setState(() => _firstDueDate = selected);
    }
  }

  Future<void> _save() async {
    final double? amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', ''),
    );
    final String rawRate = _rateController.text.trim();
    final double? rate = rawRate.isEmpty ? 0 : double.tryParse(rawRate);
    if (amount == null || amount <= 0) {
      setState(() => _errorText = 'Enter an installment amount above zero.');
      return;
    }
    if (rate == null || rate < 0 || rate > 100) {
      setState(() => _errorText = 'APR must be between 0% and 100%.');
      return;
    }
    if (_firstDueDate.isBefore(_today())) {
      setState(() => _errorText = 'Choose today or a future first due date.');
      return;
    }

    setState(() {
      _saving = true;
      _errorText = null;
    });
    try {
      await ref.read(debtRepaymentPlanRepositoryProvider).save(
            debtId: widget.account.id,
            cadence: _cadence,
            installmentAmount: amount,
            annualInterestRatePct: rate,
            firstDueDate: _firstDueDate,
            startingOutstanding: widget.account.outstanding,
            baselineRepaidAmount: widget.account.repaidBalance,
          );
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } on Object catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _errorText = 'Could not save this repayment plan: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool editing = widget.existingPlan != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? 'Edit repayment plan' : 'Plan repayments')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            const Text(
              'This is a local planning tool. Saving a plan does not create an EMI transaction, mark a repayment paid, or change the debt balance.',
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<RepaymentCadence>(
              initialValue: _cadence,
              decoration: const InputDecoration(labelText: 'Cadence'),
              items: RepaymentCadence.values
                  .map(
                    (RepaymentCadence cadence) => DropdownMenuItem<RepaymentCadence>(
                      value: cadence,
                      child: Text(cadence.label),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (RepaymentCadence? value) {
                if (value == null) {
                  return;
                }
                setState(() {
                  _cadence = value;
                  if (!editing) {
                    _firstDueDate = _defaultDueDate(_today());
                  }
                });
              },
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Planned installment',
                prefixText: '₹ ',
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _rateController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Annual interest rate (optional)',
                suffixText: '% APR',
                helperText:
                    'Used only for an estimated principal/interest split. Leave blank for a zero-interest plan.',
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _pickFirstDueDate,
              icon: const Icon(Icons.event_rounded),
              label: Text('First due ${_dateFormat.format(_firstDueDate)}'),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  editing
                      ? 'Saving changes replans from the current outstanding balance and current repayment total. Past bank transactions and ledger entries remain untouched.'
                      : 'The plan starts from the current outstanding balance. Record or link real repayments separately in the debt ledger.',
                ),
              ),
            ),
            if (_errorText != null) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                _errorText!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const SizedBox(height: 22),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.calculate_rounded),
              label: Text(editing ? 'Replan from current balance' : 'Save plan'),
            ),
          ],
        ),
      ),
    );
  }
}
