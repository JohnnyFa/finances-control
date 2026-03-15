import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/profile/screens/widget/profile_settings_header.dart';
import 'package:flutter/material.dart';

class AccountSettingsHeader extends StatelessWidget {
  const AccountSettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsHeader(
      title: context.appStrings.profile_account,
      subtitle: context.appStrings.profile_manage,
    );
  }
}
