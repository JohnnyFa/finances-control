import 'package:flutter/material.dart';

class OnboardingPreviousButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const OnboardingPreviousButton({
    super.key,
    required this.onPressed,
    this.label = 'Voltar',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton.icon(
      onPressed: onPressed,
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.onSurface
            .withValues(alpha: 0.7),
        textStyle: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}