import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: scheme.errorContainer.withValues(alpha: 0.25),
        border: Border.all(
          color: scheme.error.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '🚪 ${context.appStrings.logout_account}',
          style: TextStyle(
            color: scheme.error,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
