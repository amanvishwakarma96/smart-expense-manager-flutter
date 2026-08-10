import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/transactions/services/duplicate_transaction_detector.dart';

void main() {
  const DuplicateTransactionDetector detector = DuplicateTransactionDetector();
  final DateTime baseTime = DateTime(2026, 8, 10, 12);

  DuplicateTransactionCandidate candidate({
    int id = 7,
    double amount = 499,
    String merchant = 'SWIGGY',
    String accountTail = '7788',
    DateTime? timestamp,
  }) {
    return DuplicateTransactionCandidate(
      id: id,
      amount: amount,
      merchant: merchant,
      accountTail: accountTail,
      timestamp: timestamp ?? baseTime,
    );
  }

  test('flags an exact duplicate', () {
    final int? duplicate = detector.findPossibleDuplicate(
      amount: 499,
      merchant: 'swiggy',
      accountTail: '7788',
      timestamp: baseTime.add(const Duration(minutes: 2)),
      existing: <DuplicateTransactionCandidate>[candidate()],
    );

    expect(duplicate, 7);
  });

  test('flags a near duplicate with rupee rounding and merchant typo', () {
    final int? duplicate = detector.findPossibleDuplicate(
      amount: 500,
      merchant: 'NETFLIXX',
      accountTail: '7788',
      timestamp: baseTime.add(const Duration(minutes: 1)),
      existing: <DuplicateTransactionCandidate>[
        candidate(amount: 499, merchant: 'Netflix'),
      ],
    );

    expect(duplicate, 7);
  });

  test('does not flag a matching transaction from a different account', () {
    final int? duplicate = detector.findPossibleDuplicate(
      amount: 499,
      merchant: 'SWIGGY',
      accountTail: '1122',
      timestamp: baseTime.add(const Duration(minutes: 1)),
      existing: <DuplicateTransactionCandidate>[candidate()],
    );

    expect(duplicate, isNull);
  });

  test('five-minute boundary is inclusive and anything later is ignored', () {
    expect(
      detector.findPossibleDuplicate(
        amount: 499,
        merchant: 'SWIGGY',
        accountTail: '7788',
        timestamp: baseTime.add(const Duration(minutes: 5)),
        existing: <DuplicateTransactionCandidate>[candidate()],
      ),
      7,
    );
    expect(
      detector.findPossibleDuplicate(
        amount: 499,
        merchant: 'SWIGGY',
        accountTail: '7788',
        timestamp: baseTime.add(
          const Duration(minutes: 5, milliseconds: 1),
        ),
        existing: <DuplicateTransactionCandidate>[candidate()],
      ),
      isNull,
    );
  });
}
