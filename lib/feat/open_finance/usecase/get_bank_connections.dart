import 'package:finances_control/feat/open_finance/data/repo/open_finance_repository.dart';
import 'package:finances_control/feat/open_finance/domain/bank_connection.dart';

class GetBankConnectionsUseCase {
  final OpenFinanceRepository repository;

  GetBankConnectionsUseCase(this.repository);

  Future<List<BankConnection>> call() => repository.getConnections();
}
