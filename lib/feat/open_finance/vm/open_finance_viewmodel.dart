import 'package:finances_control/feat/open_finance/usecase/connect_bank.dart';
import 'package:finances_control/feat/open_finance/usecase/get_bank_connections.dart';
import 'package:finances_control/feat/open_finance/usecase/sync_bank_payments.dart';
import 'package:finances_control/feat/open_finance/vm/open_finance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenFinanceViewModel extends Cubit<OpenFinanceState> {
  final GetBankConnectionsUseCase getBankConnectionsUseCase;
  final ConnectBankUseCase connectBankUseCase;
  final SyncBankPaymentsUseCase syncBankPaymentsUseCase;

  OpenFinanceViewModel({
    required this.getBankConnectionsUseCase,
    required this.connectBankUseCase,
    required this.syncBankPaymentsUseCase,
  }) : super(OpenFinanceState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: OpenFinanceStatus.loading, clearError: true));
    try {
      final connections = await getBankConnectionsUseCase();
      emit(state.copyWith(status: OpenFinanceStatus.success, connections: connections));
    } catch (e) {
      emit(state.copyWith(status: OpenFinanceStatus.error, error: e.toString()));
    }
  }

  Future<void> connectBank(String bankName, String accountMasked) async {
    try {
      await connectBankUseCase(bankName, accountMasked);
      await load();
      emit(state.copyWith(message: 'Bank connected successfully'));
    } catch (e) {
      emit(state.copyWith(status: OpenFinanceStatus.error, error: e.toString()));
    }
  }

  Future<void> sync(int bankConnectionId) async {
    try {
      final imported = await syncBankPaymentsUseCase(bankConnectionId);
      emit(state.copyWith(message: '$imported payment(s) imported successfully'));
    } catch (e) {
      emit(state.copyWith(status: OpenFinanceStatus.error, error: e.toString()));
    }
  }

  void clearMessage() => emit(state.copyWith(clearMessage: true));
}
