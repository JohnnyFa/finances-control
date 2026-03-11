import 'package:equatable/equatable.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {
  const TransactionInitial();
}

class TransactionLoading extends TransactionState {
  const TransactionLoading();
}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final int? importedCount;

  const TransactionLoaded(this.transactions, {this.importedCount});

  @override
  List<Object?> get props => [transactions, importedCount];

  TransactionLoaded copyWith({
    List<Transaction>? transactions,
    int? importedCount,
  }) {
    return TransactionLoaded(
      transactions ?? this.transactions,
      importedCount: importedCount,
    );
  }
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}
