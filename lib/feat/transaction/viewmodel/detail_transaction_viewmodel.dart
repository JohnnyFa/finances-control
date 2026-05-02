import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_recurring_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/update_transaction.dart';
import 'package:finances_control/feat/transaction/viewmodel/detail_transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailTransactionViewModel extends Cubit<DetailTransactionState> {
  final UpdateTransactionUseCase updateUseCase;
  final DeleteTransactionUseCase deleteUseCase;
  final DeleteRecurringTransactionUseCase deleteRecurringUseCase;

  DetailTransactionViewModel({
    required Transaction transaction,
    required this.updateUseCase,
    required this.deleteUseCase,
    required this.deleteRecurringUseCase,
  }) : super(DetailTransactionState(transaction: transaction));

  Future<void> updateCategory(Category category) async {
    final updatedTransaction = _cloneWith(category: category);
    await _update(updatedTransaction);
  }

  Future<void> updateDescription(String description) async {
    final updatedTransaction = _cloneWith(description: description);
    await _update(updatedTransaction);
  }

  Future<void> updateAmount(int amount) async {
    final updatedTransaction = _cloneWith(amount: amount);
    await _update(updatedTransaction);
  }

  Future<void> delete() async {
    emit(state.copyWith(isLoading: true));
    try {
      final tx = state.transaction;
      if (tx.isGenerated) {
        await deleteRecurringUseCase(tx.id!);
      } else {
        await deleteUseCase(tx.id!);
      }
      emit(state.copyWith(isLoading: false, isDeleted: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _update(Transaction updatedTransaction) async {
    final tx = state.transaction;

    if (tx.isGenerated) {
      emit(state.copyWith(
        errorMessage: 'Cannot edit recurring generated transactions',
      ));
      return;
    }

    emit(state.copyWith(isLoading: true, transaction: updatedTransaction));

    try {
      await updateUseCase(updatedTransaction);
      emit(state.copyWith(isLoading: false, hasUpdated: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Transaction _cloneWith({
    Category? category,
    String? description,
    int? amount,
  }) {
    final tx = state.transaction;
    return Transaction(
      id: tx.id,
      externalId: tx.externalId,
      amount: amount ?? tx.amount,
      type: tx.type,
      category: category ?? tx.category,
      date: tx.date,
      description: description ?? tx.description,
      isGenerated: tx.isGenerated,
    );
  }
}
