import 'package:finances_control/components/default_header.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/budget_control/domain/budget.dart';
import 'package:finances_control/feat/budget_control/vm/budget_state.dart';
import 'package:finances_control/feat/budget_control/vm/budget_viewmodel.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    context.read<BudgetViewModel>().load(now.month, now.year);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBudgetDialog(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Novo Limite',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<BudgetViewModel, BudgetState>(
        builder: (context, state) {
          if (state is BudgetLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BudgetError) {
            return Center(child: Text(state.message));
          }

          if (state is! BudgetLoaded) {
            return const SizedBox();
          }

          final budgets = state.budgets;

          return Column(
            children: [
              DefaultHeader(
                title: 'Controle de gastos',
                subtitle: 'Defina limites para suas categorias',
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  children: [
                    _SummaryCard(
                      totalLimit: state.totalLimit,
                      totalSpent: state.totalSpent,
                      percentage: state.totalPercentage,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text('📊', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 12),
                        Text(
                          'Limites por Categoria',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...budgets.map(
                      (budget) => _BudgetCard(
                        budget: budget,
                        onTap: () => _showBudgetDialog(context, budget: budget),
                        onDelete: () =>
                            context.read<BudgetViewModel>().deleteBudget(
                              budget.category.name,
                              state.month,
                              state.year,
                            ),
                      ),
                    ),
                    if (budgets.isEmpty) const _EmptyState(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showBudgetDialog(BuildContext context, {Budget? budget}) {
    final state = context.read<BudgetViewModel>().state;
    if (state is! BudgetLoaded) return;

    final expenseCategories = Category.values.where((c) => c.isExpense).toList();
    Category selectedCategory = budget?.category ?? expenseCategories.first;

    final controller = TextEditingController(
      text: budget != null ? (budget.limitCents / 100).toStringAsFixed(2) : '',
    );

    final isEditing = budget != null;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Editar Limite' : 'Novo Limite'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!isEditing)
              DropdownButtonFormField<Category>(
                value: selectedCategory,
                items: expenseCategories
                    .map((c) => DropdownMenuItem(
                          value: c,
                          child: Text(c.label(context.appStrings)),
                        ))
                    .toList(),
                onChanged: (v) => selectedCategory = v!,
                decoration: const InputDecoration(labelText: 'Categoria'),
              )
            else
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  selectedCategory.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(selectedCategory.label(context.appStrings)),
                subtitle: const Text('Categoria'),
              ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Limite (R\$)',
                hintText: '0,00',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final limit =
                  ((double.tryParse(controller.text.replaceAll(',', '.')) ??
                              0) *
                          100)
                      .toInt();
              if (limit > 0) {
                this.context.read<BudgetViewModel>().addBudget(
                  selectedCategory.name,
                  state.month,
                  state.year,
                  limit,
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int totalLimit;
  final int totalSpent;
  final double percentage;

  const _SummaryCard({
    required this.totalLimit,
    required this.totalSpent,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isOverBudget = totalSpent > totalLimit;
    final remaining = totalLimit - totalSpent;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isOverBudget
              ? [const Color(0xFFFEE2E2), const Color(0xFFFECACA)]
              : [const Color(0xFFDCFCE7), const Color(0xFFBBF7D0)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isOverBudget
              ? const Color(0xFFEF4444).withValues(alpha: 0.3)
              : const Color(0xFF4CAF50).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isOverBudget ? '⚠️' : '✅',
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: 12),
              Text(
                isOverBudget ? 'Limite Excedido' : 'Dentro do Limite',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gasto Total',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isOverBudget
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: (percentage / 100).clamp(0, 1),
                  minHeight: 12,
                  backgroundColor: Colors.white.withValues(alpha: 0.5),
                  valueColor: AlwaysStoppedAnimation(
                    isOverBudget
                        ? const Color(0xFFEF4444)
                        : const Color(0xFF4CAF50),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AmountDetail(
                label: 'Gasto',
                amount: totalSpent,
                color: const Color(0xFFEF4444),
              ),
              _Divider(),
              _AmountDetail(
                label: 'Limite',
                amount: totalLimit,
                color: scheme.onSurface,
              ),
              _Divider(),
              _AmountDetail(
                label: isOverBudget ? 'Excedido' : 'Restante',
                amount: remaining.abs(),
                color: isOverBudget
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF4CAF50),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountDetail extends StatelessWidget {
  final String label;
  final int amount;
  final Color color;

  const _AmountDetail({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          formatCurrencyFromCents(context, amount),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final Budget budget;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budget,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final categoryColor = budget.category.color;
    final isOverBudget = budget.isOverBudget;

    return Dismissible(
      key: Key(budget.category.name),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: scheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isOverBudget
                  ? const Color(0xFFEF4444).withValues(alpha: 0.3)
                  : scheme.outlineVariant.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        budget.category.emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          budget.category.label(context.appStrings),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${formatCurrencyFromCents(context, budget.spentCents)} de ${formatCurrencyFromCents(context, budget.limitCents)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: scheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isOverBudget
                          ? const Color(0xFFEF4444).withValues(alpha: 0.12)
                          : categoryColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${budget.percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isOverBudget
                            ? const Color(0xFFEF4444)
                            : categoryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: (budget.percentage / 100).clamp(0, 1),
                  minHeight: 8,
                  backgroundColor: scheme.outlineVariant.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation(
                    isOverBudget ? const Color(0xFFEF4444) : categoryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Text('📉', style: TextStyle(fontSize: 48)),
            SizedBox(height: 16),
            Text(
              'Nenhum limite definido',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
