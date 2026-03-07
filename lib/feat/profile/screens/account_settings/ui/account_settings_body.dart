import 'package:finances_control/feat/profile/screens/account_settings/vm/account_settings_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../vm/account_settings_state.dart';

class AccountSettingsBody extends StatelessWidget {
  const AccountSettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(40),
      ),
      child: ColoredBox(
        color: scheme.surface,
        child: BlocBuilder<AccountSettingsViewModel, AccountSettingsState>(
          builder: (context, state) {

            if (state is AccountSettingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AccountSettingsLoaded) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: [

                  /// NAME
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Nome",
                    ),
                    controller: TextEditingController(text: state.name),
                    onChanged: (value) {
                      context.read<AccountSettingsViewModel>().updateName(value);
                    },
                  ),

                  const SizedBox(height: 20),

                  /// EMAIL
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                    controller: TextEditingController(text: state.email),
                    onChanged: (value) {
                      context.read<AccountSettingsViewModel>().updateEmail(value);
                    },
                  ),

                  const SizedBox(height: 40),

                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Salvar alterações"),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}