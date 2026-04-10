import 'package:finances_control/feat/premium/domain/entitlement.dart';
import 'package:finances_control/feat/premium/usecases/restore_purchases.dart';
import 'package:finances_control/feat/start/usecase/has_user.dart';
import 'package:finances_control/feat/start/vm/app_start_state.dart';
import 'package:finances_control/feat/start/vm/app_start_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockHasUserUseCase hasUserUseCase;
  late _MockRestorePurchasesUseCase restorePurchasesUseCase;
  late AppStartViewModel viewModel;

  setUp(() {
    hasUserUseCase = _MockHasUserUseCase();
    restorePurchasesUseCase = _MockRestorePurchasesUseCase();
    viewModel = AppStartViewModel(hasUserUseCase, restorePurchasesUseCase);
  });

  tearDown(() async {
    await viewModel.close();
  });

  test('emits home and restores purchases when user exists', () async {
    when(() => hasUserUseCase()).thenAnswer((_) async => true);
    when(() => restorePurchasesUseCase())
        .thenAnswer((_) async => Entitlement.free);

    final statesFuture = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<AppStartState>((s) => s.status == AppStartStatus.home),
      ]),
    );

    await viewModel.check();
    await statesFuture;

    verify(() => restorePurchasesUseCase()).called(1);
  });

  test('emits onboarding and restores purchases when user does not exist',
      () async {
    when(() => hasUserUseCase()).thenAnswer((_) async => false);
    when(() => restorePurchasesUseCase())
        .thenAnswer((_) async => Entitlement.free);

    final statesFuture = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<AppStartState>((s) => s.status == AppStartStatus.onboarding),
      ]),
    );

    await viewModel.check();
    await statesFuture;

    verify(() => restorePurchasesUseCase()).called(1);
  });

  test('still emits home when restore fails', () async {
    when(() => hasUserUseCase()).thenAnswer((_) async => true);
    when(() => restorePurchasesUseCase()).thenThrow(Exception('network'));

    final statesFuture = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<AppStartState>((s) => s.status == AppStartStatus.home),
      ]),
    );

    await viewModel.check();
    await statesFuture;

    verify(() => restorePurchasesUseCase()).called(1);
  });
}

class _MockHasUserUseCase extends Mock implements HasUserUseCase {}

class _MockRestorePurchasesUseCase extends Mock
    implements RestorePurchasesUseCase {}
