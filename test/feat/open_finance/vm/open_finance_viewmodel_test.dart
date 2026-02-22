import 'package:finances_control/feat/open_finance/data/repo/open_finance_repository.dart';
import 'package:finances_control/feat/open_finance/domain/bank_connection.dart';
import 'package:finances_control/feat/open_finance/usecase/connect_bank.dart';
import 'package:finances_control/feat/open_finance/usecase/get_bank_connections.dart';
import 'package:finances_control/feat/open_finance/usecase/sync_bank_payments.dart';
import 'package:finances_control/feat/open_finance/vm/open_finance_state.dart';
import 'package:finances_control/feat/open_finance/vm/open_finance_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeOpenFinanceRepository implements OpenFinanceRepository {
  final List<BankConnection> _connections = [];
  final Map<int, int> syncResults = {1: 2};

  @override
  Future<void> connectBank(BankConnection connection) async {
    _connections.add(
      BankConnection(
        id: _connections.length + 1,
        bankName: connection.bankName,
        accountMasked: connection.accountMasked,
        autoSyncEnabled: connection.autoSyncEnabled,
        createdAt: connection.createdAt,
      ),
    );
  }

  @override
  Future<List<BankConnection>> getConnections() async => _connections;

  @override
  Future<int> syncIncomingPayments(int bankConnectionId) async {
    return syncResults[bankConnectionId] ?? 0;
  }
}

void main() {
  group('OpenFinanceViewModel', () {
    late _FakeOpenFinanceRepository repository;
    late OpenFinanceViewModel viewModel;

    setUp(() {
      repository = _FakeOpenFinanceRepository();
      viewModel = OpenFinanceViewModel(
        getBankConnectionsUseCase: GetBankConnectionsUseCase(repository),
        connectBankUseCase: ConnectBankUseCase(repository),
        syncBankPaymentsUseCase: SyncBankPaymentsUseCase(repository),
      );
    });

    test('connectBank adds connection and updates state', () async {
      await viewModel.connectBank('Nubank', '****1234');

      expect(viewModel.state.connections.length, 1);
      expect(viewModel.state.status, OpenFinanceStatus.success);
      expect(viewModel.state.message, 'Bank connected successfully');
    });

    test('sync updates success message with imported count', () async {
      await viewModel.connectBank('Nubank', '****1234');
      viewModel.clearMessage();

      await viewModel.sync(1);

      expect(viewModel.state.message, '2 payment(s) imported successfully');
    });
  });
}
