import 'package:equatable/equatable.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

class TransactionState extends Equatable {
  final List<Transaction> transactions;
  final bool loading;

  const TransactionState({
    required this.transactions,
    this.loading = false,
  });

  @override
  List<Object?> get props => [transactions, loading];

  TransactionState copyWith({
    List<Transaction>? transactions,
    bool? loading,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      loading: loading ?? this.loading,
    );
  }
}
