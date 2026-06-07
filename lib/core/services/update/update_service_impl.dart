import 'dart:io';

import 'package:finances_control/core/services/update/update_service.dart';
import 'package:in_app_update/in_app_update.dart';

class UpdateServiceImpl implements UpdateService {
  @override
  Future<void> checkForUpdate() async {
    if (!Platform.isAndroid) return;

    try {
      final info = await InAppUpdate.checkForUpdate();

      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.startFlexibleUpdate();
      }
    } catch (_) {
      // Update checks are best-effort — never crash the app over them.
    }
  }
}
