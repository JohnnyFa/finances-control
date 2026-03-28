import 'package:finances_control/feat/ebooks/ui/components/ebooks_body.dart';
import 'package:finances_control/feat/ebooks/ui/components/ebooks_header.dart';
import 'package:finances_control/widget/main_bottom_nav.dart';
import 'package:flutter/material.dart';

class EbooksPage extends StatelessWidget {
  const EbooksPage({super.key});

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
