import 'package:flutter/material.dart';

extension ContextColorExtensions on BuildContext {
  Color get primary => Theme.of(this).colorScheme.primary;

  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  Color get surface => Theme.of(this).colorScheme.surface;

  Color get textPrimary => Theme.of(this).colorScheme.onSurface;
}
