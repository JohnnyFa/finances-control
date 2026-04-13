import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/ebooks/ui/ebooks_page.dart';
import 'package:finances_control/feat/ebooks/vm/ebooks_viewmodel.dart';
import 'package:finances_control/feat/home/ui/home_page.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_viewmodel.dart';
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
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didUpdateWidget(covariant MainTabsPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialIndex != widget.initialIndex) {
      _currentIndex = widget.initialIndex;
    }
  }

  void _onTabSelected(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeViewModel>(create: (_) => getIt<HomeViewModel>()),
        BlocProvider<EbooksViewModel>(create: (_) => getIt<EbooksViewModel>()),
        BlocProvider<ProfileViewModel>(
          create: (_) => getIt<ProfileViewModel>(),
        ),
        BlocProvider<PurchaseViewModel>(
          create: (_) => getIt<PurchaseViewModel>()..load(),
        ),
      ],
      child: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(currentIndex: _currentIndex, onTabSelected: _onTabSelected),
          EbooksPage(
            currentIndex: _currentIndex,
            onTabSelected: _onTabSelected,
          ),
          ProfilePage(
            currentIndex: _currentIndex,
            onTabSelected: _onTabSelected,
          ),
        ],
      ),
    );
  }
}
