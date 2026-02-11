import 'package:finances_control/core/extensions/context_theme_extensions.dart';
import 'package:finances_control/feat/onboarding/ui/widgets/info_card.dart';
import 'package:flutter/material.dart';

import '../widgets/onboarding_primary_button.dart';

class OnboardingHowItWorksStep extends StatelessWidget {
  final VoidCallback onNext;

  const OnboardingHowItWorksStep({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("📱", style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),

          Text(
            "Como o app funciona?",
            style: context.textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          Text(
            "É simples e sem complicação",
            style: context.textTheme.bodyMedium,
          ),

          const SizedBox(height: 24),

          infoCard(
            icon: "📊",
            title: "Acompanhe seus gastos",
            subtitle: "Veja tudo organizado por mês e categoria",
          ),

          infoCard(
            icon: "🔁",
            title: "Despesas recorrentes",
            subtitle: "Cadastre uma vez, repita todo mês",
          ),

          infoCard(
            icon: "🎯",
            title: "Saiba onde vai seu dinheiro",
            subtitle: "Gráficos simples mostram seus padrões",
          ),

          infoCard(
            icon: "📈",
            title: "Clareza do saldo mensal",
            subtitle: "Acompanhe quanto sobra todo mês",
          ),

          const SizedBox(height: 32),

          OnboardingPrimaryButton(label: 'Continuar', onPressed: onNext),
        ],
      ),
    );
  }
}
