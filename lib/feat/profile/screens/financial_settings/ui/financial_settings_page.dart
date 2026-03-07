import 'package:flutter/material.dart';

class FinancialSettingsPage extends StatelessWidget {
  const FinancialSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Financial settings'),
      ),
      body: const Center(
        child: Text('Financial settings page'),
      ),
    );
  }
}
