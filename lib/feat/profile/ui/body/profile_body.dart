import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:finances_control/feat/profile/screens/about/ui/show_helper_sheet.dart';
import 'package:finances_control/feat/profile/screens/about/ui/show_privacy_policy.dart';
import 'package:finances_control/feat/profile/screens/preferences/vm/preferences_state.dart';
import 'package:finances_control/feat/profile/screens/preferences/vm/preferences_vm.dart';
import 'package:finances_control/feat/profile/ui/widget/profile_section_card.dart';
import 'package:finances_control/feat/profile/ui/widget/profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileBody extends StatefulWidget {
  final User user;
  final bool isLoading;

  final VoidCallback onFinancialTap;
  final VoidCallback onAccountTap;
  final VoidCallback onPreferencesTap;

  const ProfileBody({
    super.key,
    required this.user,
    required this.isLoading,
    required this.onFinancialTap,
    required this.onAccountTap,
    required this.onPreferencesTap,
  });

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        _appVersion = context.appStrings.unknown;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ColoredBox(
      color: scheme.surface,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        children: [
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

          if (widget.isLoading) ...[
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
                subtitle: widget.user.name.trim().isNotEmpty
                    ? widget.user.name
                    : context.appStrings.profile_not_informed,
                onTap: widget.onAccountTap,
              ),
              ProfileTile(
                icon: '📧',
                title: context.appStrings.profile_email,
                subtitle: (widget.user.email ?? '').trim().isNotEmpty
                    ? widget.user.email!
                    : context.appStrings.profile_not_informed,
                onTap: widget.onAccountTap,
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// FINANCIAL
          ProfileSectionCard(
            title: context.appStrings.profile_financial_data.toUpperCase(),
            children: [
              ProfileTile(
                icon: '💰',
                title: context.appStrings.profile_monthly_income,
                subtitle: formatCurrencyFromCents(
                  context,
                  widget.user.salary,
                ),
                onTap: widget.onFinancialTap,
              ),
              ProfileTile(
                icon: '🏦',
                title: context.appStrings.profile_savings_goal,
                subtitle: formatCurrencyFromCents(
                  context,
                  widget.user.amountToSaveByMonth ?? 0,
                ),
                onTap: widget.onFinancialTap,
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
                onTap: widget.onPreferencesTap,
              ),
              BlocSelector<PreferencesViewModel, PreferencesState, ThemeMode>(
                selector: (state) {
                  if (state is PreferencesLoaded) {
                    return state.themeMode;
                  }
                  return ThemeMode.system;
                },
                builder: (context, themeMode) {
                  return ProfileTile(
                    icon: '🎨',
                    title: context.appStrings.profile_theme,
                    subtitle: themeLabel(context, themeMode),
                    onTap: widget.onPreferencesTap,
                  );
                },
              ),
              ProfileTile(
                icon: '📅',
                title: context.appStrings.profile_categories,
                subtitle: context.appStrings.profile_manage,
                onTap: widget.onPreferencesTap,
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// ABOUT
          ProfileSectionCard(
            title: context.appStrings.profile_about.toUpperCase(),
            children: [
              ProfileTile(
                icon: 'ℹ️',
                title: context.appStrings.profile_about_app,
                subtitle: _appVersion,
              ),
              ProfileTile(
                icon: '❓',
                title: context.appStrings.profile_help_and_support,
                subtitle: context.appStrings.profile_help_center,
                onTap: () => showHelpSheet(context),
              ),
              ProfileTile(
                icon: '📄',
                title: context.appStrings.profile_terms_and_privacy,
                subtitle: '',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PrivacyPolicyPage(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // const LogoutButton(),
          //
          // const SizedBox(height: 60),
        ],
      ),
    );
  }
}

String themeLabel(BuildContext context, ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return context.appStrings.profile_light;

    case ThemeMode.dark:
      return context.appStrings.profile_dark;

    case ThemeMode.system:
      return context.appStrings.profile_automatic;
  }
}
