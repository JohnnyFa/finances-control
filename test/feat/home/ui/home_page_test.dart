import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/remote_config/enum/remote_config_key.dart';
import 'package:finances_control/core/remote_config/implementation/app_remote_config.dart';
import 'package:finances_control/feat/ads/enum/ad_placement.dart';
import 'package:finances_control/feat/ads/service/ad_visibility_service.dart';
import 'package:finances_control/feat/ads/vm/ad_viewmodel.dart';
import 'package:finances_control/feat/budget_control/data/repo/budget_repository.dart';
import 'package:finances_control/feat/budget_control/domain/budget.dart';
import 'package:finances_control/feat/ebooks/route/ebooks_path.dart';
import 'package:finances_control/feat/home/domain/home_calculator.dart';
import 'package:finances_control/feat/home/ui/home_page.dart';
import 'package:finances_control/feat/home/usecase/get_active_recurring_transaction.dart';
import 'package:finances_control/feat/home/usecase/get_global_economy.dart';
import 'package:finances_control/feat/home/usecase/get_transactions_by_month.dart';
import 'package:finances_control/feat/home/usecase/get_user.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/onboarding/data/repo/user_repository.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:finances_control/feat/premium/data/repo/purchase_repository.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_viewmodel.dart';
import 'package:finances_control/feat/premium/usecases/buy_remove_ads.dart';
import 'package:finances_control/feat/premium/usecases/get_user_entitlement.dart';
import 'package:finances_control/feat/premium/usecases/restore_purchases.dart';
import 'package:finances_control/feat/profile/route/profile_path.dart';
import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late HomeViewModel homeViewModel;

  setUp(() {
    homeViewModel = HomeViewModel(
      GetTransactionsByMonthUseCase(_FakeTransactionRepository()),
      GetGlobalEconomyUseCase(
        _FakeTransactionRepository(),
        _FakeRecurringRepository(),
      ),
      GetActiveRecurringTransactionsUseCase(_FakeRecurringRepository()),
      GetUserUseCase(_FakeUserRepository()),
      HomeCalculator(),
      _FakeBudgetRepository(),
    );

    final purchaseRepository = _FakePurchaseRepository();
    getIt.registerFactory<PurchaseViewModel>(
      () => PurchaseViewModel(
        BuyRemoveAdsUseCase(purchaseRepository),
        GetUserEntitlementUseCase(purchaseRepository),
        RestorePurchasesUseCase(purchaseRepository),
      ),
    );

    getIt.registerFactoryParam<AdViewModel, AdPlacement, void>(
      (placement, _) => AdViewModel(
        adVisibilityService: AdVisibilityService(
          GetUserEntitlementUseCase(purchaseRepository),
          _FakeRemoteConfig(),
        ),
        placement: placement,
      ),
    );
  });

  tearDown(() async {
    await homeViewModel.close();
    await getIt.reset();
  });

  testWidgets('shows home page and bottom navigation', (tester) async {
    await tester.pumpWidget(_buildTestApp(homeViewModel));
    await tester.pump();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('navigates to ebooks destination', (tester) async {
    final pushedRoutes = <String>[];

    await tester.pumpWidget(_buildTestApp(
      homeViewModel,
      onPush: (name) => pushedRoutes.add(name ?? ''),
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.menu_book_outlined));
    await tester.pump();

    expect(pushedRoutes, contains(EbooksPath.ebooks.path));
  });

  testWidgets('navigates to profile destination', (tester) async {
    final pushedRoutes = <String>[];

    await tester.pumpWidget(_buildTestApp(
      homeViewModel,
      onPush: (name) => pushedRoutes.add(name ?? ''),
    ));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.person_outline));
    await tester.pump();

    expect(pushedRoutes, contains(ProfilePath.profile.path));
  });
}

Widget _buildTestApp(
  HomeViewModel homeViewModel, {
  void Function(String?)? onPush,
}) {
  return BlocProvider.value(
    value: homeViewModel,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
      onGenerateRoute: (settings) {
        onPush?.call(settings.name);
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => const Scaffold(body: SizedBox()),
        );
      },
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
  Map<String, dynamic>? getJson(RemoteConfigKey key) => {
        'enabled': false,
      };

  @override
  List<Map<String, dynamic>> getJsonList(RemoteConfigKey key) => [];

  @override
  String getString(RemoteConfigKey key) => '';
}
