import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';

void homeInjection() {
  getIt
    .registerFactory(() => HomeViewModel());
}