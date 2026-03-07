import 'package:finances_control/feat/home/ui/widget/loader/home_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../viewmodel/home_state.dart';
import '../viewmodel/home_viewmodel.dart';
import 'widget/section/balance_section.dart';
import 'widget/section/expenses_section.dart';
import 'widget/section/recurring_section.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {

        /// loading skeleton
        if (state is HomeLoading || state is HomeInitial) {
          return const HomeSkeleton();
        }

        /// error
        if (state is HomeError) {
          return Center(child: Text(state.message));
        }

        /// loaded
        if (state is HomeLoaded) {
          return Column(
            children: [
              Transform.translate(
                offset: const Offset(0, -30),
                child: const BalanceSection(),
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: const ExpensesSection(),
              ),
              const RecurringSection(),
              const SizedBox(height: 100),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
