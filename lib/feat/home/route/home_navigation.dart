import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/route/base/feature_navigation.dart';
import 'package:finances_control/feat/home/route/home_path.dart';
import 'package:finances_control/feat/transaction/ui/transaction_page.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNavigation extends FeatureNavigation {
  @override
  Map<String, WidgetBuilder> get routes => {
    HomePath.transaction.path: (context) => BlocProvider<TransactionViewModel>(
      create: (_) => getIt<TransactionViewModel>(),
      child: const TransactionPage(),
    ),
  };
}
