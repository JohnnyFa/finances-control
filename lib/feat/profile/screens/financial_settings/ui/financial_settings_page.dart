import 'package:finances_control/feat/profile/screens/financial_settings/ui/financial_settings_body.dart';
import 'package:finances_control/feat/profile/screens/financial_settings/ui/financial_settings_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../vm/financial_settings_vm.dart';

class FinancialSettingsPage extends StatefulWidget {
  const FinancialSettingsPage({super.key});

  @override
  State<FinancialSettingsPage> createState() => _FinancialSettingsPageState();
}

class _FinancialSettingsPageState extends State<FinancialSettingsPage> {

  @override
  void initState() {
    super.initState();
    context.read<FinancialSettingsViewModel>().load();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.primary,
      body: Column(
        children: [
          const FinancialSettingsHeader(),
          Expanded(
            child: FinancialSettingsBody(),
          ),
        ],
      ),
    );
  }
}