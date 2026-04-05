import 'package:finances_control/feat/budget_control/data/repo/budget_repository.dart';
import 'package:finances_control/feat/budget_control/domain/budget.dart';
import 'package:finances_control/feat/home/domain/home_calculator.dart';
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
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeViewModel', () {
    late _FakeTransactionRepository transactionRepository;
    late _FakeRecurringRepository recurringRepository;
    late _FakeUserRepository userRepository;
    late _FakeBudgetRepository budgetRepository;
    late HomeViewModel viewModel;

    setUp(() {
      transactionRepository = _FakeTransactionRepository();
      recurringRepository = _FakeRecurringRepository();
      userRepository = _FakeUserRepository();
      budgetRepository = _FakeBudgetRepository();

      viewModel = HomeViewModel(
        GetTransactionsByMonthUseCase(transactionRepository),
        GetGlobalEconomyUseCase(transactionRepository, recurringRepository),
        GetActiveRecurringTransactionsUseCase(recurringRepository),
        GetUserUseCase(userRepository),
        HomeCalculator(),
        budgetRepository,
      );
    });

    tearDown(() async {
      await viewModel.close();
    });

    test('emits loading then loaded with calculated values', () async {
      transactionRepository.monthTransactions = [
        Transaction(
          amount: 400000,
          type: TransactionType.income,
          category: Category.salary,
          date: DateTime(2026, 4, 1),
          description: 'Salary',
        ),
        Transaction(
          amount: 100000,
          type: TransactionType.expense,
          category: Category.rent,
          date: DateTime(2026, 4, 2),
          description: 'Rent',
        ),
      ];
      transactionRepository.allTransactions = transactionRepository.monthTransactions;
      recurringRepository.activeTransactions = [
        RecurringTransaction(
          amount: 5000,
          type: TransactionType.expense,
          category: Category.food,
          dayOfMonth: 10,
          startDate: DateTime(2026, 1, 10),
          description: 'Subscription',
          active: true,
        ),
      ];
      recurringRepository.allTransactions = recurringRepository.activeTransactions;
      userRepository.user = User(name: 'Alex', salary: 400000);
      budgetRepository.budgets = [
        Budget(
          category: Category.food,
          limitCents: 10000,
          spentCents: 0,
          month: 4,
          year: 2026,
        ),
      ];

      final statesFuture = expectLater(
        viewModel.stream,
        emitsInOrder([
          isA<HomeLoading>(),
          isA<HomeLoaded>().having((s) => s.totalIncome, 'totalIncome', 400000).having(
                (s) => s.totalExpense,
                'totalExpense',
                105000,
              ),
        ]),
      );

      await viewModel.load(2026, 4);
      await statesFuture;
    });

    test('emits error when a dependency throws', () async {
      transactionRepository.shouldThrowOnGetByMonth = true;

      final statesFuture = expectLater(
        viewModel.stream,
        emitsInOrder([
          isA<HomeLoading>(),
          isA<HomeError>(),
        ]),
      );

      await viewModel.load(2026, 4);
      await statesFuture;
    });
  });
}

class _FakeTransactionRepository implements TransactionRepository {
  List<Transaction> monthTransactions = [];
  List<Transaction> allTransactions = [];
  bool shouldThrowOnGetByMonth = false;

  @override
  Future<List<Transaction>> getByMonth({required int year, required int month, bool onlyExpenses = false}) async {
    if (shouldThrowOnGetByMonth) {
      throw Exception('unable to load month');
    }

    if (!onlyExpenses) {
      return monthTransactions;
    }

    return monthTransactions.where((tx) => tx.type == TransactionType.expense).toList();
  }

  @override
  Future<List<Transaction>> getAll() async => allTransactions;

  @override
  Future<void> delete(int id) async {}

  @override
  Future<bool> existsByExternalId(String externalId) async => false;

  @override
  Future<void> insertMany(List<Transaction> transactions) async {}

  @override
  Future<void> save(Transaction tx) async {}

  @override
  Future<void> update(Transaction tx) async {}
}

class _FakeRecurringRepository implements RecurringTransactionRepository {
  List<RecurringTransaction> activeTransactions = [];
  List<RecurringTransaction> allTransactions = [];

  @override
  Future<List<RecurringTransaction>> getActive() async => activeTransactions;

  @override
  Future<List<RecurringTransaction>> getAll() async => allTransactions;

  @override
  Future<void> delete(int id) async {}

  @override
  Future<void> save(RecurringTransaction rt) async {}
}

class _FakeUserRepository implements UserRepository {
  User user = User.empty();

  @override
  Future<User> get() async => user;

  @override
  Future<void> delete() async {}

  @override
  Future<bool> exists() async => true;

  @override
  Future<void> save(User user) async {}

  @override
  Future<void> update(User user) async {}
}

class _FakeBudgetRepository implements BudgetRepository {
  List<Budget> budgets = [];

  @override
  Future<List<Budget>> getBudgetsByMonth(int month, int year) async => budgets;

  @override
  Future<void> deleteBudget(String categoryId, int month, int year) async {}

  @override
  Future<void> upsertBudget(String categoryId, int month, int year, int limitCents) async {}
}
