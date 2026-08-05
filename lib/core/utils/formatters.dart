import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String defaultCurrencyCode = 'INR';
const String defaultCurrencySymbol = '₹';
const String defaultCurrencyLocale = 'en_IN';

final NumberFormat inrCurrency = NumberFormat.currency(
  locale: defaultCurrencyLocale,
  symbol: defaultCurrencySymbol,
  decimalDigits: 0,
);

final NumberFormat inrCurrencyWithPaise = NumberFormat.currency(
  locale: defaultCurrencyLocale,
  symbol: defaultCurrencySymbol,
  decimalDigits: 2,
);

final DateFormat transactionDateFormat = DateFormat('d MMM, h:mm a');
final DateFormat transactionDayFormat = DateFormat('EEE, d MMM');
final DateFormat monthYearFormat = DateFormat('MMMM yyyy');

Color colorFromHex(String value) {
  final String normalized = value.replaceAll('#', '').padLeft(8, 'F');
  return Color(int.parse(normalized, radix: 16));
}
