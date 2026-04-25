import 'package:finances_control/feat/ads/service/interstitial_ad.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/usecase/add_recurring.dart';
import 'package:finances_control/feat/transaction/usecase/add_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_recurring_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/get_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/import_csv_transactions.dart';
import 'package:finances_control/feat/transaction/usecase/update_transaction.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionViewModel extends Cubit<TransactionState> {
  final AddTransactionUseCase addUseCase;
  final GetTransactionsUseCase getUseCase;
  final AddRecurringTransactionUseCase addRecurringUseCase;
  final DeleteRecurringTransactionUseCase deleteRecurringUseCase;
  final UpdateTransactionUseCase updateUseCase;
  final DeleteTransactionUseCase deleteUseCase;
  final ImportCsvTransactionsUseCase importCsvUseCase;
  final InterstitialAdService interstitialService;

  TransactionViewModel({
    required this.addUseCase,
    required this.getUseCase,
    required this.addRecurringUseCase,
    required this.deleteRecurringUseCase,
    required this.updateUseCase,
    required this.deleteUseCase,
    required this.importCsvUseCase,
    required this.interstitialService,
  }) : super(const TransactionInitial());

  Future<void> load() async {
    emit(const TransactionLoading());

    try {
      final data = await getUseCase();
      emit(TransactionLoaded(data));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> add(Transaction tx) async {
    emit(const TransactionLoading());

    try {
      await addUseCase(tx);

      final data = await getUseCase();
      emit(TransactionLoaded(data));
      _handleAdTrigger();
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> addRecurring(RecurringTransaction rt) async {
    emit(const TransactionLoading());

    try {
      await addRecurringUseCase(rt);

      final data = await getUseCase();
      emit(TransactionLoaded(data));
      _handleAdTrigger();
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> update(Transaction tx) async {
    emit(const TransactionLoading());

    try {
      await updateUseCase(tx);
      final data = await getUseCase();
      emit(TransactionLoaded(data));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> delete(Transaction tx) async {
    emit(const TransactionLoading());

    try {
      if (tx.isGenerated) {
        await deleteRecurringUseCase(tx.id!);
      } else {
        await deleteUseCase(tx.id!);
      }

      final data = await getUseCase();
      emit(TransactionLoaded(data));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> importCsv() async {
    final currentState = state;

    try {
      final importedCount = await importCsvUseCase();
      final data = await getUseCase();

      emit(
        TransactionLoaded(
          data,
          importedCount: importedCount > 0 ? importedCount : null,
        ),
      );
    } catch (e) {
      if (currentState is TransactionLoaded) {
        emit(currentState.copyWith(errorMessage: e.toString()));
      } else {
        emit(TransactionError(e.toString()));
      }
    }
  }

  int _transactionsAdded = 0;
  int _nextTrigger = 2;
  int _step = 2;
  bool _adsEnabled = false;

  void setAdsEnabled(bool value) {
    _adsEnabled = value;
  }

  void _handleAdTrigger() {
    if (!_adsEnabled) return;
    _transactionsAdded++;

    if (_transactionsAdded >= _nextTrigger) {
      interstitialService.showAd();

      _nextTrigger += _step;

      _step += _transactionsAdded;
    }
  }
}
