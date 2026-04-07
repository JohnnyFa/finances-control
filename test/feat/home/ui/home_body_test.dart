import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/remote_config/enum/remote_config_key.dart';
import 'package:finances_control/core/remote_config/implementation/app_remote_config.dart';
import 'package:finances_control/feat/ads/enum/ad_placement.dart';
import 'package:finances_control/feat/ads/service/ad_visibility_service.dart';
import 'package:finances_control/feat/ads/vm/ad_state.dart';
import 'package:finances_control/feat/ads/vm/ad_viewmodel.dart';
import 'package:finances_control/feat/budget_control/data/repo/budget_repository.dart';
import 'package:finances_control/feat/budget_control/domain/budget.dart';
import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/home/domain/home_calculator.dart';
import 'package:finances_control/feat/home/ui/home_body.dart';
import 'package:finances_control/feat/home/ui/widget/loader/home_skeleton.dart';
import 'package:finances_control/feat/home/ui/widget/section/balance_section.dart';
import 'package:finances_control/feat/home/ui/widget/section/expenses_section.dart';
import 'package:finances_control/feat/home/ui/widget/section/recurring_section.dart';
import 'package:finances_control/feat/home/usecase/get_active_recurring_transaction.dart';
import 'package:finances_control/feat/home/usecase/get_global_economy.dart';
import 'package:finances_control/feat/home/usecase/get_transactions_by_month.dart';
import 'package:finances_control/feat/home/usecase/get_user.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/onboarding/data/repo/user_repository.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:finances_control/feat/premium/data/repo/purchase_repository.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';
import 'package:finances_control/feat/premium/usecases/get_user_entitlement.dart';
import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_widget.dart';

void main() {
  late _TestHomeViewModel homeViewModel;

  setUp(() {
    homeViewModel = _TestHomeViewModel();

    getIt.registerFactoryParam<AdViewModel, AdPlacement, void>((placement, _) {
      return _TestAdViewModel(placement);
    });
  });

  tearDown(() async {
    await homeViewModel.close();
    await getIt.reset();
  });

  testWidgets('HomeBody shows skeleton in loading state', (tester) async {
    homeViewModel.setState(const HomeLoading(year: 2026, month: 4));

    await tester.pumpApp(BlocProvider.value(value: homeViewModel, child: const HomeBody()));

    expect(find.byType(HomeSkeleton), findsOneWidget);
  });

  testWidgets('HomeBody shows error message in error state', (tester) async {
    homeViewModel.setState(const HomeError('load failed'));

    await tester.pumpApp(BlocProvider.value(value: homeViewModel, child: const HomeBody()));

    expect(find.text('load failed'), findsOneWidget);
  });

  testWidgets('HomeBody shows sections in success state', (tester) async {
    homeViewModel.setState(
      HomeLoaded(
        year: 2026,
        month: 4,
        categories: <ExpenseCategorySummary>[],
        totalIncome: 1000,
        totalExpense: 300,
        globalEconomy: 700,
        recurring: <RecurringTransaction>[],
        user: User(name: 'Tester', salary: 1000),
      ),
    );

    await tester.pumpApp(BlocProvider.value(value: homeViewModel, child: const HomeBody()));

    expect(find.byType(BalanceSection), findsOneWidget);
    expect(find.byType(ExpensesSection), findsOneWidget);
    expect(find.byType(RecurringSection), findsOneWidget);
  });
}

class _TestHomeViewModel extends HomeViewModel {
  _TestHomeViewModel()
      : super(
          GetTransactionsByMonthUseCase(_FakeTransactionRepository()),
          GetGlobalEconomyUseCase(_FakeTransactionRepository(), _FakeRecurringRepository()),
          GetActiveRecurringTransactionsUseCase(_FakeRecurringRepository()),
          GetUserUseCase(_FakeUserRepository()),
          HomeCalculator(),
          _FakeBudgetRepository(),
        );

  void setState(HomeState state) => emit(state);

  @override
  Future<void> load(int year, int month) async {}
}

class _TestAdViewModel extends AdViewModel {
  _TestAdViewModel(AdPlacement placement)
      : super(
          adVisibilityService: AdVisibilityService(
            GetUserEntitlementUseCase(_FakePurchaseRepository()),
            _FakeRemoteConfig(),
          ),
          placement: placement,
        );

  @override
  Future<void> load() async {
    emit(const AdLoaded(false));
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

class _FakePurchaseRepository implements PurchaseRepository {
  @override
  Future<void> buyRemoveAds() async {}

  @override
  Future<Entitlement> getEntitlement() async => Entitlement.free;

  @override
  Future<Entitlement> restorePurchases() async => Entitlement.free;
}

class _FakeRemoteConfig implements AppRemoteConfig {
  @override
  bool getBool(RemoteConfigKey key) => false;

  @override
  Map<String, dynamic>? getJson(RemoteConfigKey key) => {'enabled': false};

  @override
  List<Map<String, dynamic>> getJsonList(RemoteConfigKey key) => [];

  @override
  String getString(RemoteConfigKey key) => '';
}
