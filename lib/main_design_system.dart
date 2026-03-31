import 'package:finances_control/core/theme/app_theme.dart';
import 'package:finances_control/design_system/showcase/design_system_showcase_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DesignSystemShowcaseApp());
}

class DesignSystemShowcaseApp extends StatelessWidget {
  const DesignSystemShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: DesignSystemShowcasePage(),
    );
  }
}
