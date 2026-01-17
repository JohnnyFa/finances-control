import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatCurrency(BuildContext context, int value) {
  final locale = Localizations.localeOf(context).toString();

  final formatter = NumberFormat.simpleCurrency(locale: locale);
  return formatter.format(value.toDouble());
}

String formatCurrencyFromCents(BuildContext context, int cents) {
  final locale = Localizations.localeOf(context).toString();
  final formatter = NumberFormat.simpleCurrency(locale: locale);

  return formatter.format(cents / 100);
}