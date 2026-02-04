
import 'package:finances_control/feat/onboarding/ui/steps/goal_step.dart';
import 'package:finances_control/feat/onboarding/ui/steps/how_it_works_step.dart';
import 'package:finances_control/feat/onboarding/ui/steps/last_step.dart';
import 'package:finances_control/feat/onboarding/ui/steps/name_step.dart';
import 'package:finances_control/feat/onboarding/ui/steps/salary_step.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/on_boarding_progress_bar.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_state.dart';
import 'package:finances_control/feat/onboarding/vm/onboarding_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _controller;

  final int totalSteps = 5;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  void _next(BuildContext context) {
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    context.read<OnboardingViewModel>().nextStep();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<OnboardingViewModel, OnboardingState>(
          builder: (context, state) {
            return Column(
              children: [
                OnboardingProgressBar(
                  step: state.step,
                  total: totalSteps,
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      OnboardingNameStep(onNext: () => _next(context)),
                      OnboardingSalaryStep(onNext: () => _next(context)),
                      OnboardingGoalStep(onNext: () => _next(context)),
                      OnboardingHowItWorksStep(onNext: () => _next(context)),
                      OnboardingFinishStep(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
