import 'package:finances_control/core/logger/app_logger.dart';
import 'package:flutter/material.dart';

/// A [RouteObserver] that logs page navigation events to the terminal
/// in debug mode.
///
/// PRIVACY: Only route *names* (e.g. `/home`) are logged — never
/// route arguments, query parameters, or any user data.
class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    final name = route.settings.name ?? route.runtimeType.toString();
    final prev = previousRoute?.settings.name;
    AppLogger.route(
      'Push  → $name${prev != null ? ' (from $prev)' : ''}',
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    final name = route.settings.name ?? route.runtimeType.toString();
    final prev = previousRoute?.settings.name;
    AppLogger.route(
      'Pop   ← $name${prev != null ? ' (to $prev)' : ''}',
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    final name = newRoute?.settings.name ?? newRoute?.runtimeType.toString();
    final old = oldRoute?.settings.name;
    AppLogger.route(
      'Replace → $name${old != null ? ' (was $old)' : ''}',
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    final name = route.settings.name ?? route.runtimeType.toString();
    AppLogger.route('Remove  → $name');
  }
}
