import 'package:finances_control/feat/profile/route/profile_path.dart';
import 'package:finances_control/feat/profile/ui/body/profile_body.dart';
import 'package:finances_control/feat/profile/ui/header/profile_header.dart';
import 'package:finances_control/feat/profile/vm/profile_state.dart';
import 'package:finances_control/feat/profile/vm/profile_viewmodel.dart';
import 'package:finances_control/widget/main_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.primary,
      body: BlocBuilder<ProfileViewModel, ProfileState>(
        builder: (context, state) {
          final vm = context.read<ProfileViewModel>();

          return Column(
            children: [
              ProfileHeader(
                user: state.user,
                onAvatarTap: vm.changeProfilePicture,
              ),

              Expanded(
                child: ProfileBody(
                  user: state.user,
                  isLoading: state.status == ProfileStatus.loading,
                  onFinancialTap: () => Navigator.of(
                    context,
                  ).pushNamed(ProfilePath.financialSettings.path),
                  onAccountTap: () async {
                    final hasUpdated = await Navigator.of(
                      context,
                    ).pushNamed(ProfilePath.accountSettings.path);

                    if (hasUpdated == true && context.mounted) {
                      context.read<ProfileViewModel>().load();
                    }
                  },
                  onPreferencesTap: () => Navigator.of(
                    context,
                  ).pushNamed(ProfilePath.preferences.path),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const MainBottomNav(currentIndex: 2),

    );
  }
}
