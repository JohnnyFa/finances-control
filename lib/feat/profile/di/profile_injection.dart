import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/home/usecase/get_user.dart';
import 'package:finances_control/feat/profile/vm/profile_viewmodel.dart';

void profileInjection() {
  if (!getIt.isRegistered<GetUserUseCase>()) {
    getIt.registerLazySingleton(() => GetUserUseCase(getIt()));
  }
  getIt.registerFactory(() => ProfileViewModel(getIt()));
}
