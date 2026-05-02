import 'package:finances_control/components/default_header.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/category_by_type.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:finances_control/feat/transaction/ui/transaction_label_resolver.dart';
import 'package:finances_control/feat/transaction/viewmodel/detail_transaction_state.dart';
import 'package:finances_control/feat/transaction/viewmodel/detail_transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

class DetailTransactionPage extends StatelessWidget {
  const DetailTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailTransactionViewModel, DetailTransactionState>(
      listener: (context, state) {
        if (state.isDeleted) {
          Navigator.pop(context, true);
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        final transaction = state.transaction;
        final scheme = Theme.of(context).colorScheme;
        final r = transaction;

        final isIncome = r.type == TransactionType.income;
        final categoryColor = r.category.color;

        final accentColor = isIncome
            ? const Color(0xFF4CAF50)
            : const Color(0xFFEF4444);

        final emojiLarge = isIncome
            ? context.appStrings.income_emoji
            : context.appStrings.expense_emoji;

        final formattedDate = DateFormat.yMMMd(
          Localizations.localeOf(context).toString(),
        ).format(r.date);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, dynamic result) {
            if (didPop) return;
            Navigator.pop(context, state.hasUpdated);
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: Column(
              children: [
                DefaultHeader(
                  title: context.appStrings.details_title,
                  subtitle: context.appStrings.complete_transaction_subtitle,
                  type: isIncome ? HeaderType.income : HeaderType.expense,
                  onBack: () => Navigator.pop(context, state.hasUpdated),
                ),
                Expanded(
                  child: SafeArea(
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.symmetric(
                            vertical: 36,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: accentColor.withValues(alpha: 0.25),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                emojiLarge,
                                style: const TextStyle(fontSize: 80, height: 1),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                r.category.label(context.appStrings),
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: scheme.onSurface,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (r.isGenerated)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF3B82F6,
                                    ).withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    context.appStrings.recurring,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF3B82F6),
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () => _showAmountDialog(context, r),
                                borderRadius: BorderRadius.circular(12),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    "${isIncome ? '+' : '-'}${formatCurrencyFromCents(context, r.amount.abs())}",
                                    style: TextStyle(
                                      fontSize: 44,
                                      fontWeight: FontWeight.w900,
                                      color: accentColor,
                                      letterSpacing: -1.5,
                                      height: 1.1,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        _ModernInfoCard(
                          icon: Icons.calendar_today_rounded,
                          iconColor: categoryColor,
                          label: context.appStrings.date_label,
                          value: formattedDate,
                        ),

                        const SizedBox(height: 12),

                        InkWell(
                          onTap: () => _showCategoryDialog(context, r),
                          borderRadius: BorderRadius.circular(16),
                          child: _ModernInfoCard(
                            icon: Icons.category_rounded,
                            iconColor: categoryColor,
                            label: context.appStrings.category_label,
                            value: r.category.label(context.appStrings),
                            emoji: r.category.emoji,
                          ),
                        ),

                        const SizedBox(height: 12),

                        InkWell(
                          onTap: () => _showDescriptionDialog(context, r),
                          borderRadius: BorderRadius.circular(16),
                          child: _ModernInfoCard(
                            icon: Icons.notes_rounded,
                            iconColor: categoryColor,
                            label: context.appStrings.description_label,
                            value: r.description.isEmpty
                                ? r.category.label(context.appStrings)
                                : r.description,
                          ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () =>
                                _confirmDelete(context, transaction),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFEF4444),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(
                                color: Color(0xFFEF4444),
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  context.appStrings.delete_transaction_button,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Transaction transaction) {
    final viewModel = context.read<DetailTransactionViewModel>();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.all(24),
        title: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Center(
                child: Text("⚠️", style: TextStyle(fontSize: 32)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              context.appStrings.delete_transaction_title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        content: Text(
          context.appStrings.delete_transaction_message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, height: 1.6),
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
                    Navigator.pop(dialogContext);
                    viewModel.delete();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: const Size(0, 48),
                  ),
                  child: Text(
                    context.appStrings.delete,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
        actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        actionsAlignment: MainAxisAlignment.center,
      ),
    );
  }

  void _showAmountDialog(BuildContext context, Transaction r) {
    final viewModel = context.read<DetailTransactionViewModel>();
    final controller = TextEditingController(
      text: formatCurrencyFromCents(context, r.amount.abs()),
    );
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.appStrings.amount),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
          inputFormatters: [
            CurrencyInputFormatter(
              useSymbolPadding: true,
              thousandSeparator: ThousandSeparator.Period,
              mantissaLength: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.appStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              final amountText = toNumericString(controller.text);
              final amount = int.tryParse(amountText);
              if (amount != null) {
                viewModel.updateAmount(amount, context.appStrings);
              }
              Navigator.pop(dialogContext);
            },
            child: Text(context.appStrings.save),
          ),
        ],
      ),
    );
  }

  void _showDescriptionDialog(BuildContext context, Transaction r) {
    final viewModel = context.read<DetailTransactionViewModel>();
    final controller = TextEditingController(text: r.description);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.appStrings.description),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: context.appStrings.add_description,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.appStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              viewModel.updateDescription(
                controller.text,
                context.appStrings,
              );
              Navigator.pop(dialogContext);
            },
            child: Text(context.appStrings.save),
          ),
        ],
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, Transaction r) async {
    final viewModel = context.read<DetailTransactionViewModel>();
    final categories = categoryByType[r.type] ?? [];
    final selected = await showModalBottomSheet<Category>(
      context: context,
      builder: (_) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: categories.map((c) {
              return ListTile(
                leading: Text(categoryEmoji(context, c)),
                title: Text(categoryLabel(context, c)),
                onTap: () => Navigator.pop(context, c),
              );
            }).toList(),
          ),
        );
      },
    );

    if (selected != null && context.mounted) {
      viewModel.updateCategory(selected, context.appStrings);
    }
  }
}

class _ModernInfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String? emoji;

  const _ModernInfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.emoji,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: emoji != null
                  ? Text(emoji!, style: const TextStyle(fontSize: 22))
                  : Icon(icon, size: 20, color: iconColor),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
