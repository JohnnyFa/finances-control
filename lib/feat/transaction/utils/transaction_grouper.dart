import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

class MonthTransactionGroup {
  final DateTime month;
  final int totalCents;
  final List<Transaction> transactions;

  const MonthTransactionGroup({
    required this.month,
    required this.totalCents,
    required this.transactions,
  });
}

class TransactionGrouper {
  static List<MonthTransactionGroup> groupByMonth(List<Transaction> transactions) {
    final groups = <String, List<Transaction>>{};

    for (final tx in transactions) {
      final key = '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}';
      groups.putIfAbsent(key, () => []).add(tx);
    }

    final entries = groups.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return entries.map((entry) {
      final monthTransactions = entry.value
        ..sort((a, b) => b.date.compareTo(a.date));

      var totalCents = 0;
      for (final tx in monthTransactions) {
        if (tx.type == TransactionType.income) {
          totalCents += tx.amount;
        } else {
          totalCents -= tx.amount.abs();
        }
      }

      return MonthTransactionGroup(
        month: DateTime(monthTransactions.first.date.year, monthTransactions.first.date.month),
        totalCents: totalCents,
        transactions: monthTransactions,
      );
    }).toList();
  }
}
