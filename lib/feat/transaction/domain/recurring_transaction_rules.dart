import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';

bool isActiveForMonth(RecurringTransaction r, int year, int month) {
  if (!r.active) return false;

  final occurrence = DateTime(year, month, r.dayOfMonth);
  final today = DateTime.now();

  final todayDate = DateTime(today.year, today.month, today.day);
  final occurrenceDate = DateTime(occurrence.year, occurrence.month, occurrence.day);
  final startDate = DateTime(r.startDate.year, r.startDate.month, r.startDate.day);
  final endDate = r.endDate != null
      ? DateTime(r.endDate!.year, r.endDate!.month, r.endDate!.day)
      : null;

  final isToday = occurrenceDate == todayDate;

  if (isToday && occurrenceDate == startDate) {
    return true;
  }

  if (occurrenceDate.isBefore(startDate)) {
    return false;
  }

  if (endDate != null && occurrenceDate.isAfter(endDate)) {
    return false;
  }

  return true;
}