import 'package:finances_control/feat/budget_control/data/repo/budget_repository.dart';
import 'package:finances_control/feat/budget_control/domain/budget.dart';
import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/home/domain/home_calculator.dart';
import 'package:finances_control/feat/home/ui/home_header.dart';
import 'package:finances_control/feat/home/usecase/get_active_recurring_transaction.dart';
import 'package:finances_control/feat/home/usecase/get_global_economy.dart';
import 'package:finances_control/feat/home/usecase/get_transactions_by_month.dart';
import 'package:finances_control/feat/home/usecase/get_user.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/onboarding/data/repo/user_repository.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_widget.dart';

void main() {
  late _TrackingHomeViewModel homeViewModel;

  setUp(() {
    homeViewModel = _TrackingHomeViewModel();
  });

  tearDown(() async {
    await homeViewModel.close();
  });

  testWidgets('HomeHeader shows placeholders while loading', (tester) async {
    homeViewModel.setState(const HomeLoading(year: 2026, month: 4));

    await tester.pumpApp(
      BlocProvider<HomeViewModel>.value(
        value: homeViewModel,
        child: SingleChildScrollView(child: HomeHeader(onTransactionsTap: () {})),
      ),
    );

    expect(find.byIcon(Icons.receipt_long), findsNothing);
    expect(find.byIcon(Icons.chevron_left), findsNothing);
  });

  testWidgets('HomeHeader shows placeholders on error state', (tester) async {
    homeViewModel.setState(const HomeError('boom'));

    await tester.pumpApp(
      BlocProvider<HomeViewModel>.value(
        value: homeViewModel,
        child: SingleChildScrollView(child: HomeHeader(onTransactionsTap: () {})),
      ),
    );

    expect(find.byIcon(Icons.receipt_long), findsNothing);
    expect(find.byIcon(Icons.chevron_left), findsNothing);
  });

  testWidgets('HomeHeader success renders and taps transactions callback', (tester) async {
    var tapped = false;
    homeViewModel.setState(_loaded(year: 2026, month: 3));

    await tester.pumpApp(
      BlocProvider<HomeViewModel>.value(
        value: homeViewModel,
        child: SingleChildScrollView(child: HomeHeader(onTransactionsTap: () => tapped = true)),
      ),
    );

    expect(find.byIcon(Icons.receipt_long), findsOneWidget);

    await tester.tap(find.byIcon(Icons.receipt_long));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('HomeHeader month arrows trigger load calls', (tester) async {
    homeViewModel.setState(_loaded(year: 2026, month: 2));

    await tester.pumpApp(
      BlocProvider<HomeViewModel>.value(
        value: homeViewModel,
        child: SingleChildScrollView(child: HomeHeader(onTransactionsTap: () {})),
      ),
    );

    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pump();

    expect(homeViewModel.loadCalls, containsAll([const (2026, 1), const (2026, 3)]));
  });
}

HomeLoaded _loaded({required int year, required int month}) {
  return HomeLoaded(
    year: year,
    month: month,
    categories: <ExpenseCategorySummary>[],
    totalIncome: 1000,
    totalExpense: 400,
    globalEconomy: 600,
    recurring: <RecurringTransaction>[],
    user: User(name: 'Alex', salary: 5000),
  );
}

class _TrackingHomeViewModel extends HomeViewModel {
  _TrackingHomeViewModel()
      : super(
          GetTransactionsByMonthUseCase(_FakeTransactionRepository()),
          GetGlobalEconomyUseCase(_FakeTransactionRepository(), _FakeRecurringRepository()),
          GetActiveRecurringTransactionsUseCase(_FakeRecurringRepository()),
          GetUserUseCase(_FakeUserRepository()),
          HomeCalculator(),
          _FakeBudgetRepository(),
        );

  final List<(int, int)> loadCalls = [];

  void setState(HomeState state) => emit(state);

  @override
  Future<void> load(int year, int month) async {
    loadCalls.add((year, month));
  }
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

class _FakeUserRepository implements UserRepository {
  @override
  Future<void> delete() async {}

  @override
  Future<bool> exists() async => true;

  @override
  Future<User> get() async => User(name: 'Tester', salary: 0);

  @override
  Future<void> save(User user) async {}

  @override
  Future<void> update(User user) async {}
}

class _FakeBudgetRepository implements BudgetRepository {
  @override
  Future<void> deleteBudget(String categoryId, int month, int year) async {}

  @override
  Future<List<Budget>> getBudgetsByMonth(int month, int year) async => [];

  @override
  Future<void> upsertBudget(String categoryId, int month, int year, int limitCents) async {}
}
