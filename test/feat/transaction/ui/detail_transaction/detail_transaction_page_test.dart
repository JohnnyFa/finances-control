import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/ui/detail_transaction/detail_transaction_page.dart';
import 'package:finances_control/feat/transaction/usecase/delete_recurring_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/delete_transaction.dart';
import 'package:finances_control/feat/transaction/usecase/update_transaction.dart';
import 'package:finances_control/feat/transaction/viewmodel/detail_transaction_viewmodel.dart';
import 'package:finances_control/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _FakeTransactionRepository transactionRepository;
  late _FakeRecurringRepository recurringRepository;
  late UpdateTransactionUseCase updateUseCase;
  late DeleteTransactionUseCase deleteUseCase;
  late DeleteRecurringTransactionUseCase deleteRecurringUseCase;

  setUp(() {
    transactionRepository = _FakeTransactionRepository();
    recurringRepository = _FakeRecurringRepository();
    updateUseCase = UpdateTransactionUseCase(transactionRepository);
    deleteUseCase = DeleteTransactionUseCase(transactionRepository);
    deleteRecurringUseCase = DeleteRecurringTransactionUseCase(recurringRepository);
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

    final viewModel = DetailTransactionViewModel(
      transaction: transaction,
      updateUseCase: updateUseCase,
      deleteUseCase: deleteUseCase,
      deleteRecurringUseCase: deleteRecurringUseCase,
    );

    await tester.pumpWidget(
      _buildApp(viewModel),
    );
    await tester.pumpAndSettle();

    expect(find.byType(DetailTransactionPage), findsOneWidget);
    expect(find.text('Lunch meal', skipOffstage: false), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline_rounded, skipOffstage: false), findsOneWidget);
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

    final viewModel = DetailTransactionViewModel(
      transaction: transaction,
      updateUseCase: updateUseCase,
      deleteUseCase: deleteUseCase,
      deleteRecurringUseCase: deleteRecurringUseCase,
    );

    await tester.pumpWidget(_buildApp(viewModel));
    await tester.pumpAndSettle();

    final deleteButtonFinder = find.byType(OutlinedButton);
    await tester.dragUntilVisible(
      deleteButtonFinder,
      find.byType(Scrollable).first,
      const Offset(0, -200),
    );
    await tester.tap(deleteButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });
}

Widget _buildApp(DetailTransactionViewModel viewModel) {
  return BlocProvider.value(
    value: viewModel,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const DetailTransactionPage(),
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