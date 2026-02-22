import 'dart:io';

import 'package:finances_control/feat/home/route/home_navigation.dart';
import 'package:finances_control/feat/open_finance/route/open_finance_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../main.dart';
import '../route/app_navigation.dart';

extension AppExtension on MyApp {
  Map<String, WidgetBuilder> get appRoutes => AppNavigation().routes
    ..addAll(HomeNavigation().routes)
    ..addAll(OpenFinanceNavigation().routes);
}

void runCatching(Function exec, {Function? onError}) {
  try {
    exec();
  } catch (e) {
    onError?.call(e);
  }
}

void closeApp() {
  if (Platform.isIOS) {
    exit(0);
  } else {
    SystemNavigator.pop();
  }
}
