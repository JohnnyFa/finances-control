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
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _filterChip(context, context.appStrings.all, null),
          const SizedBox(width: 8),
          _filterChip(context, context.appStrings.income, TransactionType.income),
          const SizedBox(width: 8),
          _filterChip(context, context.appStrings.expense, TransactionType.expense),
        ],
      ),
    );
  }

  Widget _filterChip(
    BuildContext context,
    String label,
    TransactionType? value,
  ) {
    final selected = selectedFilter == value;
    final scheme = Theme.of(context).colorScheme;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      labelStyle: TextStyle(
        color: selected ? scheme.onPrimary : scheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      onSelected: (_) {
        onFilterChanged(value);
      },
      selectedColor: scheme.primary,
      backgroundColor: scheme.surface,
      side: BorderSide(
        color: selected ? scheme.primary : scheme.outlineVariant,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
