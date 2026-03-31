import 'package:finances_control/design_system/design_system.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class NewTransactionHeader extends StatelessWidget {
  final VoidCallback onBack;

  const NewTransactionHeader({
    super.key,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultHeader(
      title: context.appStrings.new_transaction,
      subtitle: context.appStrings.fill_in_details,
      type: HeaderType.neutral,
      onBack: onBack,
    );
  }
}
