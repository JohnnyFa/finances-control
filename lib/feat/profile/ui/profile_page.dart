import 'package:finances_control/feat/profile/ui/body/profile_body.dart';
import 'package:finances_control/feat/profile/ui/header/profile_header.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.primary,
      body: Column(
        children: const [
          ProfileHeader(),
          Expanded(child: ProfileBody()),
        ],
      ),
    );
  }
}
