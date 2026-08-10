import 'package:smart_expense_manager/features/sms_engine/domain/parsed_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class SmsParserService {
  static final RegExp _amountPrefix = RegExp(
    r'(?:INR|Rs\.?|₹|USD|\$)\s*[:\-]?\s*'
    r'([\d,]+(?:\.\d{1,2})?)(?:/-)?',
    caseSensitive: false,
  );
  static final RegExp _amountSuffix = RegExp(
    r'([\d,]+(?:\.\d{1,2})?)(?:/-)?\s*(?:INR|USD)\b',
    caseSensitive: false,
  );
  static final RegExp _accountTail = RegExp(
    r'(?:a/c|acct|account|card)'
    r'(?:\s*(?:no\.?|number|ending(?:\s+(?:in|with))?|xx|x)?)?'
    r'[\s:*x#-]*([0-9]{3,4})\b',
    caseSensitive: false,
  );

  static const List<String> _debitSignals = <String>[
    'debited',
    'spent',
    'purchase',
    'withdrawn',
    'withdrawal',
    'paid',
    'sent',
    'dr.',
    'debit card',
    'transferred from',
    'cash withdrawal',
  ];

  static const List<String> _creditSignals = <String>[
    'credited',
    'received',
    'deposited',
    'refund',
    'reversed',
    'reversal',
    'cr.',
    'cash deposit',
    'money added',
  ];

  static const List<String> _incomeSignals = <String>[
    'salary',
    'payroll',
    'stipend',
    'pension',
    'dividend',
    'interest credited',
    'interest payment',
    'cashback',
    'cash back',
    'reward credited',
    'bonus credited',
  ];

  static const List<String> _loanReceivedSignals = <String>[
    'loan disbursed',
    'loan amount credited',
    'loan credited',
    'loan proceeds',
    'personal loan credited',
  ];

  static const List<String> _loanRepaymentSignals = <String>[
    'emi',
    'loan repayment',
    'loan instalment',
    'loan installment',
    'loan recovery',
  ];

  static const List<String> _investmentSignals = <String>[
    'mutual fund',
    'sip',
    'investment',
    'zerodha',
    'groww',
    'upstox',
    'demat',
  ];

  ParsedTransaction? parse({
    required String body,
    String? sender,
    DateTime? receivedAt,
  }) {
    final String compact = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (compact.isEmpty || !_looksFinancial(compact)) {
      return null;
    }

    final TransactionType? type = _detectType(compact);
    if (type == null) {
      return null;
    }

    final double? amount = _extractAmount(compact);
    if (amount == null || amount <= 0) {
      return null;
    }

    final String merchant = _extractMerchant(compact, sender: sender);
    final String accountTail = _extractAccountTail(compact);
    final TransactionPurpose purpose = _detectPurpose(
      compact,
      type: type,
      merchant: merchant,
    );
    final double confidence = _confidence(
      merchant: merchant,
      accountTail: accountTail,
      text: compact,
    );

    return ParsedTransaction(
      amount: amount,
      type: type,
      purpose: purpose,
      merchantName: merchant,
      accountTail: accountTail,
      timestamp: receivedAt ?? DateTime.now(),
      originalText: body,
      sender: sender?.trim() ?? '',
      confidence: confidence,
    );
  }

  bool _looksFinancial(String text) {
    final String lower = text.toLowerCase();
    if (lower.contains('otp') ||
        lower.contains('one time password') ||
        lower.contains('verification code') ||
        lower.contains('do not share this code')) {
      return false;
    }
    final bool hasAmount =
        _amountPrefix.hasMatch(text) || _amountSuffix.hasMatch(text);
    final bool hasSignal = <String>[
      ..._debitSignals,
      ..._creditSignals,
    ].any(lower.contains);
    return hasAmount && hasSignal;
  }

  TransactionType? _detectType(String text) {
    final String lower = text.toLowerCase();
    if (lower.contains('refund') ||
        lower.contains('reversed') ||
        lower.contains('reversal')) {
      return TransactionType.credit;
    }

    final bool debit = _debitSignals.any(lower.contains);
    final bool credit = _creditSignals.any(lower.contains);

    if (debit && !credit) {
      return TransactionType.debit;
    }
    if (credit && !debit) {
      return TransactionType.credit;
    }

    final int debitIndex = _firstSignalIndex(lower, _debitSignals);
    final int creditIndex = _firstSignalIndex(lower, _creditSignals);
    if (debitIndex == -1 && creditIndex == -1) {
      return null;
    }
    if (debitIndex == -1) {
      return TransactionType.credit;
    }
    if (creditIndex == -1) {
      return TransactionType.debit;
    }
    return debitIndex < creditIndex
        ? TransactionType.debit
        : TransactionType.credit;
  }

  TransactionPurpose _detectPurpose(
    String text, {
    required TransactionType type,
    required String merchant,
  }) {
    final String lower = text.toLowerCase();
    final String merchantLower = merchant.toLowerCase();

    if (type == TransactionType.credit &&
        (lower.contains('refund') ||
            lower.contains('reversed') ||
            lower.contains('reversal'))) {
      return TransactionPurpose.refund;
    }
    if (type == TransactionType.debit &&
        (lower.contains('cash withdrawal') || lower.contains('withdrawn at atm'))) {
      return TransactionPurpose.cashWithdrawal;
    }
    if (type == TransactionType.credit && lower.contains('cash deposit')) {
      return TransactionPurpose.cashDeposit;
    }
    if (type == TransactionType.credit &&
        _loanReceivedSignals.any(lower.contains)) {
      return TransactionPurpose.loanReceived;
    }
    if (type == TransactionType.credit &&
        (lower.contains('borrowed') || lower.contains('borrow from'))) {
      return TransactionPurpose.borrowed;
    }
    if (type == TransactionType.debit &&
        (lower.contains('lent to') || lower.contains('loaned to'))) {
      return TransactionPurpose.lent;
    }
    if (type == TransactionType.debit &&
        _loanRepaymentSignals.any(lower.contains)) {
      return TransactionPurpose.loanRepayment;
    }
    if (type == TransactionType.debit &&
        (_investmentSignals.any(lower.contains) ||
            _investmentSignals.any(merchantLower.contains))) {
      return TransactionPurpose.investment;
    }
    if (type == TransactionType.credit && _incomeSignals.any(lower.contains)) {
      return TransactionPurpose.income;
    }

    final bool explicitTransfer =
        lower.contains('fund transfer') ||
        lower.contains('transferred to') ||
        lower.contains('transferred from') ||
        lower.contains('self transfer') ||
        lower.contains('own account transfer');
    if (explicitTransfer) {
      return TransactionPurpose.transfer;
    }

    if (type == TransactionType.credit &&
        (lower.contains('received from') ||
            RegExp(r'\b(?:UPI|IMPS|NEFT|RTGS)\b', caseSensitive: false)
                .hasMatch(text))) {
      return TransactionPurpose.transfer;
    }

    return type == TransactionType.debit
        ? TransactionPurpose.expense
        : TransactionPurpose.other;
  }

  int _firstSignalIndex(String text, List<String> signals) {
    int earliest = -1;
    for (final String signal in signals) {
      final int index = text.indexOf(signal);
      if (index >= 0 && (earliest == -1 || index < earliest)) {
        earliest = index;
      }
    }
    return earliest;
  }

  double? _extractAmount(String text) {
    final RegExpMatch? match =
        _amountPrefix.firstMatch(text) ?? _amountSuffix.firstMatch(text);
    final String? raw = match?.group(1)?.replaceAll(',', '');
    return raw == null ? null : double.tryParse(raw);
  }

  String _extractAccountTail(String text) {
    return _accountTail.firstMatch(text)?.group(1) ?? '';
  }

  String _extractMerchant(String text, {String? sender}) {
    final List<RegExp> patterns = <RegExp>[
      RegExp(
        r"\bfrom\s+([A-Za-z0-9][A-Za-z0-9 .&@'_-]{1,48}?)"
        r"\s+(?:via|through)\s+(?:UPI|IMPS|NEFT|RTGS|CARD)\b",
        caseSensitive: false,
      ),
      RegExp(
        r"\b(?:paid|sent|transferred)\s+to\s+"
        r"(?:VPA\s+)?([A-Za-z0-9][A-Za-z0-9 .&@'_-]{1,48}?)"
        r"(?=\s+(?:via|through|using|on|ref|txn|upi)|[.,]|$)",
        caseSensitive: false,
      ),
      RegExp(
        r"\bto\s+(?!account\b|a/c\b|acct\b|card\b)"
        r"(?:VPA\s+)?([A-Za-z0-9][A-Za-z0-9 .&@'_-]{1,48}?)"
        r"(?=\s+(?:via|through|using|on|ref|txn|upi|imps|neft|rtgs)|[.,]|$)",
        caseSensitive: false,
      ),
      RegExp(
        r"\b(?:at|merchant|payee|towards)[:\s-]+"
        r"([A-Za-z0-9][A-Za-z0-9 .&@'_-]{1,48}?)"
        r"(?=\s+(?:on|via|using|ref|txn|avl|available)|[.,]|$)",
        caseSensitive: false,
      ),
      RegExp(
        r'\b(?:UPI|VPA)[:\s-]+([A-Za-z0-9._-]+@[A-Za-z0-9.-]+)',
        caseSensitive: false,
      ),
      RegExp(
        r'\bUPI/(?:P2[PM]/)?(?:\d+/)?'
        r"([A-Za-z][A-Za-z0-9 .&@'_-]{1,48})(?=/|[.,]|$)",
        caseSensitive: false,
      ),
      RegExp(
        r"\b(?:info|remarks)[:\s-]+"
        r"([A-Za-z][A-Za-z0-9 .&@'_-]{1,48})(?=[.,]|$)",
        caseSensitive: false,
      ),
    ];

    for (final RegExp pattern in patterns) {
      final String? candidate = pattern.firstMatch(text)?.group(1)?.trim();
      if (candidate != null && candidate.isNotEmpty) {
        return _cleanMerchant(candidate);
      }
    }

    final String lower = text.toLowerCase();
    if (lower.contains('atm') || lower.contains('cash withdrawal')) {
      return 'ATM cash withdrawal';
    }
    if (lower.contains('upi')) {
      return 'UPI transaction';
    }
    if (lower.contains('imps') ||
        lower.contains('neft') ||
        lower.contains('rtgs')) {
      return 'Bank transfer';
    }
    if (lower.contains('card')) {
      return 'Card transaction';
    }

    final String senderValue = sender?.trim() ?? '';
    return senderValue.isEmpty ? 'Bank transaction' : senderValue;
  }

  String _cleanMerchant(String value) {
    return value
        .replaceFirst(RegExp(r'^VPA\s+', caseSensitive: false), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[-:,.]+$'), '')
        .trim();
  }

  double _confidence({
    required String merchant,
    required String accountTail,
    required String text,
  }) {
    double score = 0.55;
    if (merchant != 'Bank transaction') {
      score += 0.2;
    }
    if (accountTail.isNotEmpty) {
      score += 0.1;
    }
    if (RegExp(
      r'\b(?:UPI|IMPS|NEFT|RTGS|ATM|card|a/c)\b',
      caseSensitive: false,
    ).hasMatch(text)) {
      score += 0.1;
    }
    return score.clamp(0, 0.95).toDouble();
  }
}
