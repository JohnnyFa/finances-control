import 'package:finances_control/feat/onboarding/vm/onboarding_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnboardingState', () {
    test('initial has expected defaults', () {
      final state = OnboardingState.initial();

      expect(state.step, 0);
      expect(state.name, '');
      expect(state.isNameValid, isFalse);
      expect(state.status, OnboardingStatus.initial);
    });

    test('copyWith updates fields and clears validation error', () {
      final state = OnboardingState.initial().copyWith(validationError: 'error');

      final updated = state.copyWith(
        step: 1,
        name: 'John',
        isNameValid: true,
        clearValidationError: true,
      );

      expect(updated.step, 1);
      expect(updated.name, 'John');
      expect(updated.isNameValid, isTrue);
      expect(updated.validationError, isNull);
    });
  });
}
