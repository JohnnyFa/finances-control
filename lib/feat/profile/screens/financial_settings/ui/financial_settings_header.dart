import 'package:flutter/material.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/design_system/design_system.dart';

class FinancialSettingsHeader extends StatelessWidget {
  const FinancialSettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultHeader(
      title: context.appStrings.profile_financial_data,
      subtitle: context.appStrings.manage_your_financial_data,
    );
  }
}
