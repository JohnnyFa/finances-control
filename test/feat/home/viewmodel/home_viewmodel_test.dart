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
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockTransactionRepository transactionRepository;
  late _MockRecurringRepository recurringRepository;
  late _MockUserRepository userRepository;
  late _MockBudgetRepository budgetRepository;
  late HomeViewModel viewModel;

  setUp(() {
    transactionRepository = _MockTransactionRepository();
    recurringRepository = _MockRecurringRepository();
    userRepository = _MockUserRepository();
    budgetRepository = _MockBudgetRepository();

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

  test('successful load emits loading then loaded', () async {
    final txs = [
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
    final recurring = [
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

    when(() => transactionRepository.getByMonth(year: any(named: 'year'), month: any(named: 'month'), onlyExpenses: any(named: 'onlyExpenses')))
        .thenAnswer((_) async => txs);
    when(() => transactionRepository.getAll()).thenAnswer((_) async => txs);
    when(() => recurringRepository.getAll()).thenAnswer((_) async => recurring);
    when(() => recurringRepository.getActive()).thenAnswer((_) async => recurring);
    when(() => userRepository.get()).thenAnswer((_) async => User(name: 'Alex', salary: 400000));
    when(() => budgetRepository.getBudgetsByMonth(any(), any())).thenAnswer((_) async => [
          Budget(
            category: Category.food,
            limitCents: 10000,
            spentCents: 0,
            month: 4,
            year: 2026,
          ),
        ]);

    final statesFuture = expectLater(
      viewModel.stream,
      emitsInOrder([
        isA<HomeLoading>(),
        isA<HomeLoaded>()
            .having((s) => s.totalIncome, 'totalIncome', 400000)
            .having((s) => s.totalExpense, 'totalExpense', 105000),
      ]),
    );

    await viewModel.load(2026, 4);
    await statesFuture;
  });

  test('error handling emits loading then error', () async {
    when(() => transactionRepository.getByMonth(year: any(named: 'year'), month: any(named: 'month'), onlyExpenses: any(named: 'onlyExpenses')))
        .thenThrow(Exception('boom'));

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

  test('state transitions from loading to loaded', () async {
    when(() => transactionRepository.getByMonth(year: any(named: 'year'), month: any(named: 'month'), onlyExpenses: any(named: 'onlyExpenses')))
        .thenAnswer((_) async => []);
    when(() => transactionRepository.getAll()).thenAnswer((_) async => []);
    when(() => recurringRepository.getAll()).thenAnswer((_) async => []);
    when(() => recurringRepository.getActive()).thenAnswer((_) async => []);
    when(() => userRepository.get()).thenAnswer((_) async => User(name: 'Alex', salary: 0));
    when(() => budgetRepository.getBudgetsByMonth(any(), any())).thenAnswer((_) async => <Budget>[]);

    final statesFuture = expectLater(
      viewModel.stream,
      emitsInOrder([
        isA<HomeLoading>(),
        isA<HomeLoaded>(),
      ]),
    );

    await viewModel.load(2026, 4);
    await statesFuture;
  });
}

class _MockTransactionRepository extends Mock implements TransactionRepository {}

class _MockRecurringRepository extends Mock implements RecurringTransactionRepository {}

class _MockUserRepository extends Mock implements UserRepository {}

class _MockBudgetRepository extends Mock implements BudgetRepository {}
