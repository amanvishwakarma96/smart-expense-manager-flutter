enum DebtKind { borrowed, lent, loan }

enum DebtMovementType { increase, decrease }

extension DebtKindDetails on DebtKind {
  String get label => switch (this) {
    DebtKind.borrowed => 'Borrowed money',
    DebtKind.lent => 'Money lent',
    DebtKind.loan => 'Loan',
  };

  String get counterpartyLabel => switch (this) {
    DebtKind.borrowed => 'Borrowed from',
    DebtKind.lent => 'Lent to',
    DebtKind.loan => 'Lender',
  };

  bool get youOwe => this != DebtKind.lent;
}

class DebtLedgerEntry {
  const DebtLedgerEntry({
    required this.id,
    required this.debtId,
    required this.type,
    required this.amount,
    required this.occurredAt,
    required this.note,
    required this.createdAt,
    this.linkedTransactionId,
  });

  final int id;
  final int debtId;
  final DebtMovementType type;
  final double amount;
  final DateTime occurredAt;
  final String note;
  final DateTime createdAt;
  final int? linkedTransactionId;

  bool get isLinkedTransaction => linkedTransactionId != null;
}

class DebtAccount {
  const DebtAccount({
    required this.id,
    required this.kind,
    required this.counterparty,
    required this.openingBalance,
    required this.note,
    required this.reminderEnabled,
    required this.reminderDaysBefore,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
    required this.entries,
    this.dueDate,
  });

  final int id;
  final DebtKind kind;
  final String counterparty;
  final double openingBalance;
  final DateTime? dueDate;
  final String note;
  final bool reminderEnabled;
  final int reminderDaysBefore;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<DebtLedgerEntry> entries;

  double get addedBalance => entries
      .where((DebtLedgerEntry item) => item.type == DebtMovementType.increase)
      .fold(0, (double sum, DebtLedgerEntry item) => sum + item.amount);

  double get repaidBalance => entries
      .where((DebtLedgerEntry item) => item.type == DebtMovementType.decrease)
      .fold(0, (double sum, DebtLedgerEntry item) => sum + item.amount);

  double get totalObligation => openingBalance + addedBalance;

  double get outstanding {
    final double value = totalObligation - repaidBalance;
    return value < 0 ? 0 : value;
  }

  double get progress {
    if (totalObligation <= 0) {
      return 0;
    }
    final double value = repaidBalance / totalObligation;
    if (value < 0) {
      return 0;
    }
    if (value > 1) {
      return 1;
    }
    return value;
  }

  bool get isSettled => outstanding <= 0.01;
}
