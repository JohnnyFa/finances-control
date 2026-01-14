import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/home/ui/home_page.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'base/feature_navigation.dart';
import 'path/app_route_path.dart';

class AppNavigation extends FeatureNavigation {
  @override
  Map<String, WidgetBuilder> get routes => {
    AppRoutePath.homePage.path: (context) => BlocProvider<HomeViewModel>(
      create: (_) => getIt<HomeViewModel>(),
      child: const HomePage(),
    ),
  };
}
