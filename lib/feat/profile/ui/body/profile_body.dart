import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/onboarding/domain/user.dart';
import 'package:finances_control/feat/profile/ui/widget/logout_button.dart';
import 'package:finances_control/feat/profile/ui/widget/profile_section_card.dart';
import 'package:finances_control/feat/profile/ui/widget/profile_tile.dart';
import 'package:flutter/material.dart';

class ProfileBody extends StatelessWidget {
  final User user;
  final bool isLoading;

  const ProfileBody({
    super.key,
    required this.user,
    required this.isLoading,
  });

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
        children: [
          if (isLoading) ...[
            const LinearProgressIndicator(),
            const SizedBox(height: 24),
          ],
          ProfileSectionCard(
            title: 'DADOS FINANCEIROS',
            children: [
              ProfileTile(
                icon: '💰',
                title: 'Renda Mensal',
                subtitle: formatCurrency(context, user.salary),
              ),
              ProfileTile(
                icon: '🏦',
                title: 'Meta de Economia',
                subtitle: formatCurrency(context, user.amountToSaveByMonth ?? 0),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ProfileSectionCard(
            title: 'CONTA',
            children: [
              ProfileTile(
                icon: '👤',
                title: 'Nome',
                subtitle: user.name.trim().isNotEmpty ? user.name : 'Não informado',
              ),
              ProfileTile(
                icon: '📧',
                title: 'E-mail',
                subtitle: (user.email ?? '').trim().isNotEmpty
                    ? user.email!
                    : 'Não informado',
              ),
              const ProfileTile(
                icon: '🔒',
                title: 'Senha',
                subtitle: '••••••••',
              ),
            ],
          ),
          const SizedBox(height: 24),
          const LogoutButton(),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
