import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService(this._analytics);

  final FirebaseAnalytics _analytics;

  Future<void> logEvent(
    String name, {
    Map<String, Object?>? parameters,
  }) {
    return _analytics.logEvent(
      name: _normalizeEventName(name),
      parameters: _sanitizeParameters(parameters),
    );
  }

  Future<void> logScreenView(String screenName) {
    return _analytics.logScreenView(screenName: screenName);
  }

  Future<void> logAppOpen() {
    return _analytics.logAppOpen();
  }

  Future<void> logClick(
    String name, {
    Map<String, Object?>? parameters,
  }) {
    return logEvent(
      'click',
      parameters: {
        'name': _normalizeEventName(name),
        ...?parameters,
      },
    );
  }

  String _normalizeEventName(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_+|_+$'), '');

    if (normalized.isEmpty) {
      return 'unknown_event';
    }

    return normalized;
  }

  Map<String, Object>? _sanitizeParameters(Map<String, Object?>? parameters) {
    if (parameters == null) return null;

    final sanitized = <String, Object>{};

    for (final entry in parameters.entries) {
      final value = entry.value;

      if (value == null) continue;

      if (value is num || value is String) {
        sanitized[entry.key] = value;
        continue;
      }

      if (value is bool) {
        sanitized[entry.key] = value.toString();
        continue;
      }

      sanitized[entry.key] = value.toString();
    }

    if (sanitized.isEmpty) {
      return null;
    }

    return sanitized;
  }
}
