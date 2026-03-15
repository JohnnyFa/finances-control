import 'package:flutter/material.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/profile/screens/widget/profile_settings_header.dart';

class FinancialSettingsHeader extends StatelessWidget {
  const FinancialSettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsHeader(
      title: context.appStrings.profile_financial_data,
      subtitle: context.appStrings.manage_your_financial_data,
    );
  }
}
