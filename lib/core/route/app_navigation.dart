import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/home/ui/home_page.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/onboarding/ui/onboarding_page.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_viewmodel.dart';
import 'package:finances_control/feat/start/ui/app_start_page.dart';
import 'package:finances_control/feat/start/vm/app_start_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base/feature_navigation.dart';
import 'path/app_route_path.dart';

class AppNavigation extends FeatureNavigation {
  @override
  Map<String, WidgetBuilder> get routes => {
    AppRoutePath.appStart.path: (_) => BlocProvider(
      create: (_) => getIt<AppStartViewModel>(),
      child: const AppStartPage(),
    ),

    AppRoutePath.onboarding.path: (_) => BlocProvider(
      create: (_) => getIt<OnboardingViewModel>(),
      child: const OnboardingPage(),
    ),

    AppRoutePath.homePage.path: (_) => BlocProvider(
      create: (_) => getIt<HomeViewModel>(),
      child: const HomePage(),
    ),
  };
}
