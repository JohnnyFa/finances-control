import 'package:flutter/material.dart';

extension ContextThemeExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}