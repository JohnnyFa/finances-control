
import 'package:finances_control/core/extensions/context_color_extension.dart';
import 'package:finances_control/core/extensions/context_theme_extensions.dart';
import 'package:flutter/material.dart';

class OnboardingProgressBar extends StatelessWidget {
  final int step;
  final int total;

  const OnboardingProgressBar({
    super.key,
    required this.step,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: (step + 1) / total,
      minHeight: 6,
      backgroundColor: context.isDark
          ? Colors.white12
          : Colors.black12,
      color: context.primary,
    );
  }
}
