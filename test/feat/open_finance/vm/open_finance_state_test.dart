import 'package:finances_control/feat/open_finance/domain/bank_connection.dart';
import 'package:finances_control/feat/open_finance/vm/open_finance_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OpenFinanceState', () {
    test('initial has expected values', () {
      final state = OpenFinanceState.initial();

      expect(state.status, OpenFinanceStatus.initial);
      expect(state.connections, isEmpty);
      expect(state.error, isNull);
    });

    test('copyWith updates values and clear flags work', () {
      final base = OpenFinanceState.initial().copyWith(
        error: 'failed',
        message: 'done',
      );

      final updated = base.copyWith(
        status: OpenFinanceStatus.success,
        connections: [
          BankConnection(
            id: 1,
            bankName: 'Nu',
            accountMasked: '****1234',
            autoSyncEnabled: true,
            createdAt: DateTime(2026, 1, 1),
          ),
        ],
        clearError: true,
        clearMessage: true,
      );

      expect(updated.status, OpenFinanceStatus.success);
      expect(updated.connections.length, 1);
      expect(updated.error, isNull);
      expect(updated.message, isNull);
    });
  });
}
