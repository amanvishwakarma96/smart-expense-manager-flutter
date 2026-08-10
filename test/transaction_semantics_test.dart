import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_parser_service.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/services/transaction_category_classifier.dart';

void main() {
  const SmsParserService parser = SmsParserService();
  const TransactionCategoryClassifier classifier =
      TransactionCategoryClassifier();

  test('purpose semantics separate bank direction from financial meaning', () {
    expect(TransactionPurpose.income.countsAsIncome, isTrue);
    expect(TransactionPurpose.borrowed.countsAsIncome, isFalse);
    expect(TransactionPurpose.loanReceived.countsAsIncome, isFalse);
    expect(TransactionPurpose.transfer.countsAsIncome, isFalse);

    expect(TransactionPurpose.expense.countsAsSpending, isTrue);
    expect(TransactionPurpose.loanRepayment.countsAsSpending, isTrue);
    expect(TransactionPurpose.transfer.countsAsSpending, isFalse);
    expect(TransactionPurpose.investment.countsAsSpending, isFalse);
  });

  test('salary credit is income', () {
    final parsed = parser.parse(
      body: 'INR 52,000.00 credited to A/c XX1234 as salary for AUG.',
      sender: 'HDFCBK',
    );

    expect(parsed, isNotNull);
    expect(parsed!.type, TransactionType.credit);
    expect(parsed.purpose, TransactionPurpose.income);
  });

  test('loan disbursal credit is not income', () {
    final parsed = parser.parse(
      body: 'INR 150000 credited to account XX1234. Personal loan disbursed.',
      sender: 'BANK',
    );

    expect(parsed, isNotNull);
    expect(parsed!.type, TransactionType.credit);
    expect(parsed.purpose, TransactionPurpose.loanReceived);
    expect(parsed.purpose.countsAsIncome, isFalse);
  });

  test('generic UPI received credit is a transfer instead of income', () {
    final parsed = parser.parse(
      body: 'Rs. 2,500 credited to A/c XX1234 received from RAHUL via UPI.',
      sender: 'BANK',
    );

    expect(parsed, isNotNull);
    expect(parsed!.type, TransactionType.credit);
    expect(parsed.purpose, TransactionPurpose.transfer);
  });

  test('EMI debit is loan repayment spending', () {
    final parsed = parser.parse(
      body: 'INR 8,450 debited from A/c XX1234 towards EMI loan repayment.',
      sender: 'BANK',
    );

    expect(parsed, isNotNull);
    expect(parsed!.type, TransactionType.debit);
    expect(parsed.purpose, TransactionPurpose.loanRepayment);
    expect(parsed.purpose.countsAsSpending, isTrue);
  });

  test('refund credit is a refund rather than income', () {
    final parsed = parser.parse(
      body: 'Refund of INR 799 credited to A/c XX1234 for card purchase reversal.',
      sender: 'BANK',
    );

    expect(parsed, isNotNull);
    expect(parsed!.type, TransactionType.credit);
    expect(parsed.purpose, TransactionPurpose.refund);
    expect(parsed.purpose.countsAsIncome, isFalse);
  });

  test('local classifier maps common merchants and purposes', () {
    final List<CategoryModel> categories = <CategoryModel>[
      CategoryModel(id: 1, name: 'Food'),
      CategoryModel(id: 2, name: 'Income'),
      CategoryModel(id: 3, name: 'Loans & EMI'),
      CategoryModel(id: 4, name: 'Transfers'),
    ];

    final swiggy = parser.parse(
      body: 'Rs. 450 debited from A/c XX1234 at SWIGGY via UPI.',
      sender: 'BANK',
    );
    final salary = parser.parse(
      body: 'INR 50000 credited to A/c XX1234 as salary.',
      sender: 'BANK',
    );
    final emi = parser.parse(
      body: 'INR 8000 debited from A/c XX1234 towards EMI loan repayment.',
      sender: 'BANK',
    );
    final transfer = parser.parse(
      body: 'Rs. 1500 credited to A/c XX1234 received from AMAN via UPI.',
      sender: 'BANK',
    );

    expect(
      classifier.inferCategoryId(categories: categories, transaction: swiggy!),
      1,
    );
    expect(
      classifier.inferCategoryId(categories: categories, transaction: salary!),
      2,
    );
    expect(
      classifier.inferCategoryId(categories: categories, transaction: emi!),
      3,
    );
    expect(
      classifier.inferCategoryId(
        categories: categories,
        transaction: transfer!,
      ),
      4,
    );
  });
}
