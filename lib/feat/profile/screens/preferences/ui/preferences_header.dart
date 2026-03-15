import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/profile/screens/widget/profile_settings_header.dart';
import 'package:flutter/material.dart';

class PreferencesHeader extends StatelessWidget {
  const PreferencesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsHeader(
      title: context.appStrings.profile_preferences,
      subtitle: context.appStrings.preferences_personalize,
    );
  }
}