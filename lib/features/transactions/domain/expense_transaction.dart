enum TransactionType { debit, credit }

enum TransactionPurpose {
  expense,
  income,
  transfer,
  borrowed,
  lent,
  loanReceived,
  loanRepayment,
  refund,
  investment,
  cashWithdrawal,
  cashDeposit,
  other,
}

enum TransactionStatus { pending, confirmed }

extension TransactionPurposeDetails on TransactionPurpose {
  String get label => switch (this) {
    TransactionPurpose.expense => 'Expense',
    TransactionPurpose.income => 'Income',
    TransactionPurpose.transfer => 'Transfer',
    TransactionPurpose.borrowed => 'Borrowed money',
    TransactionPurpose.lent => 'Lent money',
    TransactionPurpose.loanReceived => 'Loan received',
    TransactionPurpose.loanRepayment => 'Loan / EMI payment',
    TransactionPurpose.refund => 'Refund / reversal',
    TransactionPurpose.investment => 'Investment',
    TransactionPurpose.cashWithdrawal => 'Cash withdrawal',
    TransactionPurpose.cashDeposit => 'Cash deposit',
    TransactionPurpose.other => 'Other',
  };

  String get shortLabel => switch (this) {
    TransactionPurpose.borrowed => 'Borrowed',
    TransactionPurpose.loanReceived => 'Loan received',
    TransactionPurpose.loanRepayment => 'Loan / EMI',
    TransactionPurpose.cashWithdrawal => 'Cash out',
    TransactionPurpose.cashDeposit => 'Cash in',
    TransactionPurpose.refund => 'Refund',
    _ => label,
  };

  bool get countsAsIncome => this == TransactionPurpose.income;

  bool get countsAsSpending =>
      this == TransactionPurpose.expense ||
      this == TransactionPurpose.loanRepayment;

  bool get countsAgainstBudget => countsAsSpending;
}

List<TransactionPurpose> transactionPurposesFor(TransactionType type) {
  return switch (type) {
    TransactionType.debit => const <TransactionPurpose>[
      TransactionPurpose.expense,
      TransactionPurpose.transfer,
      TransactionPurpose.lent,
      TransactionPurpose.loanRepayment,
      TransactionPurpose.investment,
      TransactionPurpose.cashWithdrawal,
      TransactionPurpose.other,
    ],
    TransactionType.credit => const <TransactionPurpose>[
      TransactionPurpose.income,
      TransactionPurpose.transfer,
      TransactionPurpose.borrowed,
      TransactionPurpose.loanReceived,
      TransactionPurpose.refund,
      TransactionPurpose.cashDeposit,
      TransactionPurpose.other,
    ],
  };
}

TransactionPurpose defaultTransactionPurpose(TransactionType type) {
  return type == TransactionType.debit
      ? TransactionPurpose.expense
      : TransactionPurpose.income;
}

TransactionPurpose transactionPurposeFromCode(
  String? code,
  TransactionType type,
) {
  if (code != null && code.isNotEmpty) {
    for (final TransactionPurpose purpose in TransactionPurpose.values) {
      if (purpose.name == code) {
        return purpose;
      }
    }
  }
  return defaultTransactionPurpose(type);
}

class ExpenseTransaction {
  const ExpenseTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.merchant,
    required this.timestamp,
    required this.status,
    required this.accountTail,
    required this.originalSmsText,
    TransactionPurpose? purpose,
    this.categoryId,
    this.possibleDuplicateOf,
    this.isManual = false,
    this.isRecurring = false,
  }) : purpose =
           purpose ??
           (type == TransactionType.debit
               ? TransactionPurpose.expense
               : TransactionPurpose.income);

  final int id;
  final double amount;
  final TransactionType type;
  final TransactionPurpose purpose;
  final String merchant;
  final DateTime timestamp;
  final int? categoryId;
  final TransactionStatus status;
  final String accountTail;
  final String originalSmsText;
  final int? possibleDuplicateOf;
  final bool isManual;
  final bool isRecurring;

  bool get isDebit => type == TransactionType.debit;
  bool get isCredit => type == TransactionType.credit;
  bool get countsAsIncome => purpose.countsAsIncome;
  bool get countsAsSpending => purpose.countsAsSpending;
  bool get countsAgainstBudget => purpose.countsAgainstBudget;
}
