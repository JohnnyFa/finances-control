import 'package:finances_control/core/analytics/analytics_service.dart';
import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/ebooks/ui/components/ebooks_body.dart';
import 'package:finances_control/feat/ebooks/ui/components/ebooks_header.dart';
import 'package:finances_control/widget/main_bottom_nav.dart';
import 'package:flutter/material.dart';

class EbooksPage extends StatefulWidget {
  const EbooksPage({super.key});

  @override
  State<EbooksPage> createState() => _EbooksPageState();
}

class _EbooksPageState extends State<EbooksPage> {
  @override
  void initState() {
    super.initState();
    getIt<AnalyticsService>()
      ..trackBookListView()
      ..trackClickBooksTab();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          EbooksHeader(),
          Expanded(child: EbooksBody()),
        ],
      ),
      bottomNavigationBar: const MainBottomNav(currentIndex: 1),
    );

  }
}
