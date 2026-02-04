import 'package:finances_control/core/route/path/app_route_path.dart';
import 'package:finances_control/feat/start/vm/app_start_state.dart';
import 'package:finances_control/feat/start/vm/app_start_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStartPage extends StatefulWidget {
  const AppStartPage({super.key});

  @override
  State<AppStartPage> createState() => _AppStartPageState();
}

class _AppStartPageState extends State<AppStartPage> {
  @override
  void initState() {
    super.initState();
    context.read<AppStartViewModel>().check();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStartViewModel, AppStartState>(
      listener: (context, state) {
        if (state.status == AppStartStatus.onboarding) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutePath.onboarding.path,
          );
        }

        if (state.status == AppStartStatus.home) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutePath.homePage.path,
          );
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
