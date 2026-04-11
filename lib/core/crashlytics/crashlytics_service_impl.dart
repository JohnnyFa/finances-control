import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'crashlytics_service.dart';

class CrashlyticsServiceImpl implements CrashlyticsService {
  CrashlyticsServiceImpl(this._crashlytics);

  final FirebaseCrashlytics _crashlytics;

  @override
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) {
    return _crashlytics.recordError(
      exception,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  @override
  Future<void> log(String message) {
    return _crashlytics.log(message);
  }

  @override
  Future<void> setUserId(String userId) {
    return _crashlytics.setUserIdentifier(userId);
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) {
    return _crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> recordUnexpectedError(
    Object error,
    StackTrace stackTrace,
    String reason,
  ) async {
    await log('Unexpected error: $reason');
    await recordError(error, stackTrace, reason: reason);
  }
}
