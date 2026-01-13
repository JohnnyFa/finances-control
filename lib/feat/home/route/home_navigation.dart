import 'package:finances_control/core/route/base/feature_navigation.dart';
import 'package:finances_control/feat/home/route/home_path.dart';
import 'package:finances_control/feat/transaction/ui/transaction_page.dart';
import 'package:flutter/material.dart';

class HomeNavigation extends FeatureNavigation {
  @override
  Map<String, WidgetBuilder> get routes => {
    HomePath.transaction.path: (context) => const TransactionPage(),
  };
}
