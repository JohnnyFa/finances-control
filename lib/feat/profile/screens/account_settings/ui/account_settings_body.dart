import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';

import '../../../../onboarding/ui/widgets/app_text_field.dart';
import '../vm/account_settings_state.dart';
import '../vm/account_settings_vm.dart';

class AccountSettingsBody extends StatefulWidget {
  const AccountSettingsBody({super.key});

  @override
  State<AccountSettingsBody> createState() => _AccountSettingsBodyState();
}

class _AccountSettingsBodyState extends State<AccountSettingsBody> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      child: ColoredBox(
        color: scheme.surface,
        child: BlocListener<AccountSettingsViewModel, AccountSettingsState>(
          listener: (context, state) {

            if (state is AccountSettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }

            /// Preenche o form apenas quando carregar
            if (state is AccountSettingsLoaded) {
              nameController.text = state.name ?? '';
              emailController.text = state.email ?? '';
            }
          },
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
                    AppTextField(
                      hintText: context.appStrings.profile_name,
                      controller: nameController,
                      prefixIcon: const Icon(Icons.person_outline),
                    ),

                    const SizedBox(height: 20),

                    /// EMAIL
                    AppTextField(
                      hintText: context.appStrings.profile_email,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),

                    const SizedBox(height: 40),

                    ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim();
                        final email = emailController.text.trim();

                        context.read<AccountSettingsViewModel>().save(
                          name: name,
                          email: email,
                        );
                      },
                      child: Text(context.appStrings.save_changes),
                    ),
                  ],
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
