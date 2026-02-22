import 'package:finances_control/feat/open_finance/data/repo/open_finance_repository.dart';
import 'package:finances_control/feat/open_finance/domain/bank_connection.dart';

class ConnectBankUseCase {
  final OpenFinanceRepository repository;

  ConnectBankUseCase(this.repository);

  Future<void> call(String bankName, String accountMasked) {
    return repository.connectBank(
      BankConnection(
        bankName: bankName,
        accountMasked: accountMasked,
        autoSyncEnabled: true,
        createdAt: DateTime.now(),
      ),
    );
  }
}
