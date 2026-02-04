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

  static const int totalSteps = 5;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next(BuildContext context) {
    context.read<OnboardingViewModel>().nextStep();
  }

  void _previous(BuildContext context) {
    context.read<OnboardingViewModel>().previousStep();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<OnboardingViewModel, OnboardingState>(
          listenWhen: (prev, curr) => prev.step != curr.step,
          listener: (context, state) {
            _controller.animateToPage(
              state.step,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
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
                        OnboardingNameStep(
                          onNext: () => _next(context),
                        ),
                        OnboardingSalaryStep(
                          onNext: () => _next(context),
                          onPrevious: () => _previous(context),
                        ),
                        OnboardingGoalStep(
                          onNext: () => _next(context),
                          onPrevious: () => _previous(context),
                        ),
                        OnboardingHowItWorksStep(
                          onNext: () => _next(context),
                        ),
                        const OnboardingFinishStep(),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
