import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/route/base/feature_navigation.dart';
import 'package:finances_control/feat/open_finance/route/open_finance_path.dart';
import 'package:finances_control/feat/open_finance/ui/open_finance_page.dart';
import 'package:finances_control/feat/open_finance/vm/open_finance_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenFinanceNavigation extends FeatureNavigation {
  @override
  Map<String, WidgetBuilder> get routes => {
    OpenFinancePath.home.path: (_) => BlocProvider(
      create: (_) => getIt<OpenFinanceViewModel>(),
      child: const OpenFinancePage(),
    ),
  };
}
