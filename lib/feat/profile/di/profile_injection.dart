import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/profile/screens/account_settings/vm/account_settings_vm.dart';
import 'package:finances_control/feat/profile/screens/financial_settings/vm/financial_settings_vm.dart';
import 'package:finances_control/feat/profile/screens/preferences/vm/preferences_vm.dart';
import 'package:finances_control/feat/profile/vm/profile_viewmodel.dart';

void profileInjection() {
  getIt.registerFactory(
    () => ProfileViewModel(imageService: getIt(), userRepository: getIt()),
  );
  getIt.registerFactory(() => AccountSettingsViewModel(getIt()));
  getIt.registerFactory(() => FinancialSettingsViewModel(getIt()));
  getIt.registerLazySingleton(() => PreferencesViewModel());
}
