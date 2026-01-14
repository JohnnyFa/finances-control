import 'package:finances_control/core/formatters/currency_formatter.dart';
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
              MonthYearSelector(),
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
                  description: state.error ?? 'Error loading data',
                );
              }

              if (state.categories.isEmpty) {
                return const CustomText(description: 'No expenses this month');
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CustomText(
                    description: "📊 Expenses per category",
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
                        amount: formatCurrency(context, e.total),
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

  Container _balance(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Color(0xFF7B3FF6), Color(0xFF4E8CFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 12),
          CustomText(
            description: "SALDO DO MÊS",
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          SizedBox(height: 8),
          CustomText(
            description: "😊 R\$ 0,00",
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D7BFF), Color(0xFF7B3FF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: const [
                      CustomText(
                        description: "📈 Income",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      CustomText(
                        description: "R\$ 0,00",
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9D7BFF), Color(0xFF7B3FF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: const [
                      CustomText(
                        description: "📉 Expenses",
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      CustomText(
                        description: "R\$ 0,00",
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
            child: Center(
              child: const CustomText(
                description: "🎉Economia: + R\$ 0,00",
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
