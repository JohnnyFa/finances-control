import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/category_by_type.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/add_recurring.dart';
import 'package:finances_control/feat/transaction/usecase/add_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/get_transaction.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionViewModel extends Cubit<TransactionState> {
  final AddTransactionUseCase addUseCase;
  final GetTransactionsUseCase getUseCase;
  final AddRecurringTransactionUseCase addRecurringUseCase;

  TransactionViewModel({
    required this.addUseCase,
    required this.getUseCase,
    required this.addRecurringUseCase,
  }) : super(TransactionState(transactions: []));

  TransactionType type = TransactionType.expense;
  Category category = Category.food;

  List<Category> get categories => categoryByType[type] ?? [];

  Future<void> load() async {
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      final data = await getUseCase();

      emit(
        state.copyWith(
          transactions: data,
          status: TransactionStatus.success,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> add(Transaction tx) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      await addUseCase(tx);
      final data = await getUseCase();

      emit(
        state.copyWith(transactions: data, status: TransactionStatus.success),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addRecurring(RecurringTransaction rt) async {
    emit(state.copyWith(status: TransactionStatus.loading));

    try {
      await addRecurringUseCase(rt);
      emit(state.copyWith(status: TransactionStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
