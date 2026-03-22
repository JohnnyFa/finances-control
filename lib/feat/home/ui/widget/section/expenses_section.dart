import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/home/domain/expense_category_summary.dart';
import 'package:finances_control/feat/home/route/home_path.dart';
import 'package:finances_control/feat/home/ui/widget/home_card.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:finances_control/feat/transaction/ui/transaction_label_resolver.dart';
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
        builder: (context, state) {
          if (state is HomeLoading) {
            return const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is HomeError) {
            return Text(state.message, style: TextStyle(color: scheme.error));
          }

          if (state is! HomeLoaded) {
            return const SizedBox();
          }

          if (state.categories.isEmpty) {
            return const _NoExpensesContent();
          }

          return GestureDetector(
            onTap: () async {
              final shouldReload = await Navigator.of(context).pushNamed(
                HomePath.budget.path,
                arguments: DateTime(state.year, state.month),
              );
              if (shouldReload == true && context.mounted) {
                context.read<HomeViewModel>().reload();
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "📊 ${context.appStrings.expenses_per_category}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: scheme.onSurface,
                      ),
                    ),
                    Icon(Icons.arrow_forward, color: scheme.secondary),
                  ],
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
                      spentCents: e.total,
                      limitCents: e.limitCents,
                      month: state.month,
                      year: state.year,
                    );
                  }).toList(),
                ),
              ],
            ),
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
  required int spentCents,
  required int? limitCents,
  required int month,
  required int year,
}) {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;

  final hasLimit = limitCents != null && limitCents > 0;
  final progress = hasLimit ? (spentCents / limitCents).clamp(0, 1) : 0.0;

  return GestureDetector(
    onTap: () async {
      final shouldReload = await Navigator.of(
        context,
      ).pushNamed(
        HomePath.budget.path,
        arguments: DateTime(year, month),
      );

      if (shouldReload == true && context.mounted) {
        context.read<HomeViewModel>().reload();
      }
    },
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 TOP ROW (category + arrow + %)
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: category.color,
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  categoryLabel(context, category),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Text(
                '$percent%',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: category.color,
                ),
              ),

              const SizedBox(width: 8),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: scheme.onSurface.withValues(alpha: 0.4),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔹 SPENT
          Text(
            formatCurrencyFromCents(context, spentCents),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withValues(alpha: 0.75),
            ),
          ),

          const SizedBox(height: 10),

          /// 🔥 LIMIT SECTION
          if (hasLimit) ...[
            Builder(
              builder: (_) {
                final isOver = spentCents > limitCents;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// LIMIT + %
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Limite: ${formatCurrencyFromCents(
                              context, limitCents)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: scheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          '${((spentCents / limitCents) * 100).toStringAsFixed(
                              0)}%',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isOver ? scheme.error : category.color,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    /// PROGRESS
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress.toDouble(),
                        minHeight: 6,
                        backgroundColor:
                        scheme.outlineVariant.withValues(alpha: 0.2),
                        valueColor: AlwaysStoppedAnimation(
                          isOver ? scheme.error : category.color,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// ⚠️ WARNING
                    if (isOver)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning_rounded,
                            size: 16,
                            color: scheme.error,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Limite atingido',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: scheme.error,
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
            ),
          ] else
            ...[
              Text(
                'Adicione um limite a essa categoria',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: scheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
        ],
      ),
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
