
import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/profile/vm/profile_viewmodel.dart';

void profileInjection() {
  getIt.registerFactory(() => ProfileViewModel());
}
