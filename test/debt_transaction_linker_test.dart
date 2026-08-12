import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/debts/services/debt_transaction_linker.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

void main() {
  test('borrowed and loan credits increase their matching owed ledger', () {
    expect(
      DebtTransactionLinker.movementFor(
        kind: DebtKind.borrowed,
        type: TransactionType.credit,
        purpose: TransactionPurpose.borrowed,
      ),
      DebtMovementType.increase,
    );
    expect(
      DebtTransactionLinker.movementFor(
        kind: DebtKind.loan,
        type: TransactionType.credit,
        purpose: TransactionPurpose.loanReceived,
      ),
      DebtMovementType.increase,
    );
  });

  test(
    'borrowed and formal loan incoming purposes are not interchangeable',
    () {
      expect(
        DebtTransactionLinker.movementFor(
          kind: DebtKind.borrowed,
          type: TransactionType.credit,
          purpose: TransactionPurpose.loanReceived,
        ),
        isNull,
      );
      expect(
        DebtTransactionLinker.movementFor(
          kind: DebtKind.loan,
          type: TransactionType.credit,
          purpose: TransactionPurpose.borrowed,
        ),
        isNull,
      );
    },
  );

  test('loan repayment decreases borrowed and loan balances', () {
    for (final DebtKind kind in <DebtKind>[DebtKind.borrowed, DebtKind.loan]) {
      expect(
        DebtTransactionLinker.movementFor(
          kind: kind,
          type: TransactionType.debit,
          purpose: TransactionPurpose.loanRepayment,
        ),
        DebtMovementType.decrease,
      );
    }
  });

  test('lent money and lent repayment move a receivable correctly', () {
    expect(
      DebtTransactionLinker.movementFor(
        kind: DebtKind.lent,
        type: TransactionType.debit,
        purpose: TransactionPurpose.lent,
      ),
      DebtMovementType.increase,
    );
    expect(
      DebtTransactionLinker.movementFor(
        kind: DebtKind.lent,
        type: TransactionType.credit,
        purpose: TransactionPurpose.lentRepayment,
      ),
      DebtMovementType.decrease,
    );
  });

  test('ordinary income or expenses cannot be linked to debt balances', () {
    expect(
      DebtTransactionLinker.movementFor(
        kind: DebtKind.loan,
        type: TransactionType.credit,
        purpose: TransactionPurpose.income,
      ),
      isNull,
    );
    expect(
      DebtTransactionLinker.movementFor(
        kind: DebtKind.lent,
        type: TransactionType.debit,
        purpose: TransactionPurpose.expense,
      ),
      isNull,
    );
  });
}
