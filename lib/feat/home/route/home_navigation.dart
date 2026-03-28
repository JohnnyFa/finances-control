import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/route/base/feature_navigation.dart';
import 'package:finances_control/feat/budget_control/ui/budget_page.dart';
import 'package:finances_control/feat/budget_control/vm/budget_viewmodel.dart';
import 'package:finances_control/feat/home/route/home_path.dart';
import 'package:finances_control/feat/transaction/ui/list_transaction/transaction_list_page.dart';
import 'package:finances_control/feat/transaction/ui/new_transaction/transaction_page.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeNavigation extends FeatureNavigation {
  @override
  Map<String, WidgetBuilder> get routes => {
    HomePath.transactions.path: (context) => BlocProvider<TransactionViewModel>(
      create: (_) => getIt<TransactionViewModel>(),
      child: const TransactionListPage(),
    ),
    HomePath.transaction.path: (context) => BlocProvider<TransactionViewModel>(
      create: (_) => getIt<TransactionViewModel>(),
      child: TransactionPage(
        initialDate: getArguments<DateTime>(context) ?? DateTime.now(),
      ),
    ),
    HomePath.budget.path: (context) {
      final date = getArguments<DateTime>(context) ?? DateTime.now();

      return BlocProvider<BudgetViewModel>(
        create: (_) => getIt<BudgetViewModel>(),
        child: BudgetPage(month: date.month, year: date.year),
      );
    },
  };
}
