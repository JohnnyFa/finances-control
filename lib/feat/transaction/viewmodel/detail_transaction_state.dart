import 'package:equatable/equatable.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

class DetailTransactionState extends Equatable {
  final Transaction transaction;
  final bool isLoading;
  final String? errorMessage;
  final bool isDeleted;
  final bool hasUpdated;

  const DetailTransactionState({
    required this.transaction,
    this.isLoading = false,
    this.errorMessage,
    this.isDeleted = false,
    this.hasUpdated = false,
  });

  DetailTransactionState copyWith({
    Transaction? transaction,
    bool? isLoading,
    String? errorMessage,
    bool? isDeleted,
    bool? hasUpdated,
  }) {
    return DetailTransactionState(
      transaction: transaction ?? this.transaction,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isDeleted: isDeleted ?? this.isDeleted,
      hasUpdated: hasUpdated ?? this.hasUpdated,
    );
  }

  @override
  List<Object?> get props =>
      [transaction, isLoading, errorMessage, isDeleted, hasUpdated];
}
