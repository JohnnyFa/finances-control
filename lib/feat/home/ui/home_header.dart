import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/date_formatter.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onSettingsTap;
  final VoidCallback onTransactionsTap;

  const HomeHeader({
    super.key,
    required this.onSettingsTap,
    required this.onTransactionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5CCB7A), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderTopRow(
              onSettingsTap: onSettingsTap,
              onTransactionsTap: onTransactionsTap,
            ),
            const SizedBox(height: 4),
            Text(
              context.appStrings.see_finances,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            const _HeaderMonthSelector(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _HeaderMonthSelector extends StatelessWidget {
  const _HeaderMonthSelector();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final date = DateTime(state.year, state.month);

        return Row(
          children: [
            _MonthArrow(
              icon: Icons.chevron_left,
              onTap: () {
                final newDate = DateTime(date.year, date.month - 1);
                context.read<HomeViewModel>().load(newDate.year, newDate.month);
              },
            ),
            const SizedBox(width: 16),
            Text(
              DateFormatter.monthYear(context, date),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            _MonthArrow(
              icon: Icons.chevron_right,
              onTap: () {
                final newDate = DateTime(date.year, date.month + 1);
                context.read<HomeViewModel>().load(newDate.year, newDate.month);
              },
            ),
          ],
        );
      },
    );
  }
}

class _MonthArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MonthArrow({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}

class _HeaderTopRow extends StatelessWidget {
  final VoidCallback? onSettingsTap;
  final VoidCallback? onTransactionsTap;

  const _HeaderTopRow({
    this.onSettingsTap,
    this.onTransactionsTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: Text(
                "${context.appStrings.hello}, ${state.user.name}! 👋",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Row(
              children: [
                _ActionIconButton(
                  icon: Icons.receipt_long,
                  onTap: onTransactionsTap,
                ),
                const SizedBox(width: 8),
                _ActionIconButton(icon: Icons.settings, onTap: onSettingsTap),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _ActionIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
