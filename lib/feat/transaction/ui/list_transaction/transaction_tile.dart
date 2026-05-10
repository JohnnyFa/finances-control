import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/extension/category_extension.dart';
import 'package:finances_control/feat/transaction/route/transaction_path.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onUpdated;
  final VoidCallback onDelete;

  const TransactionTile({
    super.key,
    required this.transaction,
    required this.onUpdated,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final r = transaction;

    final isIncome = r.type == TransactionType.income;
    final categoryColor = r.category.color;

    final dateTime = r.date;
    final date = DateFormat('dd MMM', 'pt_BR').format(dateTime);

    final dismissibleKey = ValueKey<String>(
      'transaction-${r.id ?? 'no-id'}-${r.date.millisecondsSinceEpoch}-${r.amount}-${r.description}',
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: dismissibleKey,
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return _showDeleteConfirmationDialog(context);
        },
        onDismissed: (_) {
          onDelete();
        },
        background: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              final hasChanged = await Navigator.of(
                context,
              ).pushNamed(TransactionPath.transactionDetail.path, arguments: r);

              if (hasChanged == true && context.mounted) {
                context.read<TransactionViewModel>().load();
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: scheme.surface,
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.3),
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
                child: Row(
                  children: [
                    Container(
                      width: 5,
                      height: 84,
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: categoryColor.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Center(
                                child: Text(
                                  r.category.emoji,
                                  style: const TextStyle(fontSize: 26),
                                ),
                              ),
                            ),

                            const SizedBox(width: 14),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.description.isEmpty
                                        ? r.category.label(context.appStrings)
                                        : r.description,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: scheme.onSurface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: categoryColor.withValues(
                                              alpha: 0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            r.category.label(
                                              context.appStrings,
                                            ),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: categoryColor,
                                              letterSpacing: 0.3,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 8),

                                      Text(
                                        date,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: scheme.onSurface.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 12),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${isIncome ? '+' : '-'}R\$ ${(r.amount / 100).toStringAsFixed(2).replaceAll('.', ',')}',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: isIncome
                                        ? const Color(0xFF4CAF50)
                                        : const Color(0xFFEF4444),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.appStrings.delete_transaction_title),
        content: Text(context.appStrings.delete_transaction_message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.appStrings.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(context.appStrings.delete),
          ),
        ],
      ),
    );
  }
}
