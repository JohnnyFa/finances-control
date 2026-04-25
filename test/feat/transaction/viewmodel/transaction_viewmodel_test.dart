import 'package:finances_control/feat/ads/service/interstitial_ad.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/usecase/add_recurring.dart';
import 'package:finances_control/feat/transaction/usecase/add_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_recurring_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/get_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/import_csv_transactions.dart';
import 'package:finances_control/feat/transaction/usecase/update_transaction.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_state.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddTransactionUseCase extends Mock implements AddTransactionUseCase {}
class MockGetTransactionsUseCase extends Mock implements GetTransactionsUseCase {}
class MockAddRecurringTransactionUseCase extends Mock implements AddRecurringTransactionUseCase {}
class MockDeleteRecurringTransactionUseCase extends Mock implements DeleteRecurringTransactionUseCase {}
class MockUpdateTransactionUseCase extends Mock implements UpdateTransactionUseCase {}
class MockDeleteTransactionUseCase extends Mock implements DeleteTransactionUseCase {}
class MockImportCsvTransactionsUseCase extends Mock implements ImportCsvTransactionsUseCase {}
class MockInterstitialAdService extends Mock implements InterstitialAdService {}

void main() {
  late TransactionViewModel viewModel;
  late MockGetTransactionsUseCase mockGetUseCase;
  late MockImportCsvTransactionsUseCase mockImportCsvUseCase;
  late MockInterstitialAdService mockInterstitialService;

  setUp(() {
    mockGetUseCase = MockGetTransactionsUseCase();
    mockImportCsvUseCase = MockImportCsvTransactionsUseCase();
    mockInterstitialService = MockInterstitialAdService();

    viewModel = TransactionViewModel(
      addUseCase: MockAddTransactionUseCase(),
      getUseCase: mockGetUseCase,
      addRecurringUseCase: MockAddRecurringTransactionUseCase(),
      deleteRecurringUseCase: MockDeleteRecurringTransactionUseCase(),
      updateUseCase: MockUpdateTransactionUseCase(),
      deleteUseCase: MockDeleteTransactionUseCase(),
      importCsvUseCase: mockImportCsvUseCase,
      interstitialService: mockInterstitialService,
    );
  });

  group('importCsv', () {
    test('emits TransactionLoaded with errorMessage when import fails and state was already loaded', () async {
      final initialTransactions = <Transaction>[];
      when(() => mockGetUseCase()).thenAnswer((_) async => initialTransactions);
      
      // Load initially
      await viewModel.load();
      expect(viewModel.state, TransactionLoaded(initialTransactions));

      // Mock import failure
      when(() => mockImportCsvUseCase()).thenThrow(Exception('Import failed'));

      await viewModel.importCsv();

      expect(viewModel.state, isA<TransactionLoaded>());
      final state = viewModel.state as TransactionLoaded;
      expect(state.transactions, initialTransactions);
      expect(state.errorMessage, contains('Import failed'));
    });

    test('emits TransactionError when import fails and state was NOT loaded', () async {
      // Mock import failure
      when(() => mockImportCsvUseCase()).thenThrow(Exception('Import failed'));

      await viewModel.importCsv();

      expect(viewModel.state, isA<TransactionError>());
      final state = viewModel.state as TransactionError;
      expect(state.message, contains('Import failed'));
    });
  });
}
