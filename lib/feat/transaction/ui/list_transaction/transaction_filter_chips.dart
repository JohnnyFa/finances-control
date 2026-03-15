import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:flutter/material.dart';

class TransactionFilterChips extends StatelessWidget {
  final TransactionType? selectedFilter;
  final ValueChanged<TransactionType?> onFilterChanged;

  const TransactionFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _filterChip(
            context,
            context.appStrings.all,
            null,
            null,
          ),
          const SizedBox(width: 10),
          _filterChip(
            context,
            '📈 ${context.appStrings.income}',
            TransactionType.income,
            const Color(0xFF4CAF50),
          ),
          const SizedBox(width: 10),
          _filterChip(
            context,
            '💸 ${context.appStrings.expense}',
            TransactionType.expense,
            const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(
      BuildContext context,
      String label,
      TransactionType? value,
      Color? accentColor,
      ) {
    final selected = selectedFilter == value;
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => onFilterChanged(value),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            gradient: selected && accentColor != null
                ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accentColor,
                accentColor.withValues(alpha: 0.8),
              ],
            )
                : null,
            color: selected && accentColor == null
                ? scheme.primary
                : scheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? (accentColor ?? scheme.primary)
                  : scheme.outlineVariant.withValues(alpha: 0.5),
              width: selected ? 2 : 1.5,
            ),
            boxShadow: selected
                ? [
              BoxShadow(
                color: (accentColor ?? scheme.primary)
                    .withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : scheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}