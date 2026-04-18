import 'package:finances_control/feat/home/ui/home_body.dart';
import 'package:finances_control/feat/home/ui/home_header.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_viewmodel.dart';
import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/widget/main_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finances_control/feat/home/route/home_path.dart';

class HomePage extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int>? onTabSelected;

  const HomePage({
    super.key,
    this.currentIndex = 0,
    this.onTabSelected,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => getIt<PurchaseViewModel>()..load(),
        child: const _HomeTransactionsTab(),
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: widget.currentIndex,
        onDestinationSelected: widget.onTabSelected,
      ),
    );
  }
}

class _HomeTransactionsTab extends StatefulWidget {
  const _HomeTransactionsTab();

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
          return HomeContent();
        },
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
  const HomeContent({super.key});

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
            HomeHeader(onTransactionsTap: () => _onTransactionsTap(context)),
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
