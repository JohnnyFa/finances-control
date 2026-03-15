import 'package:finances_control/feat/ads/ui/banner_add_widget.dart';
import 'package:finances_control/feat/home/ui/home_body.dart';
import 'package:finances_control/feat/home/ui/home_header.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finances_control/feat/home/route/home_path.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          return Column(
            children: const [
              Expanded(child: HomeContent()),
              BannerAdWidget(),
            ],
          );
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
    return SingleChildScrollView(
      child: Column(
        children: [
          HomeHeader(
            onSettingsTap: () => _onProfileTap(context),
            onTransactionsTap: () => _onTransactionsTap(context),
          ),
          HomeBody(),
        ],
      ),
    );
  }

  void _onProfileTap(BuildContext context) {
    Navigator.of(context).pushNamed(HomePath.profile.path);
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
