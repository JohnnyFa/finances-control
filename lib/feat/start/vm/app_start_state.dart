enum AppStartStatus { loading, onboarding, home }

class AppStartState {
  final AppStartStatus status;

  const AppStartState(this.status);

  const AppStartState.loading() : status = AppStartStatus.loading;
  const AppStartState.onboarding() : status = AppStartStatus.onboarding;
  const AppStartState.home() : status = AppStartStatus.home;
}
