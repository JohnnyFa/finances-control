
import 'package:finances_control/feat/profile/ui/widget/logout_button.dart';
import 'package:finances_control/feat/profile/ui/widget/profile_section_card.dart';
import 'package:finances_control/feat/profile/ui/widget/profile_tile.dart';
import 'package:flutter/material.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: scheme.background,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(40),
        ),
      ),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: const [
          ProfileSectionCard(
            title: "DADOS FINANCEIROS",
            children: [
              ProfileTile(
                icon: "💰",
                title: "Renda Mensal",
                subtitle: "R\$ 5.000,00",
              ),
              ProfileTile(
                icon: "🏦",
                title: "Meta de Economia",
                subtitle: "R\$ 500,00 / mês",
              ),
            ],
          ),

          SizedBox(height: 24),

          ProfileSectionCard(
            title: "CONTA",
            children: [
              ProfileTile(
                icon: "👤",
                title: "Nome",
                subtitle: "João Silva",
              ),
              ProfileTile(
                icon: "📧",
                title: "E-mail",
                subtitle: "joao@email.com",
              ),
              ProfileTile(
                icon: "🔒",
                title: "Senha",
                subtitle: "••••••••",
              ),
            ],
          ),

          SizedBox(height: 24),

          LogoutButton(),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
