import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class DateFormatter {
  static String monthYear(
      BuildContext context,
      DateTime date,
      ) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMM(locale).format(date);
  }
}