import 'package:finances_control/feat/profile/screens/preferences/ui/widget/section_card.dart';
import 'package:finances_control/feat/profile/screens/preferences/ui/widget/theme_tile.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../vm/preferences_state.dart';
import '../../vm/preferences_vm.dart';

class AppearanceSection extends StatelessWidget {
  const AppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferencesViewModel, PreferencesState>(
      builder: (context, state) {

        if (state is! PreferencesLoaded) {
          return const SizedBox();
        }

        final themeMode = state.themeMode;

        return SectionCard(
          title: context.appStrings.preferences_appearance,
          children: [

            ThemeTile(
              icon: "☀️",
              title: context.appStrings.preferences_light_mode,
              selected: themeMode == ThemeMode.light,
              onTap: () => context
                  .read<PreferencesViewModel>()
                  .changeTheme(ThemeMode.light),
            ),

            ThemeTile(
              icon: "🌙",
              title: context.appStrings.preferences_dark_mode,
              selected: themeMode == ThemeMode.dark,
              onTap: () => context
                  .read<PreferencesViewModel>()
                  .changeTheme(ThemeMode.dark),
            ),

            ThemeTile(
              icon: "🌗",
              title: context.appStrings.preferences_automatic,
              selected: themeMode == ThemeMode.system,
              onTap: () => context
                  .read<PreferencesViewModel>()
                  .changeTheme(ThemeMode.system),
            ),
          ],
        );
      },
    );
  }
}