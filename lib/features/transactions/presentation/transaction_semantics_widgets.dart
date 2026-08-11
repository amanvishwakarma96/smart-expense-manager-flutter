import 'package:flutter/material.dart';
import 'package:smart_expense_manager/core/theme/app_theme.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class TransactionPurposeField extends StatelessWidget {
  const TransactionPurposeField({
    required this.type,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final TransactionType type;
  final TransactionPurpose value;
  final ValueChanged<TransactionPurpose> onChanged;

  @override
  Widget build(BuildContext context) {
    final List<TransactionPurpose> purposes = transactionPurposesFor(type);
    final TransactionPurpose selected = purposes.contains(value)
        ? value
        : defaultTransactionPurpose(type);
    return DropdownButtonFormField<TransactionPurpose>(
      initialValue: selected,
      decoration: const InputDecoration(
        labelText: 'Purpose',
        prefixIcon: Icon(Icons.account_tree_rounded),
        helperText: 'Debit/Credit is the bank direction; purpose explains why.',
      ),
      items: purposes
          .map((TransactionPurpose purpose) {
            return DropdownMenuItem<TransactionPurpose>(
              value: purpose,
              child: Row(
                children: <Widget>[
                  Icon(transactionPurposeIcon(purpose), size: 19),
                  const SizedBox(width: 9),
                  Text(purpose.label),
                ],
              ),
            );
          })
          .toList(growable: false),
      onChanged: (TransactionPurpose? purpose) {
        if (purpose != null) {
          onChanged(purpose);
        }
      },
    );
  }
}

class TransactionSemanticChips extends StatelessWidget {
  const TransactionSemanticChips({
    required this.type,
    required this.purpose,
    this.compact = false,
    super.key,
  });

  final TransactionType type;
  final TransactionPurpose purpose;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final Color directionColor = type == TransactionType.debit
        ? AppPalette.peach
        : AppPalette.mint;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: <Widget>[
        _SemanticPill(
          label: type == TransactionType.debit ? 'DEBIT' : 'CREDIT',
          icon: type == TransactionType.debit
              ? Icons.north_east_rounded
              : Icons.south_west_rounded,
          color: directionColor,
          compact: compact,
        ),
        _SemanticPill(
          label: purpose.shortLabel,
          icon: transactionPurposeIcon(purpose),
          color: AppPalette.sky,
          compact: compact,
        ),
      ],
    );
  }
}

class _SemanticPill extends StatelessWidget {
  const _SemanticPill({
    required this.label,
    required this.icon,
    required this.color,
    required this.compact,
  });

  final String label;
  final IconData icon;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: compact ? 13 : 15),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w900,
              letterSpacing: typeLetterSpacing(label),
            ),
          ),
        ],
      ),
    );
  }

  double typeLetterSpacing(String value) {
    return value == 'DEBIT' || value == 'CREDIT' ? 0.6 : 0;
  }
}

IconData transactionPurposeIcon(TransactionPurpose purpose) {
  return switch (purpose) {
    TransactionPurpose.expense => Icons.shopping_bag_rounded,
    TransactionPurpose.income => Icons.payments_rounded,
    TransactionPurpose.transfer => Icons.swap_horiz_rounded,
    TransactionPurpose.borrowed => Icons.call_received_rounded,
    TransactionPurpose.lent => Icons.call_made_rounded,
    TransactionPurpose.lentRepayment => Icons.assignment_return_rounded,
    TransactionPurpose.loanReceived => Icons.account_balance_rounded,
    TransactionPurpose.loanRepayment => Icons.event_repeat_rounded,
    TransactionPurpose.refund => Icons.replay_rounded,
    TransactionPurpose.investment => Icons.trending_up_rounded,
    TransactionPurpose.cashWithdrawal => Icons.local_atm_rounded,
    TransactionPurpose.cashDeposit => Icons.savings_rounded,
    TransactionPurpose.other => Icons.more_horiz_rounded,
  };
}
