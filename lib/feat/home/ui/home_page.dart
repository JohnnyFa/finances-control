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

  @override
  void initState() {
    super.initState();

    _baseMonth = DateTime.now();

    _pageController = PageController(initialPage: _initialPage);

    context.read<HomeViewModel>().load(_baseMonth.year, _baseMonth.month);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final shouldReload = await Navigator.of(
              context,
            ).pushNamed(HomePath.transaction.path);

            if (shouldReload == true && context.mounted) {
              context.read<HomeViewModel>().reload();
            }
          },
          child: const Icon(Icons.add),
        ),
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            final diff = index - _initialPage;

            final date = DateTime(_baseMonth.year, _baseMonth.month + diff);

            context.read<HomeViewModel>().load(date.year, date.month);
          },
          itemBuilder: (context, index) {
            return HomeContent();
          },
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [const HomeHeader(), HomeBody()]),
    );
  }
}
