import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/home/ui/widget/income_expense_card.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finances_control/feat/home/route/home_path.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:finances_control/widget/month_year_selector.dart';

import '../viewmodel/home_state.dart';
import 'widget/expenses_pie_chart.dart';
import 'widget/expense_category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    context.read<HomeViewModel>().load(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final shouldReload = await Navigator.of(
              context,
            ).pushNamed(HomePath.transaction.path);

            if (shouldReload == true && context.mounted) {
              context.read<HomeViewModel>().reload();
            }
          },
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              MonthYearSelector(
                onChanged: (date) {
                  context.read<HomeViewModel>().load(date.year, date.month);
                },
              ),
              _balance(context),
              _expensesPerCategory(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _expensesPerCategory(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<HomeViewModel, HomeState>(
            builder: (context, state) {
              if (state.status == HomeStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == HomeStatus.error) {
                return CustomText(
                  description:
                      state.error ?? context.appStrings.unexpected_error,
                );
              }

              if (state.categories.isEmpty) {
                return _noExpenses(context);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    description:
                        "📊 ${context.appStrings.expenses_per_category}",
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
        ),
      ),
    );
  }

  Widget _balance(BuildContext context) {
    return BlocBuilder<HomeViewModel, HomeState>(
      builder: (context, state) {
        final balance = state.monthBalance;

        final emoji = balance >= 0 ? "😊" : "😬";

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Color(0xFF7B3FF6), Color(0xFF4E8CFF)],
            ),
          ),
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 12),
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
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.2,
                  ),
                ),
                child: Center(
                  child: CustomText(
                    description: state.globalEconomy >= 0
                        ? "🎉 ${context.appStrings.economy}: ${formatCurrencyFromCents(context, state.globalEconomy)}"
                        : "😬 ${context.appStrings.economy}: ${formatCurrencyFromCents(context, state.globalEconomy)}",
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Column _noExpenses(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
          child: Column(
            children: [
              CustomText(description: "😊", fontSize: 40),
              SizedBox(height: 12),
              CustomText(
                description: context.appStrings.empty_expenses,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 8),
              CustomText(
                description: context.appStrings.financial_control,
                fontSize: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
