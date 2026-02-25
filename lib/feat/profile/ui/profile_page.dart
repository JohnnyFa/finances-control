import 'package:finances_control/feat/profile/ui/body/profile_body.dart';
import 'package:finances_control/feat/profile/ui/header/profile_header.dart';
import 'package:finances_control/feat/profile/vm/profile_state.dart';
import 'package:finances_control/feat/profile/vm/profile_viewmodel.dart';
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
          return Column(
            children: [
              ProfileHeader(user: state.user),
              Expanded(
                child: ProfileBody(
                  user: state.user,
                  isLoading: state.status == ProfileStatus.loading,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
