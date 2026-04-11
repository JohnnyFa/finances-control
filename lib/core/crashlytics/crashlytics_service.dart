abstract class CrashlyticsService {
  Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });

  Future<void> log(String message);

  Future<void> setUserId(String userId);

  Future<void> setCustomKey(String key, dynamic value);

  Future<void> recordUnexpectedError(
    Object error,
    StackTrace stackTrace,
    String reason,
  );
}
