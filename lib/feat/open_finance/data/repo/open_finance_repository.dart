import 'package:finances_control/feat/open_finance/domain/bank_connection.dart';

abstract class OpenFinanceRepository {
  Future<void> connectBank(BankConnection connection);

  Future<List<BankConnection>> getConnections();

  Future<int> syncIncomingPayments(int bankConnectionId);
}
