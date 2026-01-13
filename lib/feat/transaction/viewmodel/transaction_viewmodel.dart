import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/usecase/add_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/get_transaction.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionViewModel extends Cubit<TransactionState> {
  final AddTransactionUseCase addUseCase;
  final GetTransactionsUseCase getUseCase;

  TransactionViewModel({required this.addUseCase, required this.getUseCase})
    : super(TransactionState(transactions: []));

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    final data = await getUseCase();
    emit(TransactionState(transactions: data));
  }

  Future<void> add(Transaction tx) async {
    await addUseCase(tx);
    await load();
  }
}
