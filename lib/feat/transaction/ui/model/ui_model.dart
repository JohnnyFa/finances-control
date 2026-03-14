import 'package:finances_control/feat/transaction/domain/transaction.dart';

abstract class TransactionListItem {}

class MonthHeaderItem extends TransactionListItem {
  final DateTime month;
  final int total;

  MonthHeaderItem({
    required this.month,
    required this.total,
  });
}

class TransactionItem extends TransactionListItem {
  final Transaction tx;

  TransactionItem(this.tx);
}