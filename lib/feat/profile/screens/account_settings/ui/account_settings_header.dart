import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/design_system/design_system.dart';
import 'package:flutter/material.dart';

class AccountSettingsHeader extends StatelessWidget {
  const AccountSettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultHeader(
      title: context.appStrings.profile_account,
      subtitle: context.appStrings.profile_manage,
    );
  }
}
