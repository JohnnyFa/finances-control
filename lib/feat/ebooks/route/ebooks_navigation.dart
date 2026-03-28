import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/route/base/feature_navigation.dart';
import 'package:finances_control/feat/ebooks/route/ebooks_path.dart';
import 'package:finances_control/feat/ebooks/ui/ebooks_page.dart';
import 'package:finances_control/feat/ebooks/vm/ebooks_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EbooksNavigation extends FeatureNavigation {
  @override
  Map<String, WidgetBuilder> get routes => {
    EbooksPath.ebooks.path: (_) => BlocProvider<EbooksViewModel>(
      create: (_) => getIt<EbooksViewModel>()..load(),
      child: const EbooksPage(),
    ),
  };
}
