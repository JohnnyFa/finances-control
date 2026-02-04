import 'package:finances_control/core/route/path/app_route_path.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_state.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingFinishStep extends StatelessWidget {
  const OnboardingFinishStep({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingViewModel, OnboardingState>(
      listener: (context, state) {
        if (state.status == OnboardingStatus.success) {
          Navigator.of(context).pushReplacementNamed(
            AppRoutePath.homePage.path,
          );
        }
      },
      builder: (context, state) {
        return Center(
          child: ElevatedButton(
            onPressed: state.status == OnboardingStatus.loading
                ? null
                : () {
              context.read<OnboardingViewModel>().saveUser();
            },
            child: const Text("Começar"),
          ),
        );
      },
    );
  }
}
