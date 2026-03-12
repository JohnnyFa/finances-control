import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';

bool isActiveForMonth(RecurringTransaction r, int year, int month) {
  if (!r.active) return false;

  final occurrence = DateTime(year, month, r.dayOfMonth);

  if (occurrence.isBefore(r.startDate)) {
    return false;
  }

  if (r.endDate != null && occurrence.isAfter(r.endDate!)) {
    return false;
  }

  return true;
}