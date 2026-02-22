import 'package:finances_control/feat/start/vm/app_start_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppStartState named constructors expose correct statuses', () {
    expect(const AppStartState.loading().status, AppStartStatus.loading);
    expect(const AppStartState.onboarding().status, AppStartStatus.onboarding);
    expect(const AppStartState.home().status, AppStartStatus.home);
  });
}
