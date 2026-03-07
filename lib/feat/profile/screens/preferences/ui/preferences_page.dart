import 'package:finances_control/feat/profile/screens/preferences/ui/preferences_header.dart';
import 'package:flutter/material.dart';

import 'preferences_body.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: scheme.primary,
      body: Column(
        children: [

          /// HEADER
          PreferencesHeader(),

          /// BODY
          const Expanded(
            child: PreferencesBody(),
          ),
        ],
      ),
    );
  }
}