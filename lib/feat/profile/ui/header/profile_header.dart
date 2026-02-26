import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final User user;

  const ProfileHeader({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onPrimary = scheme.onPrimary;
    final hasName = user.name.trim().isNotEmpty;
    final hasEmail = (user.email ?? '').trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primary.withValues(alpha: 0.85)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: onPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: onPrimary),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.surface,
                ),
                child: Icon(
                  Icons.account_circle,
                  color: scheme.primary,
                  size: 104,
                ),
              ),
              Positioned(
                right: -2,
                bottom: 4,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: scheme.surface,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '✨',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            hasName ? user.name : context.appStrings.profile_user_fallback,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: onPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasEmail ? user.email! : context.appStrings.profile_email_fallback,
            style: TextStyle(
              fontSize: 18,
              color: onPrimary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
