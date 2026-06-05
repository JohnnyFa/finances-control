import 'package:finances_control/feat/ads/service/interstitial_ad.dart';
import 'package:finances_control/feat/review/usecase/increment_entry_count.dart';
import 'package:finances_control/feat/review/usecase/increment_transaction_count.dart';
import 'package:finances_control/feat/review/usecase/mark_csv_uploaded.dart';
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
class MockIncrementEntryCountUseCase extends Mock implements IncrementEntryCountUseCase {}
class MockIncrementTransactionCountUseCase extends Mock implements IncrementTransactionCountUseCase {}
class MockMarkCsvUploadedUseCase extends Mock implements MarkCsvUploadedUseCase {}

void main() {
  late TransactionViewModel viewModel;
  late MockGetTransactionsUseCase mockGetUseCase;
  late MockImportCsvTransactionsUseCase mockImportCsvUseCase;
  late MockInterstitialAdService mockInterstitialService;
  late MockMarkCsvUploadedUseCase mockMarkCsvUploadedUseCase;

  setUp(() {
    mockGetUseCase = MockGetTransactionsUseCase();
    mockImportCsvUseCase = MockImportCsvTransactionsUseCase();
    mockInterstitialService = MockInterstitialAdService();
    mockMarkCsvUploadedUseCase = MockMarkCsvUploadedUseCase();

    viewModel = TransactionViewModel(
      addUseCase: MockAddTransactionUseCase(),
      getUseCase: mockGetUseCase,
      addRecurringUseCase: MockAddRecurringTransactionUseCase(),
      deleteRecurringUseCase: MockDeleteRecurringTransactionUseCase(),
      updateUseCase: MockUpdateTransactionUseCase(),
      deleteUseCase: MockDeleteTransactionUseCase(),
      importCsvUseCase: mockImportCsvUseCase,
      interstitialService: mockInterstitialService,
      incrementEntryCountUseCase: MockIncrementEntryCountUseCase(),
      incrementTransactionCountUseCase: MockIncrementTransactionCountUseCase(),
      markCsvUploadedUseCase: mockMarkCsvUploadedUseCase,
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

    test('does not call markCsvUploaded when importedCount is 0', () async {
      when(() => mockImportCsvUseCase()).thenAnswer((_) async => 0);
      when(() => mockGetUseCase()).thenAnswer((_) async => []);

      await viewModel.importCsv();

      verifyNever(() => mockMarkCsvUploadedUseCase());
    });

    test('calls markCsvUploaded when importedCount is greater than 0', () async {
      when(() => mockImportCsvUseCase()).thenAnswer((_) async => 3);
      when(() => mockMarkCsvUploadedUseCase()).thenAnswer((_) async {});
      when(() => mockGetUseCase()).thenAnswer((_) async => []);

      await viewModel.importCsv();

      verify(() => mockMarkCsvUploadedUseCase()).called(1);
    });
  });
}
