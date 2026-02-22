import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TransactionState copyWith updates list and status', () {
    final initial = const TransactionState(transactions: []);

    final tx = Transaction(
      amount: 1000,
      type: TransactionType.income,
      category: Category.salary,
      date: DateTime(2026, 1, 1),
      description: 'Salary',
    );

    final updated = initial.copyWith(
      transactions: [tx],
      status: TransactionStatus.success,
      errorMessage: null,
    );

    expect(updated.transactions.length, 1);
    expect(updated.status, TransactionStatus.success);
  });
});
