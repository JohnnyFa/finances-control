import 'dart:io';

import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final User user;
  final VoidCallback onAvatarTap;

  const ProfileHeader({super.key, required this.user, required this.onAvatarTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onPrimary = scheme.onPrimary;

    final hasName = user.name.trim().isNotEmpty;
    final hasEmail = (user.email ?? '').trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.primary.withValues(alpha: 0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: onPrimary),
            ),
          ),

          const SizedBox(width: 16),

          GestureDetector(
            onTap: onAvatarTap,
            child: CircleAvatar(
              radius: 24,
              backgroundColor: scheme.surface,
              backgroundImage: user.profileImagePath != null
                  ? FileImage(File(user.profileImagePath!))
                  : null,
              child: user.profileImagePath == null
                  ? Icon(Icons.person, color: scheme.primary)
                  : null,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasName
                      ? user.name
                      : context.appStrings.profile_user_fallback,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: onPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hasEmail
                      ? user.email!
                      : context.appStrings.profile_email_fallback,
                  style: TextStyle(
                    fontSize: 14,
                    color: onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
