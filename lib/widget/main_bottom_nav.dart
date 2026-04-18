import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/route/path/app_route_path.dart';
import 'package:finances_control/feat/ebooks/route/ebooks_path.dart';
import 'package:finances_control/feat/profile/route/profile_path.dart';
import 'package:flutter/material.dart';

class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onDestinationSelected;

  const MainBottomNav({
    super.key,
    required this.currentIndex,
    this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) {
        if (onDestinationSelected != null) {
          onDestinationSelected!(index);
          return;
        }

        final currentRoute = ModalRoute.of(context)?.settings.name;
        final targetRoute = switch (index) {
          0 => AppRoutePath.homePage.path,
          1 => EbooksPath.ebooks.path,
          2 => ProfilePath.profile.path,
          _ => AppRoutePath.homePage.path,
        };

        if (currentRoute == targetRoute) return;

        Navigator.of(context).pushReplacementNamed(targetRoute);
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: context.appStrings.nav_home,
        ),
        NavigationDestination(
          icon: const Icon(Icons.menu_book_outlined),
          selectedIcon: const Icon(Icons.menu_book),
          label: context.appStrings.nav_ebooks,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: context.appStrings.profile,
        ),
      ],
    );
  }
}
