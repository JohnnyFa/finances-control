import 'package:finances_control/feat/profile/screens/account_settings/ui/account_settings_body.dart';
import 'package:finances_control/feat/profile/screens/account_settings/ui/account_settings_header.dart';
import 'package:finances_control/feat/profile/screens/account_settings/vm/account_settings_state.dart';
import 'package:finances_control/feat/profile/screens/account_settings/vm/account_settings_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountSettingsViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.primary,
      body: BlocBuilder<AccountSettingsViewModel, AccountSettingsState>(
        builder: (context, state) {
          return Column(
            children: [
              AccountSettingsHeader(),
              const Expanded(child: AccountSettingsBody()),
            ],
          );
        },
      ),
    );
  }
}
