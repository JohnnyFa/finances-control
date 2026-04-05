import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/ads/enum/ad_placement.dart';
import 'package:finances_control/feat/ads/ui/banner_add_widget.dart';
import 'package:finances_control/feat/ads/vm/ad_state.dart';
import 'package:finances_control/feat/ads/vm/ad_viewmodel.dart';
import 'package:finances_control/feat/home/ui/widget/loader/home_skeleton.dart';
import 'package:finances_control/feat/premium/presentation/ui/remove_ads_tile.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_state.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../viewmodel/home_state.dart';
import '../viewmodel/home_viewmodel.dart';
import 'widget/section/balance_section.dart';
import 'widget/section/expenses_section.dart';
import 'widget/section/recurring_section.dart';

class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late final AdViewModel _adViewModel;

  @override
  void initState() {
    super.initState();
    _adViewModel = getIt<AdViewModel>(param1: AdPlacement.home)..load();
  }

  @override
  void dispose() {
    _adViewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _adViewModel,
      child: BlocListener<PurchaseViewModel, PurchaseState>(
        listenWhen: (previous, current) =>
            current is PurchaseSuccess || current is PurchaseError,
        listener: (context, _) => _adViewModel.load(),
        child: BlocBuilder<HomeViewModel, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading || state is HomeInitial) {
              return const HomeSkeleton();
            }

            if (state is HomeError) {
              return Center(child: Text(state.message));
            }

            if (state is HomeLoaded) {
              final adState = context.watch<AdViewModel>().state;
              final showHomeBanner =
                  adState is AdLoaded && adState.shouldShow;

              return Column(
                children: [
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: const BalanceSection(),
                  ),

                  if (showHomeBanner) const BannerAdWidget(),
                  const RemoveAdsTile(),

                  const SizedBox(height: 20),

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
        ),
      ),
    );
  }
}
