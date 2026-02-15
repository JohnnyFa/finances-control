import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/home/ui/widget/home_card.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/transaction/domain/recurring_transaction.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:finances_control/feat/transaction/ui/transaction_label_resolver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecurringSection extends StatelessWidget {
  const RecurringSection({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return BlocBuilder<HomeViewModel, HomeState>(
      buildWhen: (prev, curr) => prev.recurring != curr.recurring,
      builder: (context, state) {
        if (state.recurring.isEmpty) {
          return const SizedBox();
        }

        final items = state.recurring;

        return HomeCard(
          color: scheme.surface,
          elevation: 2,
          borderRadius: BorderRadius.circular(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '🔁 ${context.appStrings.recurring_transactions}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${items.length}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              ..._buildRecurringList(context, items, scheme),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildRecurringList(
    BuildContext context,
    List<RecurringTransaction> items,
    ColorScheme scheme,
  ) {
    final widgets = <Widget>[];

    for (int i = 0; i < items.length; i++) {
      widgets.add(_RecurringTile(transaction: items[i]));

      if (i != items.length - 1) {
        widgets.add(const SizedBox(height: 8));
        widgets.add(
          Divider(height: 1, color: scheme.onSurface.withValues(alpha: 0.15)),
        );
        widgets.add(const SizedBox(height: 8));
      }
    }

    return widgets;
  }
}

class _RecurringTile extends StatelessWidget {
  final RecurringTransaction transaction;

  const _RecurringTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final r = transaction;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(r.category.emoji, style: const TextStyle(fontSize: 20)),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryLabel(context, r.category),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface,
                  ),
                ),
                Text(
                  '${context.appStrings.every} ${r.dayOfMonth}',
                  style: TextStyle(
                    fontSize: 13,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          Text(
            formatCurrencyFromCents(context, r.amount.toInt()),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
