import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:finances_control/feat/profile/ui/widget/logout_button.dart';
import 'package:finances_control/feat/profile/ui/widget/profile_section_card.dart';
import 'package:finances_control/feat/profile/ui/widget/profile_tile.dart';
import 'package:flutter/material.dart';

class ProfileBody extends StatelessWidget {
  final User user;
  final bool isLoading;

  final VoidCallback onFinancialTap;
  final VoidCallback onAccountTap;
  final VoidCallback onPreferencesTap;
  final VoidCallback onAboutTap;

  const ProfileBody({
    super.key,
    required this.user,
    required this.isLoading,
    required this.onFinancialTap,
    required this.onAccountTap,
    required this.onPreferencesTap,
    required this.onAboutTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(40),
      ),
      child: ColoredBox(
        color: scheme.surface,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          children: [
            /// drag indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            if (isLoading) ...[
              const LinearProgressIndicator(),
              const SizedBox(height: 24),
            ],

            /// ACCOUNT
            ProfileSectionCard(
              title: context.appStrings.profile_account.toUpperCase(),
              children: [
                ProfileTile(
                  icon: '👤',
                  title: context.appStrings.profile_name,
                  subtitle: user.name.trim().isNotEmpty
                      ? user.name
                      : context.appStrings.profile_not_informed,
                  onTap: onAccountTap,
                ),
                ProfileTile(
                  icon: '📧',
                  title: context.appStrings.profile_email,
                  subtitle: (user.email ?? '').trim().isNotEmpty
                      ? user.email!
                      : context.appStrings.profile_not_informed,
                  onTap: onAccountTap,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// FINANCIAL
            ProfileSectionCard(
              title: context.appStrings.profile_financial_data,
              children: [
                ProfileTile(
                  icon: '💰',
                  title: context.appStrings.profile_monthly_income,
                  subtitle: formatCurrencyFromCents(context, user.salary),
                  onTap: onFinancialTap,
                ),
                ProfileTile(
                  icon: '🏦',
                  title: context.appStrings.profile_savings_goal,
                  subtitle: formatCurrencyFromCents(
                    context,
                    user.amountToSaveByMonth ?? 0,
                  ),
                  onTap: onFinancialTap,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// PREFERENCES
            ProfileSectionCard(
              title: context.appStrings.profile_preferences.toUpperCase(),
              children: [
                ProfileTile(
                  icon: '🔔',
                  title: context.appStrings.profile_notifications,
                  subtitle: context.appStrings.profile_enabled,
                  onTap: onPreferencesTap,
                ),
                ProfileTile(
                  icon: '🎨',
                  title: context.appStrings.profile_theme,
                  subtitle: context.appStrings.profile_light,
                  onTap: onPreferencesTap,
                ),
                ProfileTile(
                  icon: '📅',
                  title: context.appStrings.profile_categories,
                  subtitle: context.appStrings.profile_manage,
                  onTap: onPreferencesTap,
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ABOUT
            ProfileSectionCard(
              title: context.appStrings.profile_about,
              children: [
                ProfileTile(
                  icon: 'ℹ️',
                  title: context.appStrings.profile_about_app,
                  subtitle: context.appStrings.profile_app_version,
                  onTap: onAboutTap,
                ),
                ProfileTile(
                  icon: '❓',
                  title: context.appStrings.profile_help_and_support,
                  subtitle: context.appStrings.profile_help_center,
                  onTap: onAboutTap,
                ),
                ProfileTile(
                  icon: '📄',
                  title: context.appStrings.profile_terms_and_privacy,
                  subtitle: '',
                  onTap: onAboutTap,
                ),
              ],
            ),

            const SizedBox(height: 24),

            const LogoutButton(),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}