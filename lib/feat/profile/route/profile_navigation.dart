import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/route/base/feature_navigation.dart';
import 'package:finances_control/feat/profile/route/profile_path.dart';
import 'package:finances_control/feat/profile/screens/about/ui/about_page.dart';
import 'package:finances_control/feat/profile/screens/about/vm/about_vm.dart';
import 'package:finances_control/feat/profile/screens/account_settings/ui/account_settings_page.dart';
import 'package:finances_control/feat/profile/screens/account_settings/vm/account_settings_vm.dart';
import 'package:finances_control/feat/profile/screens/financial_settings/ui/financial_settings_page.dart';
import 'package:finances_control/feat/profile/screens/financial_settings/vm/financial_settings_vm.dart';
import 'package:finances_control/feat/profile/screens/preferences/ui/preferences_page.dart';
import 'package:finances_control/feat/profile/screens/preferences/vm/preferences_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileNavigation extends FeatureNavigation {
  @override
  Map<String, WidgetBuilder> get routes => {
    ProfilePath.about.path: (context) => BlocProvider<AboutViewModel>(
      create: (_) => getIt<AboutViewModel>(),
      child: const AboutPage(),
    ),
    ProfilePath.accountSettings.path: (context) =>
        BlocProvider<AccountSettingsViewModel>(
          create: (_) => getIt<AccountSettingsViewModel>(),
          child: const AccountSettingsPage(),
        ),
    ProfilePath.financialSettings.path: (context) =>
        BlocProvider<FinancialSettingsViewModel>(
          create: (_) => getIt<FinancialSettingsViewModel>(),
          child: const FinancialSettingsPage(),
        ),
    ProfilePath.preferences.path: (context) =>
        BlocProvider<PreferencesViewModel>(
          create: (_) => getIt<PreferencesViewModel>(),
          child: const PreferencesPage(),
        ),
  };
}
