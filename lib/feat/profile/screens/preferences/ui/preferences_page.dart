import 'package:finances_control/feat/profile/screens/preferences/ui/preferences_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../vm/preferences_vm.dart';
import 'preferences_body.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {

  @override
  void initState() {
    super.initState();

    context.read<PreferencesViewModel>().load();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.primary,
      body: Column(
        children: [

          /// HEADER
          const PreferencesHeader(),

          /// BODY
          const Expanded(
            child: PreferencesBody(),
          ),
        ],
      ),
    );
  }
}