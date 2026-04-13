import 'package:finances_control/core/route/base/feature_navigation.dart';
import 'package:finances_control/feat/ebooks/route/ebooks_path.dart';
import 'package:finances_control/widget/main_tabs_page.dart';
import 'package:flutter/material.dart';

class EbooksNavigation extends FeatureNavigation {
  @override
  Map<String, WidgetBuilder> get routes => {
    EbooksPath.ebooks.path: (_) => const MainTabsPage(initialIndex: 1),
  };
}
