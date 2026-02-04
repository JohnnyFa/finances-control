import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/start/usecase/has_user.dart';
import 'package:finances_control/feat/start/vm/app_start_view_model.dart';

void startInjection() {
  getIt.registerFactory(() => HasUserUseCase(getIt()));
  getIt.registerFactory(() => AppStartViewModel(getIt()));
}
