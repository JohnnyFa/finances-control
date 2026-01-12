import 'package:finances_control/feat/homepage/di/home_injection.dart';
import 'package:finances_control/l10n_helper.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(AppStrings.new);
  homeInjection();
}