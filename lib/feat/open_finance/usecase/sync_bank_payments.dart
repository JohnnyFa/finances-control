import 'package:finances_control/feat/open_finance/data/repo/open_finance_repository.dart';

class SyncBankPaymentsUseCase {
  final OpenFinanceRepository repository;

  SyncBankPaymentsUseCase(this.repository);

  Future<int> call(int bankConnectionId) => repository.syncIncomingPayments(bankConnectionId);
}
