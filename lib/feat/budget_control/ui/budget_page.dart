import 'package:finances_control/components/default_header.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/ads/ui/banner_add_widget.dart';
import 'package:finances_control/feat/budget_control/domain/budget.dart';
import 'package:finances_control/feat/budget_control/ui/components/budget_card.dart';
import 'package:finances_control/feat/budget_control/ui/components/budget_summary_card.dart';
import 'package:finances_control/feat/budget_control/vm/budget_state.dart';
import 'package:finances_control/feat/budget_control/vm/budget_viewmodel.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BudgetPage extends StatefulWidget {
  final int month;
  final int year;

  const BudgetPage({super.key, required this.month, required this.year});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  bool _hasChanges = false;
  bool _isCreatingBudget = false;

  @override
  void initState() {
    super.initState();
    context.read<BudgetViewModel>().load(widget.month, widget.year);
    context.read<BudgetViewModel>().interstitialAdService.loadAd();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BudgetViewModel, BudgetState>(
      listener: (context, state) {
        if (state is BudgetLoaded || state is BudgetError) {
          _isCreatingBudget = false;
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _onAddBudgetPressed(context),
          icon: const Icon(Icons.add_rounded),
          label: Text(
            context.appStrings.new_budget_limit,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        bottomNavigationBar: const SafeArea(
          top: false,
          child: SizedBox(
            height: 50,
            child: Align(
              alignment: Alignment.center,
              child: BannerAdWidget(),
            ),
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

            return Column(
              children: [
                DefaultHeader(
                  title: context.appStrings.budget_control,
                  subtitle: context.appStrings.budget_control_subtitle,
                  onBack: () => Navigator.pop(context, _hasChanges),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    children: [
                      BudgetSummaryCard(
                        totalLimit: state.totalLimit,
                        totalSpent: state.totalSpent,
                        percentage: state.totalPercentage,
                        month: widget.month,
                        year: widget.year,
                      ),

                      const SizedBox(height: 28),

                      _SectionHeader(
                        title: context.appStrings.budget_limits_by_category,
                        emoji: '📊',
                      ),

                      const SizedBox(height: 16),

                      ...state.budgets.map(
                        (budget) => BudgetCard(
                          budget: budget,
                          onTap: () => _showBudgetDialog(context, budget: budget),
                          onDelete: () {
                            _hasChanges = true;
                            context.read<BudgetViewModel>().deleteBudget(
                              budget.category.name,
                              state.month,
                              state.year,
                            );
                          },
                        ),
                      ),

                      if (state.budgets.isEmpty) const _EmptyState(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _onAddBudgetPressed(BuildContext context) async {
    final viewModel = context.read<BudgetViewModel>();
    final state = viewModel.state;

    if (state is! BudgetLoaded) return;

    final effectiveBudgetsCount = state.budgets.length + (_isCreatingBudget ? 1 : 0);
    if (!viewModel.needsAdForNextBudget(effectiveBudgetsCount)) {
      _showBudgetDialog(context);
      return;
    }

    final shouldWatchAd = await _showAdUnlockDialog(context, state.budgets.length);
    if (!shouldWatchAd || !context.mounted) return;

    final unlocked = await viewModel.unlockBudgetCreationWithAd();
    if (!context.mounted) return;

    if (unlocked) {
      _showBudgetDialog(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.appStrings.ad_not_available_message)),
    );
  }

  Future<bool> _showAdUnlockDialog(BuildContext context, int existingBudgetsCount) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.all(24),
        title: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Center(child: Text('🎬', style: TextStyle(fontSize: 32))),
            ),
            const SizedBox(height: 16),
            Text(
              context.appStrings.watch_ad_to_add_budget_title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5),
            ),
          ],
        ),
        content: Text(
          context.appStrings.watch_ad_to_add_budget_message(existingBudgetsCount),
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, height: 1.6),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: const Size(0, 48),
                  ),
                  child: Text(
                    context.appStrings.cancel,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: const Size(0, 48),
                  ),
                  child: Text(
                    context.appStrings.watch_ad_button,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _showBudgetDialog(BuildContext context, {Budget? budget}) {
    final viewModel = context.read<BudgetViewModel>();
    final state = viewModel.state;

    if (state is! BudgetLoaded) return;

    final expenseCategories = Category.values
        .where((c) => c.isExpense)
        .toList();
    final categoryLimits = {
      for (final budget in state.budgets) budget.category: budget.limitCents,
    };

    Category selectedCategory = budget?.category ?? expenseCategories.first;

    final controller = TextEditingController(
      text: budget != null ? (budget.limitCents / 100).toStringAsFixed(2) : '',
    );

    final isEditing = budget != null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          final scheme = Theme.of(context).colorScheme;
          final categoryColor = selectedCategory.color;

          return AnimatedPadding(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                    maxWidth: 400,
                  ),
                  child: Material(
                    borderRadius: BorderRadius.circular(28),
                    color: scheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: categoryColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(36),
                              ),
                              child: Center(
                                child: Text(
                                  selectedCategory.emoji,
                                  style: const TextStyle(fontSize: 36),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Text(
                              isEditing
                                  ? context.appStrings.edit_budget_limit
                                  : context.appStrings.new_budget_limit,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              isEditing
                                  ? context.appStrings.adjust_budget_limit
                                  : context.appStrings.define_budget_limit,
                              style: TextStyle(
                                fontSize: 14,
                                color: scheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),

                            const SizedBox(height: 24),

                            if (!isEditing) ...[
                              _buildCategoryDropdown(
                                context,
                                scheme,
                                selectedCategory,
                                expenseCategories,
                                categoryLimits,
                                (category) {
                                  setState(() {
                                    selectedCategory = category!;
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                            ],

                            _buildAmountInput(
                              context,
                              controller,
                              categoryColor,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              context.appStrings.budget_limit_description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: scheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),

                            const SizedBox(height: 24),

                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      side: const BorderSide(
                                        color: Color(0xFFE5E7EB),
                                        width: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: const Size(0, 48),
                                    ),
                                    child: Text(
                                      context.appStrings.cancel,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final limit =
                                          ((double.tryParse(
                                                        controller.text
                                                            .replaceAll(
                                                              ',',
                                                              '.',
                                                            ),
                                                      ) ??
                                                      0) *
                                                  100)
                                              .toInt();

                                      if (limit > 0) {
                                        _isCreatingBudget = true;
                                        viewModel.addBudget(
                                          selectedCategory.name,
                                          state.month,
                                          state.year,
                                          limit,
                                        );

                                        _hasChanges = true;
                                        Navigator.pop(dialogContext);
                                      }
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      minimumSize: const Size(0, 48),
                                      backgroundColor: categoryColor,
                                    ),
                                    child: Text(context.appStrings.save),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildCategoryDropdown(
  BuildContext context,
  ColorScheme scheme,
  Category selectedCategory,
  List<Category> categories,
  Map<Category, int> categoryLimits,
  Function(Category?) onChanged,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.appStrings.category_label_upper,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: DropdownButtonFormField<Category>(
          initialValue: selectedCategory,
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Text(
                selectedCategory.emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
          ),
          items: categories.map((category) {
            final currentLimit = categoryLimits[category];
            return DropdownMenuItem(
              value: category,
              child: Text(
                currentLimit != null
                    ? '${category.label(context.appStrings)} · ${context.appStrings.current_limit_label}'
                    : category.label(context.appStrings),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String emoji;

  const _SectionHeader({required this.title, required this.emoji});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
              letterSpacing: -0.3,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildAmountInput(
  BuildContext context,
  TextEditingController controller,
  Color categoryColor,
) {
  final scheme = Theme.of(context).colorScheme;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        context.appStrings.monthly_limit_label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: categoryColor,
        ),
        decoration: InputDecoration(
          prefixText: 'R\$ ',
          prefixStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: categoryColor,
          ),
          hintText: '0,00',
          filled: true,
          fillColor: scheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: scheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: categoryColor, width: 2),
          ),
        ),
      ),
    ],
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Text('📉', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              context.appStrings.no_budget_defined,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
