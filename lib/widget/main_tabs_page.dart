import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/ebooks/ui/ebooks_page.dart';
import 'package:finances_control/feat/ebooks/vm/ebooks_viewmodel.dart';
import 'package:finances_control/feat/home/ui/home_page.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/profile/ui/profile_page.dart';
import 'package:finances_control/feat/profile/vm/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainTabsPage extends StatefulWidget {
  final int initialIndex;

  const MainTabsPage({super.key, this.initialIndex = 0});

  @override
  State<MainTabsPage> createState() => _MainTabsPageState();
}

class _MainTabsPageState extends State<MainTabsPage> {
  static const int _tabCount = 3;

  late int _currentIndex;
  late final List<Widget?> _tabPages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabPages = List<Widget?>.filled(_tabCount, null, growable: false);
    _ensureTabCreated(_currentIndex);
  }

  @override
  void didUpdateWidget(covariant MainTabsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentIndex = widget.initialIndex;
      _ensureTabCreated(_currentIndex);
    }
  }

  void _onTabSelected(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
      _ensureTabCreated(index);
    });
  }

  void _ensureTabCreated(int index) {
    _tabPages[index] ??= _buildTab(index);
  }

  Widget _buildTab(int index) {
    return switch (index) {
      0 => BlocProvider<HomeViewModel>(
          create: (_) => getIt<HomeViewModel>(),
          child: HomePage(onTabSelected: _onTabSelected),
        ),
      1 => BlocProvider<EbooksViewModel>(
          create: (_) => getIt<EbooksViewModel>(),
          child: EbooksPage(onTabSelected: _onTabSelected),
        ),
      2 => BlocProvider<ProfileViewModel>(
          create: (_) => getIt<ProfileViewModel>(),
          child: ProfilePage(onTabSelected: _onTabSelected),
        ),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentIndex,
      children: List<Widget>.generate(
        _tabCount,
        (index) => _tabPages[index] ?? const SizedBox.shrink(),
      ),
    );
  }
}
