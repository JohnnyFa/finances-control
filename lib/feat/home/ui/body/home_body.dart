import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/home/ui/widget/expense_category.dart';
import 'package:finances_control/feat/home/ui/widget/expenses_pie_chart.dart';
import 'package:finances_control/feat/home/ui/widget/home_card.dart';
import 'package:finances_control/feat/home/ui/widget/income_expense_card.dart';
import 'package:finances_control/feat/home/ui/widget/recurring_tile.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Transform.translate(
            offset: const Offset(0, -40),
            child: _balanceCard(context),
          ),
          _expensesPerCategoryCard(context),
          _recurringCard(context),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

Widget _balanceCard(BuildContext context) {
  return BlocBuilder<HomeViewModel, HomeState>(
    builder: (context, state) {
      final scheme = Theme.of(context).colorScheme;
      final balance = state.monthBalance;
      final emoji = balance >= 0 ? "😊" : "😬";

      return HomeCard(
        color: scheme.surface,
        elevation: 2,
        borderRadius: BorderRadius.circular(28),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header Row (Title + Badge)
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

            // ─── Balance Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 42)),
                const SizedBox(width: 12),
                Text(
                  formatCurrencyFromCents(context, balance),
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // ─── Income / Expense
            Row(
              children: [
                incomeExpenseCard(
                  context,
                  "📈 ${context.appStrings.income}",
                  state.totalIncome,
                  isIncome: true,
                ),
                const SizedBox(width: 16),
                incomeExpenseCard(
                  context,
                  "📉 ${context.appStrings.expense}",
                  state.totalExpense,
                  isIncome: false,
                ),
              ],
            ),
            const SizedBox(height: 12),
            _BalanceStatusBanner(balance: balance),
          ],
        ),
      );
    },
  );
}

Widget _expensesPerCategoryCard(BuildContext context) {
  return HomeCard(
    child: BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == HomeStatus.error) {
          return CustomText(
            description: state.error ?? context.appStrings.unexpected_error,
          );
        }

        if (state.categories.isEmpty) {
          return _noExpensesContent(context);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              description: "📊 ${context.appStrings.expenses_per_category}",
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: expensesPieChart(context, state.categories),
            ),
            const SizedBox(height: 12),
            Column(
              children: state.categories.map((e) {
                return expenseCategoryTile(
                  context,
                  category: e.category,
                  percent: e.percentage.round(),
                  amount: formatCurrencyFromCents(context, e.total),
                );
              }).toList(),
            ),
          ],
        );
      },
    ),
  );
}

Widget _noExpensesContent(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      children: [
        const SizedBox(height: 12),
        const CustomText(description: "😊", fontSize: 40),
        const SizedBox(height: 12),
        CustomText(
          description: context.appStrings.empty_expenses,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          align: TextAlign.center,
        ),
        const SizedBox(height: 8),
        CustomText(
          description: context.appStrings.financial_control,
          fontSize: 14,
          align: TextAlign.center,
        ),
        const SizedBox(height: 12),
      ],
    ),
  );
}

Widget _recurringCard(BuildContext context) {
  final theme = Theme.of(context);

  return BlocBuilder<HomeViewModel, HomeState>(
    buildWhen: (prev, curr) => prev.recurring != curr.recurring,
    builder: (context, state) {
      if (state.recurring.isEmpty) {
        return const SizedBox();
      }

      final items = state.recurring;

      return HomeCard(
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomText(
                  description:
                      '🔁 ${context.appStrings.recurring_transactions}',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
                const Spacer(),
                CustomText(
                  description: '${items.length}',
                  fontSize: 14,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...items
                .expand(
                  (r) => [
                    recurringTile(context, r),
                    const SizedBox(height: 8),
                    Divider(
                      height: 1,
                      color: theme.dividerColor.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 8),
                  ],
                )
                .toList()
              ..removeLast(),
          ],
        ),
      );
    },
  );
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
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            isPositive ? "🎉" : "⚠️",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.white,
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
