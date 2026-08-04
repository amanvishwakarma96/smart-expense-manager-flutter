import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final NumberFormat inrCurrency = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
);

final DateFormat transactionDateFormat = DateFormat('d MMM, h:mm a');

Color colorFromHex(String value) {
  final String normalized = value.replaceAll('#', '').padLeft(8, 'F');
  return Color(int.parse(normalized, radix: 16));
}
