import 'package:finances_control/core/formatters/date_formatter.dart';
import 'package:finances_control/feat/home/ui/body/home_body.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMonthContent extends StatelessWidget {
  const HomeMonthContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [const _HomeHeader(), HomeBody()]),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

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
            _HeaderTopRow(),
            const SizedBox(height: 4),
            const Text(
              "Vamos ver suas finanças",
              style: TextStyle(fontSize: 16, color: Colors.white70),
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        return Row(
          children: [
            Text(
              "Olá, ${state.user.name}! 👋",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
