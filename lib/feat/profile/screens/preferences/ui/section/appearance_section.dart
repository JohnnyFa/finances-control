import 'package:finances_control/feat/profile/screens/preferences/ui/widget/section_card.dart';
import 'package:finances_control/feat/profile/screens/preferences/ui/widget/theme_tile.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: context.appStrings.preferences_appearance,
      children: [
        ThemeTile(icon: "☀️", title: context.appStrings.preferences_light_mode, selected: true),
        ThemeTile(icon: "🌙", title: context.appStrings.preferences_dark_mode),
        ThemeTile(icon: "🌗", title: context.appStrings.preferences_automatic),
      ],
    );
  }
}