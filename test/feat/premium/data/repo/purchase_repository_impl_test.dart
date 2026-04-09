import 'package:finances_control/feat/premium/data/datasource/local_purchase_data_source.dart';
import 'package:finances_control/feat/premium/data/datasource/play_billling_data_source.dart';
import 'package:finances_control/feat/premium/data/model/product_ids.dart';
import 'package:finances_control/feat/premium/data/repo/purchase_repository_impl.dart';
import 'package:finances_control/feat/premium/domain/entitlement.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockLocalPurchaseDataSource local;
  late _MockPlayBillingDataSource billing;
  late PurchaseRepositoryImpl repository;

  setUp(() {
    local = _MockLocalPurchaseDataSource();
    billing = _MockPlayBillingDataSource();
    repository = PurchaseRepositoryImpl(local, billing);
  });

  test('restorePurchases saves premium when Play Billing returns premium sku', () async {
    when(() => billing.restore())
        .thenAnswer((_) async => [ProductIds.premiumMonthly]);
    when(() => local.saveEntitlement(Entitlement.premium))
        .thenAnswer((_) async {});

    final entitlement = await repository.restorePurchases();

    expect(entitlement, Entitlement.premium);
    verify(() => local.saveEntitlement(Entitlement.premium)).called(1);
  });

  test('restorePurchases keeps cached entitlement when billing is unavailable',
      () async {
    when(() => billing.restore()).thenThrow(const BillingUnavailableException());
    when(() => local.getEntitlement()).thenAnswer((_) async => Entitlement.noAds);

    final entitlement = await repository.restorePurchases();

    expect(entitlement, Entitlement.noAds);
    verify(() => local.getEntitlement()).called(1);
    verifyNever(() => local.saveEntitlement(Entitlement.free));
    verifyNever(() => local.saveEntitlement(Entitlement.noAds));
    verifyNever(() => local.saveEntitlement(Entitlement.premium));
  });
}

class _MockLocalPurchaseDataSource extends Mock
    implements LocalPurchaseDataSource {}

class _MockPlayBillingDataSource extends Mock implements PlayBillingDataSource {}
