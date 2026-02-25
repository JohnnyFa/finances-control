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

  const ProfileBody({
    super.key,
    required this.user,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(40),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (isLoading) ...[
            const LinearProgressIndicator(),
            const SizedBox(height: 24),
          ],
          ProfileSectionCard(
            title: context.appStrings.profile_financial_data,
            children: [
              ProfileTile(
                icon: '💰',
                title: context.appStrings.profile_monthly_income,
                subtitle: formatCurrency(context, user.salary),
              ),
              ProfileTile(
                icon: '🏦',
                title: context.appStrings.profile_savings_goal,
                subtitle: formatCurrency(context, user.amountToSaveByMonth ?? 0),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ProfileSectionCard(
            title: context.appStrings.profile_account,
            children: [
              ProfileTile(
                icon: '👤',
                title: context.appStrings.profile_name,
                subtitle: user.name.trim().isNotEmpty
                    ? user.name
                    : context.appStrings.profile_not_informed,
              ),
              ProfileTile(
                icon: '📧',
                title: context.appStrings.profile_email,
                subtitle: (user.email ?? '').trim().isNotEmpty
                    ? user.email!
                    : context.appStrings.profile_not_informed,
              ),
              ProfileTile(
                icon: '🔒',
                title: context.appStrings.profile_password,
                subtitle: '••••••••',
              ),
            ],
          ),
          const SizedBox(height: 24),
          const LogoutButton(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
