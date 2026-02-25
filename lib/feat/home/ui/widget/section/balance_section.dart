import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/home/domain/enum_balance_mood.dart';
import 'package:finances_control/feat/home/ui/widget/home_card.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/widget/animated_emoji.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BalanceSection extends StatelessWidget {
  const BalanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final scheme = Theme.of(context).colorScheme;
        final balance = state.monthBalance;
        final goal = state.user.amountToSaveByMonth ?? 0;
        final mood = _resolveMood(
          balance,
          state.user.amountToSaveByMonth ?? 0,
          state.user.salary,
        );

        double percent = goal == 0 ? 0 : balance / goal;

        return HomeCard(
          color: scheme.surface,
          elevation: 2,
          borderRadius: BorderRadius.circular(28),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    context.appStrings.month_balance.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.1,
                      color: scheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const Spacer(),
                  _GrowthBadge(),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedBalanceEmoji(
                    mood: mood,
                    intensity: percent.clamp(-2, 2),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    formatCurrencyFromCents(context, balance),
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              Row(
                children: [
                  _IncomeExpenseCard(
                    title: "📈 ${context.appStrings.income}",
                    value: state.totalIncome,
                    isIncome: true,
                  ),
                  const SizedBox(width: 16),
                  _IncomeExpenseCard(
                    title: "📉 ${context.appStrings.expense}",
                    value: state.totalExpense,
                    isIncome: false,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _BalanceStatusBanner(balance: balance),
            ],
          ),
        );
      },
    );
  }

  BalanceMood _resolveMood(int balance, int goal, int salary) {
    if (balance > goal) return BalanceMood.superHappy;

    if (balance > 0 && balance <= goal) return BalanceMood.happy;

    if (balance == 0) return BalanceMood.neutral;

    if (balance < 0 && balance.abs() <= goal) return BalanceMood.sad;

    if (balance.abs() > goal && balance.abs() <= salary) {
      return BalanceMood.verySad;
    }

    return BalanceMood.melting;
  }
}

class _IncomeExpenseCard extends StatelessWidget {
  final String title;
  final int value;
  final bool isIncome;

  const _IncomeExpenseCard({
    required this.title,
    required this.value,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final accent = isIncome ? scheme.primary : scheme.error;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: scheme.tertiary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: scheme.onTertiary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              formatCurrencyFromCents(context, value),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BalanceStatusBanner extends StatelessWidget {
  final int balance;

  const _BalanceStatusBanner({required this.balance});

  @override
  Widget build(BuildContext context) {
    if (balance == 0) return const SizedBox();

    final scheme = Theme.of(context).colorScheme;
    final isPositive = balance > 0;

    final backgroundColor = isPositive ? scheme.primary : scheme.error;

    final onColor = isPositive ? scheme.onPrimary : scheme.onError;

    final message = isPositive
        ? context.appStrings.saved_this_month(
            formatCurrencyFromCents(context, balance),
          )
        : context.appStrings.spent_more_than_earned;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(isPositive ? "🎉" : "⚠️", style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: onColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GrowthBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (false) ...[
            Text(
              "+25%",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: scheme.primary,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.trending_up, size: 16, color: scheme.primary),
          ],
        ],
      ),
    );
  }
}
