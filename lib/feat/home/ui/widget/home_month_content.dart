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
import 'package:finances_control/widget/month_year_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeMonthContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MonthYearSelector(
            onChanged: (date) {
              context.read<HomeViewModel>().load(date.year, date.month);
            },
          ),
          _balanceCard(context),
          _expensesPerCategoryCard(context),
          _recurringCard(context),
          const SizedBox(height: 60),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: CustomText(
              description: "© 2026 Fagundes. All rights reserved.",
              fontSize: 12,
              fontWeight: FontWeight.w200,
              align: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _balanceCard(BuildContext context) {
  return BlocBuilder<HomeViewModel, HomeState>(
    builder: (context, state) {
      final balance = state.monthBalance;
      final emoji = balance >= 0 ? "😊" : "😬";

      return HomeCard(
        gradient: const LinearGradient(
          colors: [Color(0xFF7B3FF6), Color(0xFF4E8CFF)],
        ),
        child: Column(
          children: [
            CustomText(
              description: context.appStrings.month_balance,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            CustomText(
              description:
                  "$emoji ${formatCurrencyFromCents(context, balance)}",
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                incomeExpenseCard(
                  context,
                  "📈 ${context.appStrings.income}",
                  state.totalIncome,
                ),
                incomeExpenseCard(
                  context,
                  "📉 ${context.appStrings.expense}",
                  state.totalExpense,
                ),
              ],
            ),
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

// ───────────────────── RECURRING ─────────────────────

Widget _recurringCard(BuildContext context) {
  final theme = Theme.of(context);

  return BlocBuilder<HomeViewModel, HomeState>(
    buildWhen: (prev, curr) => prev.recurring != curr.recurring,
    builder: (context, state) {
      if (state.recurring?.isEmpty ?? true) {
        return const SizedBox();
      }

      final items = state.recurring!;

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
