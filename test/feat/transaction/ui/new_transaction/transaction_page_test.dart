import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/remote_config/enum/remote_config_key.dart';
import 'package:finances_control/core/remote_config/implementation/app_remote_config.dart';
import 'package:finances_control/feat/ads/enum/ad_placement.dart';
import 'package:finances_control/feat/ads/service/ad_visibility_service.dart';
import 'package:finances_control/feat/ads/service/interstitial_ad.dart';
import 'package:finances_control/feat/ads/vm/ad_viewmodel.dart';
import 'package:finances_control/feat/premium/data/repo/purchase_repository.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';
import 'package:finances_control/feat/premium/usecases/get_user_entitlement.dart';
import 'package:finances_control/feat/transaction/data/recurring/repo/recurring_transaction_repository.dart';
import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/services/csv_file_picker_service.dart';
import 'package:finances_control/feat/transaction/ui/new_transaction/transaction_page.dart';
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

    final purchaseRepository = _FakePurchaseRepository();

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
    await transactionViewModel.close();
    await getIt.reset();
  });

  testWidgets('renders new transaction page components', (tester) async {
    await tester.pumpWidget(_buildApp(transactionViewModel));
    await tester.pumpAndSettle();

    expect(find.byType(TransactionPage), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.hintText == 'R\$ 0,00',
      ),
      findsOneWidget,
    );
    expect(find.byType(Switch), findsOneWidget);
  });

  testWidgets('shows recurring fields after enabling recurring toggle', (tester) async {
    await tester.pumpWidget(_buildApp(transactionViewModel));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.byType(DropdownButton<int>), findsOneWidget);
    expect(find.byIcon(Icons.event_repeat), findsOneWidget);
  });
}

Widget _buildApp(TransactionViewModel viewModel) {
  return BlocProvider.value(
    value: viewModel,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: TransactionPage(initialDate: DateTime(2026, 4, 21)),
    ),
  );
}

class _FakeTransactionRepository implements TransactionRepository {
  final List<Transaction> _transactions = [];

  @override
  Future<void> delete(int id) async {}

  @override
  Future<bool> existsByExternalId(String externalId) async => false;

  @override
  Future<List<Transaction>> getAll() async => _transactions;

  @override
  Future<List<Transaction>> getByMonth({required int year, required int month, bool onlyExpenses = false}) async => [];

  @override
  Future<void> insertMany(List<Transaction> transactions) async {}

  @override
  Future<void> save(Transaction tx) async {
    _transactions.add(
      Transaction(
        id: _transactions.length + 1,
        externalId: tx.externalId,
        amount: tx.amount,
        type: tx.type,
        category: tx.category,
        date: tx.date,
        description: tx.description,
        isGenerated: tx.isGenerated,
      ),
    );
  }

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

class _FakeCsvPickerService implements CsvFilePickerService {
  @override
  Future<String?> pickCsvContent() async => null;
}

class _MockInterstitialAdService extends Mock implements InterstitialAdService {}
