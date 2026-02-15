import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/home/ui/widget/home_card.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:finances_control/widget/custom_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpensesSection extends StatelessWidget {
  const ExpensesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return HomeCard(
      color: scheme.surface,
      borderRadius: BorderRadius.circular(28),
      child: BlocBuilder<HomeViewModel, HomeState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.categories != current.categories,
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.status == HomeStatus.error) {
            return Text(
              state.error ?? context.appStrings.unexpected_error,
              style: TextStyle(color: scheme.error),
            );
          }

          if (state.categories.isEmpty) {
            return const _NoExpensesContent();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "📊 ${context.appStrings.expenses_per_category}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 280,
                child: expensesPieChart(context, state.categories),
              ),

              const SizedBox(height: 16),

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
}

Widget expenseCategoryTile(
  BuildContext context, {
  required Category category,
  required int percent,
  required String amount,
}) {
  final theme = Theme.of(context);

  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      color: theme.colorScheme.surface,
      boxShadow: const [
        BoxShadow(blurRadius: 6, offset: Offset(0, 2), color: Colors.black12),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: category.color,
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomText(
                    description: category.label,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              CustomText(
                description: amount,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),

        CustomText(
          description: '$percent%',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: category.color,
        ),
      ],
    ),
  );
}

class _NoExpensesContent extends StatelessWidget {
  const _NoExpensesContent();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Text("😊", style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          Text(
            context.appStrings.empty_expenses,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.appStrings.financial_control,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: scheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

Widget expensesPieChart(
    BuildContext context,
    List<ExpenseCategorySummary> data,
    ) {
  return PieChart(
    PieChartData(
      sectionsSpace: 3,
      centerSpaceRadius: 50,
      sections: data.map((e) {
        return PieChartSectionData(
          value: e.percentage,
          color: e.category.color,
          showTitle: true,
          title: '${e.category.emoji}\n${e.percentage.toStringAsFixed(0)}%',
          radius: 45,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        );
      }).toList(),
    ),
  );
}
