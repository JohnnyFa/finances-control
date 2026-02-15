import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/home/ui/widget/home_card.dart';
import 'package:finances_control/feat/home/viewmodel/home_state.dart';
import 'package:finances_control/feat/home/viewmodel/home_viewmodel.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.autorenew, size: 20, color: scheme.onSurface),
                  const SizedBox(width: 8),
                  Text(
                    context.appStrings.recurring_transactions,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${items.length}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: scheme.primary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              ...items.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RecurringTile(transaction: r),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecurringTile extends StatelessWidget {
  final RecurringTransaction transaction;

  const _RecurringTile({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final r = transaction;

    final isIncome = r.type == TransactionType.income;

    final accent = isIncome ? scheme.primary : scheme.error;

    final onTertiary = scheme.onTertiary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.tertiary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(r.category.emoji, style: const TextStyle(fontSize: 20)),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 12,
                    color: accent,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryLabel(context, r.category),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: onTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${context.appStrings.every} ${r.dayOfMonth}',
                  style: TextStyle(
                    fontSize: 13,
                    color: onTertiary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          Text(
            formatCurrencyFromCents(context, r.amount),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}
