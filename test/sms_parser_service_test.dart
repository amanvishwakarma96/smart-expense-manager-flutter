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

    test('parses VPA UPI debit with rupee slash notation', () {
      final result = parser.parse(
        sender: 'ICICIB',
        body: 'Rs.799/- debited from A/c XX1122 and paid to VPA '
            'swiggy@upi via UPI. Ref 918273.',
      );

      expect(result, isNotNull);
      expect(result!.amount, 799);
      expect(result.type, TransactionType.debit);
      expect(result.accountTail, '1122');
      expect(result.merchantName, 'swiggy@upi');
    });

    test('parses slash-delimited UPI merchant reference', () {
      final result = parser.parse(
        sender: 'AXISBK',
        body: 'Rs.125 debited from A/c 1234. UPI/P2M/991122/TEA SHOP/Ref.',
      );

      expect(result, isNotNull);
      expect(result!.type, TransactionType.debit);
      expect(result.merchantName, 'TEA SHOP');
    });

    test('parses ATM cash withdrawal', () {
      final result = parser.parse(
        sender: 'KOTAKB',
        body: 'INR 2,000 withdrawn from account no. 4321 at HDFC ATM '
            'on 05-Aug. Available balance INR 8,500.',
      );

      expect(result, isNotNull);
      expect(result!.amount, 2000);
      expect(result.type, TransactionType.debit);
      expect(result.accountTail, '4321');
      expect(result.merchantName, 'HDFC ATM');
    });

    test('parses incoming NEFT transfer', () {
      final result = parser.parse(
        sender: 'YESBNK',
        body: 'A/c XX9876 credited with INR 25,000 from ACME PRIVATE '
            'LIMITED through NEFT.',
      );

      expect(result, isNotNull);
      expect(result!.amount, 25000);
      expect(result.type, TransactionType.credit);
      expect(result.accountTail, '9876');
      expect(result.merchantName, 'ACME PRIVATE LIMITED');
    });

    test('classifies card reversal as credit', () {
      final result = parser.parse(
        sender: 'BANK',
        body: 'A purchase of INR 499 on card ending with 7788 was reversed '
            'and credited as refund from AMAZON via CARD.',
      );

      expect(result, isNotNull);
      expect(result!.amount, 499);
      expect(result.type, TransactionType.credit);
      expect(result.accountTail, '7788');
      expect(result.merchantName, 'AMAZON');
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

    test('rejects declined transactions', () {
      final result = parser.parse(
        sender: 'BANK',
        body: 'Transaction of INR 500 declined due to insufficient balance.',
      );

      expect(result, isNull);
    });
  });
}
