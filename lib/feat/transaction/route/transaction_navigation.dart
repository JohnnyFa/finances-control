import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/route/base/feature_navigation.dart';
import 'package:finances_control/feat/home/route/home_path.dart';
import 'package:finances_control/feat/profile/ui/profile_page.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/route/transaction_path.dart';
import 'package:finances_control/feat/transaction/ui/detail_transaction/detail_transaction_page.dart';
import 'package:finances_control/feat/transaction/ui/list_transaction/transaction_list_page.dart';
import 'package:finances_control/feat/profile/vm/profile_viewmodel.dart';
import 'package:finances_control/feat/transaction/ui/new_transaction/transaction_page.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionNavigation extends FeatureNavigation {
  @override
  Map<String, WidgetBuilder> get routes => {
    TransactionPath.transaction.path: (context) =>
        BlocProvider<TransactionViewModel>(
          create: (_) => getIt<TransactionViewModel>(),
          child: TransactionPage(
            initialDate: getArguments<DateTime>(context) ?? DateTime.now(),
          ),
        ),
    TransactionPath.transactionDetail.path: (context) =>
        BlocProvider<TransactionViewModel>(
          create: (_) => getIt<TransactionViewModel>(),
          child: DetailTransactionPage(
            transaction: getArguments<Transaction>(context)!,
          ),
        ),
  };
}
