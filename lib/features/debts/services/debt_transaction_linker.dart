import 'package:smart_expense_manager/features/debts/domain/debt_account.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class DebtTransactionLinker {
  const DebtTransactionLinker._();

  static DebtMovementType? movementFor({
    required DebtKind kind,
    required TransactionType type,
    required TransactionPurpose purpose,
  }) {
    if (kind == DebtKind.lent) {
      if (type == TransactionType.debit && purpose == TransactionPurpose.lent) {
        return DebtMovementType.increase;
      }
      if (type == TransactionType.credit &&
          purpose == TransactionPurpose.lentRepayment) {
        return DebtMovementType.decrease;
      }
      return null;
    }

    if (kind == DebtKind.borrowed &&
        type == TransactionType.credit &&
        purpose == TransactionPurpose.borrowed) {
      return DebtMovementType.increase;
    }
    if (kind == DebtKind.loan &&
        type == TransactionType.credit &&
        purpose == TransactionPurpose.loanReceived) {
      return DebtMovementType.increase;
    }
    if (type == TransactionType.debit &&
        purpose == TransactionPurpose.loanRepayment) {
      return DebtMovementType.decrease;
    }
    return null;
  }
}
