import 'package:equatable/equatable.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

enum TransactionStatus {
  initial,
  loading,
  success,
  error,
}

class TransactionState extends Equatable {
  final List<Transaction> transactions;
  final TransactionStatus status;
  final String? errorMessage;

  const TransactionState({
    required this.transactions,
    this.status = TransactionStatus.initial,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [transactions, status, errorMessage];

  TransactionState copyWith({
    List<Transaction>? transactions,
    TransactionStatus? status,
    String? errorMessage,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}
