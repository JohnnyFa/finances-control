import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/components/default_header.dart';
import 'package:flutter/material.dart';

class PreferencesHeader extends StatelessWidget {
  const PreferencesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultHeader(
      title: context.appStrings.profile_preferences,
      subtitle: context.appStrings.preferences_personalize,
    );
  }
}