import 'package:finances_control/feat/ebooks/ui/components/ebooks_body.dart';
import 'package:finances_control/feat/ebooks/ui/components/ebooks_header.dart';
import 'package:finances_control/widget/main_bottom_nav.dart';
import 'package:flutter/material.dart';

class EbooksPage extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTabSelected;

  const EbooksPage({
    super.key,
    this.currentIndex = 1,
    this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          EbooksHeader(),
          Expanded(child: EbooksBody()),
        ],
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: currentIndex,
        onDestinationSelected: onTabSelected,
      ),
    );
  }
}
