import 'package:big_decimal/big_decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(BuildContext context, BigDecimal value) {
  final locale = Localizations.localeOf(context).toString();

  final formatter = NumberFormat.simpleCurrency(locale: locale);
  return formatter.format(value.toDouble());
}