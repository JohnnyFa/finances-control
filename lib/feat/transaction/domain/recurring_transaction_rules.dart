import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';

bool isActiveForMonth(RecurringTransaction r, int year, int month) {
  final monthStart = DateTime(year, month, 1);
  final monthEnd = DateTime(year, month + 1, 0);

  final startDate = DateTime(
    r.startDate.year,
    r.startDate.month,
    r.startDate.day,
  );

  if (monthEnd.isBefore(startDate)) {
    return false;
  }

  if (r.endDate != null) {
    final endDate = DateTime(r.endDate!.year, r.endDate!.month, r.endDate!.day);

    if (monthStart.isAfter(endDate)) {
      return false;
    }
  }

  return r.active;
}
