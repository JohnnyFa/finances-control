import 'package:finances_control/core/analytics/analytics_service.dart';
import 'package:finances_control/feat/start/usecase/has_user.dart';
import 'package:finances_control/feat/start/vm/app_start_state.dart';
import 'package:finances_control/feat/start/vm/app_start_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockHasUserUseCase hasUserUseCase;
  late _MockAnalyticsService analyticsService;
  late AppStartViewModel viewModel;

  setUp(() {
    hasUserUseCase = _MockHasUserUseCase();
    analyticsService = _MockAnalyticsService();
    when(() => analyticsService.trackOnboardingSkipped())
        .thenAnswer((_) async {});
    viewModel = AppStartViewModel(hasUserUseCase, analyticsService);
  });

  tearDown(() async {
    await viewModel.close();
  });

  test('emits home and tracks onboarding skipped when user exists', () async {
    when(() => hasUserUseCase()).thenAnswer((_) async => true);

    final statesFuture = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<AppStartState>((s) => s.status == AppStartStatus.home),
      ]),
    );

    await viewModel.check();
    await statesFuture;

    verify(() => analyticsService.trackOnboardingSkipped()).called(1);
  });

  test('emits onboarding immediately when user does not exist',
      () async {
    when(() => hasUserUseCase()).thenAnswer((_) async => false);

    final statesFuture = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<AppStartState>((s) => s.status == AppStartStatus.onboarding),
      ]),
    );

    await viewModel.check();
    await statesFuture;

    verifyNever(() => analyticsService.trackOnboardingSkipped());
  });

  test('still emits home when analytics fails', () async {
    when(() => hasUserUseCase()).thenAnswer((_) async => true);
    when(() => analyticsService.trackOnboardingSkipped())
        .thenThrow(Exception('analytics'));

    final statesFuture = expectLater(
      viewModel.stream,
      emitsInOrder([
        predicate<AppStartState>((s) => s.status == AppStartStatus.home),
      ]),
    );

    await viewModel.check();
    await statesFuture;

    verify(() => analyticsService.trackOnboardingSkipped()).called(1);
  });
}

class _MockHasUserUseCase extends Mock implements HasUserUseCase {}

class _MockAnalyticsService extends Mock implements AnalyticsService {}
