import 'package:big_decimal/big_decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(BuildContext context, BigDecimal value) {
  final locale = Localizations.localeOf(context).toString();

  final formatter = NumberFormat.simpleCurrency(locale: locale);
  return formatter.format(value.toDouble());
}

int bigDecimalToCents(BigDecimal value) {
  return (value.toDouble() * 100).round();
}

String formatCurrencyFromCents(BuildContext context, int cents) {
  final locale = Localizations.localeOf(context).toString();
  final formatter = NumberFormat.simpleCurrency(locale: locale);

  return formatter.format(cents / 100);
}