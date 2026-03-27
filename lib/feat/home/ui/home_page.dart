import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/ads/ui/banner_add_widget.dart';
import 'package:finances_control/feat/ebooks/ui/ebooks_page.dart';
import 'package:finances_control/feat/ebooks/vm/ebooks_viewmodel.dart';
import 'package:finances_control/feat/home/ui/home_body.dart';
import 'package:finances_control/feat/home/ui/home_header.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/profile/ui/profile_page.dart';
import 'package:finances_control/feat/profile/vm/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finances_control/feat/home/route/home_path.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _HomeTransactionsTab(
            onProfileRequested: () => setState(() => _selectedIndex = 2),
          ),
          BlocProvider<EbooksViewModel>(
            create: (_) => getIt<EbooksViewModel>()..load(),
            child: const EbooksPage(),
          ),
          BlocProvider<ProfileViewModel>(
            create: (_) => getIt<ProfileViewModel>(),
            child: const ProfilePage(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() => _selectedIndex = value);
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
      ),
    );
  }
}

class _HomeTransactionsTab extends StatefulWidget {
  final VoidCallback onProfileRequested;

  const _HomeTransactionsTab({required this.onProfileRequested});

  @override
  State<_HomeTransactionsTab> createState() => _HomeTransactionsTabState();
}

class _HomeTransactionsTabState extends State<_HomeTransactionsTab> {
  late final DateTime _baseMonth;
  late final PageController _pageController;

  static const int _initialPage = 100;

  int _currentPage = _initialPage;

  @override
  void initState() {
    super.initState();

    _baseMonth = DateTime.now();
    _pageController = PageController(initialPage: _initialPage);

    context.read<HomeViewModel>().load(_baseMonth.year, _baseMonth.month);
  }

  bool _isFutureMonth(DateTime date) {
    final now = DateTime.now();
    return date.year > now.year ||
        (date.year == now.year && date.month > now.month);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final shouldReload = await Navigator.of(context).pushNamed(
            HomePath.transaction.path,
            arguments: _currentMonthDate(),
          );

          if (shouldReload == true && context.mounted) {
            context.read<HomeViewModel>().reload();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });

          final diff = index - _initialPage;
          final date = DateTime(_baseMonth.year, _baseMonth.month + diff);

          if (_isFutureMonth(date)) {
            _pageController.animateToPage(
              index - 1,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
            return;
          }

          context.read<HomeViewModel>().load(date.year, date.month);
        },
        itemBuilder: (context, index) {
          return HomeContent(onProfileTap: widget.onProfileRequested);
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: const BannerAdWidget(),
      ),
    );
  }

  DateTime _currentMonthDate() {
    final diff = _currentPage - _initialPage;

    final monthDate = DateTime(_baseMonth.year, _baseMonth.month + diff);
    final now = DateTime.now();

    final isCurrentMonth =
        monthDate.year == now.year && monthDate.month == now.month;

    if (isCurrentMonth) return now;

    return DateTime(monthDate.year, monthDate.month, 5);
  }
}

class HomeContent extends StatelessWidget {
  final VoidCallback onProfileTap;

  const HomeContent({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeViewModel>().reload();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            HomeHeader(
              onSettingsTap: onProfileTap,
              onTransactionsTap: () => _onTransactionsTap(context),
            ),
            HomeBody(),
          ],
        ),
      ),
    );
  }

  Future<void> _onTransactionsTap(BuildContext context) async {
    final shouldReload = await Navigator.of(
      context,
    ).pushNamed(HomePath.transactions.path);

    if (shouldReload == true && context.mounted) {
      context.read<HomeViewModel>().reload();
    }
  }
}
