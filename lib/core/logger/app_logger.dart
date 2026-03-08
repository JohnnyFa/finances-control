import 'package:flutter/foundation.dart';

/// A debug-only logger for the app.
/// All methods are no-ops in release mode via [kDebugMode].
/// No user data, financial values, or sensitive fields are ever logged.
abstract final class AppLogger {
  static void route(String message) {
    if (kDebugMode) debugPrint('🗺️  [ROUTE] $message');
  }

  static void bloc(String message) {
    if (kDebugMode) debugPrint('🧠 [BLOC]  $message');
  }

  static void http(String message) {
    if (kDebugMode) debugPrint('🌐 [HTTP]  $message');
  }

  static void error(String message) {
    if (kDebugMode) debugPrint('🔴 [ERROR] $message');
  }

  static void info(String message) {
    if (kDebugMode) debugPrint('ℹ️  [INFO]  $message');
  }
}
