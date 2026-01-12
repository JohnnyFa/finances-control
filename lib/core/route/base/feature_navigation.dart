import 'package:flutter/material.dart';

abstract class FeatureNavigation {
  Map<String, WidgetBuilder> get routes;

  @protected
  T? getArguments<T>(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args == null) {
      return null;
    }
    return args as T?;
  }
}