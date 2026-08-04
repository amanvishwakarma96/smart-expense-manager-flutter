import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_parser_service.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

void main() {
  final SmsParserService parser = SmsParserService();

  group('SmsParserService', () {
    test('parses Indian debit alert', () {
      final result = parser.parse(
        sender: 'HDFCBK',
        receivedAt: DateTime(2026, 8, 4, 10, 30),
        body:
            'Rs.1,250.50 debited from A/c XX7788 at SWIGGY on 04-Aug. '
            'Ref 123456.',
      );

      expect(result, isNotNull);
      expect(result!.amount, 1250.50);
      expect(result.type, TransactionType.debit);
      expect(result.accountTail, '7788');
      expect(result.merchantName, 'SWIGGY');
    });

    test('parses UPI credit alert', () {
      final result = parser.parse(
        sender: 'SBIINB',
        body: 'INR 5,000 credited to account ending 4321 from AMAN via UPI.',
      );

      expect(result, isNotNull);
      expect(result!.amount, 5000);
      expect(result.type, TransactionType.credit);
      expect(result.accountTail, '4321');
      expect(result.merchantName, 'AMAN');
    });

    test('parses international card purchase', () {
      final result = parser.parse(
        sender: 'BANK',
        body: 'USD 42.75 spent on card ending 9021 at CLOUD HOSTING on 03 Aug.',
      );

      expect(result, isNotNull);
      expect(result!.amount, 42.75);
      expect(result.type, TransactionType.debit);
      expect(result.merchantName, 'CLOUD HOSTING');
    });

    test('rejects OTP messages', () {
      final result = parser.parse(
        sender: 'BANK',
        body: 'OTP 882211 for purchase of INR 2,000. Do not share it.',
      );

      expect(result, isNull);
    });

    test('rejects balance-only messages', () {
      final result = parser.parse(
        sender: 'BANK',
        body: 'Available balance in A/c XX7788 is INR 25,500.',
      );

      expect(result, isNull);
    });
  });
}
