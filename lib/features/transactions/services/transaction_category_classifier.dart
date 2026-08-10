import 'package:smart_expense_manager/features/sms_engine/domain/parsed_transaction.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class TransactionCategoryClassifier {
  const TransactionCategoryClassifier();

  int? inferCategoryId({
    required List<CategoryModel> categories,
    required ParsedTransaction transaction,
  }) {
    final String? categoryName = inferCategoryName(transaction);
    if (categoryName == null) {
      return null;
    }
    final String normalizedTarget = categoryName.toLowerCase();
    for (final CategoryModel category in categories) {
      if (category.name.trim().toLowerCase() == normalizedTarget) {
        return category.id;
      }
    }
    return null;
  }

  String? inferCategoryName(ParsedTransaction transaction) {
    final String text = '${transaction.merchantName} ${transaction.originalText}'
        .toLowerCase();

    switch (transaction.purpose) {
      case TransactionPurpose.income:
        return 'Income';
      case TransactionPurpose.loanRepayment:
        return 'Loans & EMI';
      case TransactionPurpose.loanReceived:
      case TransactionPurpose.borrowed:
      case TransactionPurpose.lent:
      case TransactionPurpose.transfer:
      case TransactionPurpose.cashWithdrawal:
      case TransactionPurpose.cashDeposit:
        return 'Transfers';
      case TransactionPurpose.investment:
        return 'Investments';
      case TransactionPurpose.expense:
      case TransactionPurpose.refund:
      case TransactionPurpose.other:
        break;
    }

    if (_containsAny(text, const <String>[
      'swiggy',
      'zomato',
      'restaurant',
      'cafe',
      'coffee',
      'dominos',
      'pizza',
      'food court',
    ])) {
      return 'Food';
    }
    if (_containsAny(text, const <String>[
      'blinkit',
      'zepto',
      'bigbasket',
      'dmart',
      'grocery',
      'groceries',
      'supermarket',
      'super market',
    ])) {
      return 'Groceries';
    }
    if (_containsAny(text, const <String>[
      'uber',
      'ola',
      'rapido',
      'metro',
      'fastag',
      'petrol',
      'diesel',
      'fuel',
      'parking',
      'toll',
    ])) {
      return 'Transport';
    }
    if (_containsAny(text, const <String>[
      'amazon',
      'flipkart',
      'myntra',
      'ajio',
      'meesho',
      'shopping',
      'retail',
    ])) {
      return 'Shopping';
    }
    if (_containsAny(text, const <String>[
      'airtel',
      'jio',
      'vodafone',
      'vi recharge',
      'bsnl',
      'electricity',
      'broadband',
      'mobile recharge',
      'utility bill',
      'water bill',
      'gas bill',
      'billpay',
      'bill payment',
    ])) {
      return 'Bills';
    }
    if (_containsAny(text, const <String>[
      'pharmacy',
      'medical',
      'hospital',
      'clinic',
      'apollo',
      'medplus',
      'diagnostic',
      'doctor',
    ])) {
      return 'Health';
    }
    if (_containsAny(text, const <String>[
      'house rent',
      'rent payment',
      'society maintenance',
      'apartment maintenance',
      'housing',
    ])) {
      return 'Housing';
    }
    if (_containsAny(text, const <String>[
      'netflix',
      'spotify',
      'hotstar',
      'prime video',
      'bookmyshow',
      'pvr',
      'inox',
      'cinema',
    ])) {
      return 'Entertainment';
    }
    if (_containsAny(text, const <String>[
      'makemytrip',
      'goibibo',
      'cleartrip',
      'irctc',
      'airways',
      'airlines',
      'flight',
      'hotel',
      'oyo',
    ])) {
      return 'Travel';
    }
    if (_containsAny(text, const <String>[
      'school fee',
      'college fee',
      'tuition',
      'course fee',
      'udemy',
      'coursera',
      'education',
    ])) {
      return 'Education';
    }
    if (_containsAny(text, const <String>[
      'mutual fund',
      'zerodha',
      'groww',
      'upstox',
      'demat',
      'sip ',
      'investment',
    ])) {
      return 'Investments';
    }
    if (_containsAny(text, const <String>[
      'loan repayment',
      'loan instalment',
      'loan installment',
      ' emi ',
      'emi payment',
    ])) {
      return 'Loans & EMI';
    }

    if (transaction.purpose == TransactionPurpose.refund) {
      return 'Other';
    }
    if (transaction.type == TransactionType.credit) {
      return 'Transfers';
    }
    return 'Other';
  }

  bool _containsAny(String text, List<String> signals) {
    return signals.any(text.contains);
  }
}
