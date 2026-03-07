import 'package:finances_control/feat/profile/screens/preferences/ui/section/appearance_section.dart' show AppearanceSection;
import 'package:finances_control/feat/profile/screens/preferences/ui/section/notifications_section.dart' show NotificationsSection;
import 'package:flutter/material.dart';

import 'section/save_button_section.dart';

class PreferencesBody extends StatelessWidget {
  const PreferencesBody();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(40),
      ),
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: const [

            NotificationsSection(),

            SizedBox(height: 24),

            AppearanceSection(),

            SizedBox(height: 24),

            SaveButton(),

            SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}