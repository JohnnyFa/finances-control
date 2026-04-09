import 'package:finances_control/feat/premium/data/repo/purchase_repository.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_state.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_viewmodel.dart';
import 'package:finances_control/feat/premium/usecases/buy_remove_ads.dart';
import 'package:finances_control/feat/premium/usecases/get_user_entitlement.dart';
import 'package:finances_control/feat/premium/usecases/restore_purchases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockPurchaseRepository repository;
  late PurchaseViewModel viewModel;

  setUp(() {
    repository = _MockPurchaseRepository();

    viewModel = PurchaseViewModel(
      BuyRemoveAdsUseCase(repository),
      GetUserEntitlementUseCase(repository),
      RestorePurchasesUseCase(repository),
    );
  });

  tearDown(() async {
    await viewModel.close();
  });

  test('removeAds emits loading then success with current entitlement', () async {
    when(() => repository.buyRemoveAds()).thenAnswer((_) async {});
    when(() => repository.getEntitlement())
        .thenAnswer((_) async => Entitlement.free);

    final statesFuture = expectLater(
      viewModel.stream,
      emitsInOrder([
        isA<PurchaseLoading>(),
        isA<PurchaseSuccess>()
            .having((s) => s.entitlement, 'entitlement', Entitlement.free),
      ]),
    );

    await viewModel.removeAds();
    await statesFuture;
  });

  test('restore emits loading then success with restored entitlement', () async {
    when(() => repository.restorePurchases())
        .thenAnswer((_) async => Entitlement.noAds);

    final statesFuture = expectLater(
      viewModel.stream,
      emitsInOrder([
        isA<PurchaseLoading>(),
        isA<PurchaseSuccess>()
            .having((s) => s.entitlement, 'entitlement', Entitlement.noAds),
      ]),
    );

    await viewModel.restore();
    await statesFuture;
  });
}

class _MockPurchaseRepository extends Mock implements PurchaseRepository {}
