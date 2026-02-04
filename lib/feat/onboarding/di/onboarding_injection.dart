import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/onboarding/data/dao/user_dao.dart';
import 'package:finances_control/feat/onboarding/data/repo/user_repository.dart';
import 'package:finances_control/feat/onboarding/data/repo/user_repository_impl.dart';
import 'package:finances_control/feat/onboarding/usecase/save_user.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_viewmodel.dart';

void onboardingInjection() {
  getIt.registerLazySingleton<UserDao>(() => UserDao(getIt()));
  getIt.registerLazySingleton<UserRepository>(
        () => UserRepositoryImpl(getIt()),
  );
  getIt.registerFactory(() => SaveUserUseCase(getIt()));
  getIt.registerFactory(() => OnboardingViewModel(saveUserUseCase: getIt()));
}
