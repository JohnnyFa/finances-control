import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/services/update/update_service.dart';
import 'package:finances_control/core/services/update/update_service_factory.dart';

void updateServiceInjection() {
  getIt.registerLazySingleton<UpdateService>(createUpdateService);
}
