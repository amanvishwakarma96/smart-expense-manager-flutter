import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';

void main() {
  test('outstanding balance includes increases and repayments', () {
    final DateTime now = DateTime(2026, 8, 11);
    final DebtAccount account = DebtAccount(
      id: 1,
      kind: DebtKind.loan,
      counterparty: 'Bank',
      openingBalance: 100000,
      note: '',
      reminderEnabled: false,
      reminderDaysBefore: 1,
      isArchived: false,
      createdAt: now,
      updatedAt: now,
      entries: <DebtLedgerEntry>[
        DebtLedgerEntry(
          id: 1,
          debtId: 1,
          type: DebtMovementType.increase,
          amount: 10000,
          occurredAt: now,
          note: '',
          createdAt: now,
        ),
        DebtLedgerEntry(
          id: 2,
          debtId: 1,
          type: DebtMovementType.decrease,
          amount: 25000,
          occurredAt: now,
          note: '',
          createdAt: now,
        ),
      ],
    );

    expect(account.totalObligation, 110000);
    expect(account.repaidBalance, 25000);
    expect(account.outstanding, 85000);
    expect(account.progress, closeTo(25000 / 110000, 0.0001));
    expect(account.isSettled, isFalse);
  });

  test('outstanding never becomes negative after an overpayment', () {
    final DateTime now = DateTime(2026, 8, 11);
    final DebtAccount account = DebtAccount(
      id: 1,
      kind: DebtKind.borrowed,
      counterparty: 'Friend',
      openingBalance: 1000,
      note: '',
      reminderEnabled: false,
      reminderDaysBefore: 1,
      isArchived: false,
      createdAt: now,
      updatedAt: now,
      entries: <DebtLedgerEntry>[
        DebtLedgerEntry(
          id: 1,
          debtId: 1,
          type: DebtMovementType.decrease,
          amount: 1200,
          occurredAt: now,
          note: '',
          createdAt: now,
        ),
      ],
    );

    expect(account.outstanding, 0);
    expect(account.progress, 1);
    expect(account.isSettled, isTrue);
  });
}
