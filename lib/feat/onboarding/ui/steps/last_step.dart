import 'package:finances_control/core/extensions/context_color_extension.dart';
import 'package:finances_control/core/extensions/context_theme_extensions.dart';
import 'package:finances_control/core/route/path/app_route_path.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/onboarding_primary_button.dart';
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
          Navigator.of(
            context,
          ).pushReplacementNamed(AppRoutePath.homePage.path);
        }
      },
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),

                const Text("🚀", style: TextStyle(fontSize: 72)),

                const SizedBox(height: 24),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: context.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    children: [
                      const TextSpan(text: "Tudo pronto,\n"),
                      TextSpan(
                        text: "${state.name}!",
                        style: TextStyle(color: context.primary),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  "Vamos organizar sua\nvida financeira juntos?",
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleMedium,
                ),

                const SizedBox(height: 32),

                Text("✨ 💰 📊", style: context.textTheme.headlineSmall),

                const Spacer(),

                OnboardingPrimaryButton(
                  label: "Começar",
                  isLoading: state.status == OnboardingStatus.loading,
                  onPressed: () {
                    context.read<OnboardingViewModel>().saveUser();
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}
