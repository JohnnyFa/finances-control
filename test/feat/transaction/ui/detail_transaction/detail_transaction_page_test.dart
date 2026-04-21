import 'package:finances_control/feat/ads/service/interstitial_ad.dart';
import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/services/csv_file_picker_service.dart';
import 'package:finances_control/feat/transaction/ui/detail_transaction/detail_transaction_page.dart';
import 'package:finances_control/feat/transaction/usecase/add_recurring.dart';
import 'package:finances_control/feat/transaction/usecase/add_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_recurring_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/get_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/import_csv_transactions.dart';
import 'package:finances_control/feat/transaction/usecase/update_transaction.dart';
import 'package:finances_control/feat/transaction/utils/csv_parser.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:finances_control/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _FakeTransactionRepository transactionRepository;
  late _FakeRecurringRepository recurringRepository;
  late TransactionViewModel transactionViewModel;

  setUp(() {
    transactionRepository = _FakeTransactionRepository();
    recurringRepository = _FakeRecurringRepository();

    transactionViewModel = TransactionViewModel(
      addUseCase: AddTransactionUseCase(transactionRepository),
      getUseCase: GetTransactionsUseCase(transactionRepository, recurringRepository),
      addRecurringUseCase: AddRecurringTransactionUseCase(recurringRepository),
      deleteRecurringUseCase: DeleteRecurringTransactionUseCase(recurringRepository),
      updateUseCase: UpdateTransactionUseCase(transactionRepository),
      deleteUseCase: DeleteTransactionUseCase(transactionRepository),
      importCsvUseCase: ImportCsvTransactionsUseCase(
        filePickerService: _FakeCsvPickerService(),
        csvParser: CsvParser(),
        repository: transactionRepository,
      ),
      interstitialService: _MockInterstitialAdService(),
    );
  });

  tearDown(() async {
    await transactionViewModel.close();
  });

  testWidgets('renders transaction details', (tester) async {
    final transaction = Transaction(
      id: 1,
      amount: 5000,
      type: TransactionType.expense,
      category: Category.food,
      date: DateTime(2026, 4, 21),
      description: 'Lunch meal',
    );

    await tester.pumpWidget(
      _buildApp(
        transactionViewModel,
        transaction,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DetailTransactionPage), findsOneWidget);
    expect(find.text('Lunch meal'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
  });

  testWidgets('opens delete confirmation dialog', (tester) async {
    final transaction = Transaction(
      id: 2,
      amount: 9000,
      type: TransactionType.expense,
      category: Category.transport,
      date: DateTime(2026, 4, 21),
      description: 'Taxi',
    );

    await tester.pumpWidget(_buildApp(transactionViewModel, transaction));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(OutlinedButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });
}

Widget _buildApp(TransactionViewModel viewModel, Transaction tx) {
  return BlocProvider.value(
    value: viewModel,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: DetailTransactionPage(transaction: tx),
    ),
  );
}

class _FakeTransactionRepository implements TransactionRepository {
  @override
  Future<void> delete(int id) async {}

  @override
  Future<bool> existsByExternalId(String externalId) async => false;

  @override
  Future<List<Transaction>> getAll() async => [];

  @override
  Future<List<Transaction>> getByMonth({required int year, required int month, bool onlyExpenses = false}) async => [];

  @override
  Future<void> insertMany(List<Transaction> transactions) async {}

  @override
  Future<void> save(Transaction tx) async {}

  @override
  Future<void> update(Transaction tx) async {}
}

class _FakeRecurringRepository implements RecurringTransactionRepository {
  @override
  Future<void> delete(int id) async {}

  @override
  Future<List<RecurringTransaction>> getActive() async => [];

  @override
  Future<List<RecurringTransaction>> getAll() async => [];

  @override
  Future<void> save(RecurringTransaction rt) async {}
}

class _FakeCsvPickerService implements CsvFilePickerService {
  @override
  Future<String?> pickCsvContent() async => null;
}

class _MockInterstitialAdService extends Mock implements InterstitialAdService {}
