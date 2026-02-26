import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/core/formatters/currency_formatter.dart';
import 'package:finances_control/feat/home/route/home_path.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/ui/transaction_details_page.dart';
import 'package:finances_control/feat/transaction/ui/transaction_label_resolver.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_state.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  TransactionType? _selectedFilter;

  @override
  void initState() {
    super.initState();
    context.read<TransactionViewModel>().load();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.appStrings.transactions),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton.filled(
              onPressed: () async {
                final added = await Navigator.of(context).pushNamed(
                  HomePath.transaction.path,
                );

                if (added == true && mounted) {
                  context.read<TransactionViewModel>().load();
                }
              },
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildFilters(),
          const SizedBox(height: 12),
          Expanded(
            child: BlocBuilder<TransactionViewModel, TransactionState>(
              builder: (context, state) {
                if (state.status == TransactionStatus.loading &&
                    state.transactions.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == TransactionStatus.error) {
                  return Center(
                    child: Text(
                      state.errorMessage ?? context.appStrings.unexpected_error,
                      style: TextStyle(color: scheme.error),
                    ),
                  );
                }

                final filtered = state.transactions
                    .where(
                      (tx) =>
                          _selectedFilter == null || tx.type == _selectedFilter,
                    )
                    .toList();

                if (filtered.isEmpty) {
                  return Center(child: Text(context.appStrings.no_data));
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final tx = filtered[index];
                    final previous = index == 0 ? null : filtered[index - 1];
                    final showHeader = previous == null ||
                        previous.date.year != tx.date.year ||
                        previous.date.month != tx.date.month;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showHeader) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 4,
                              bottom: 8,
                              top: 12,
                            ),
                            child: Text(
                              DateFormat.yMMMM(
                                Localizations.localeOf(context).toString(),
                              ).format(tx.date),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                        _TransactionTile(
                          transaction: tx,
                          onUpdated: () => context.read<TransactionViewModel>().load(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _filterChip(context.appStrings.all, null),
          const SizedBox(width: 8),
          _filterChip(context.appStrings.income, TransactionType.income),
          const SizedBox(width: 8),
          _filterChip(context.appStrings.expense, TransactionType.expense),
        ],
      ),
    );
  }

  Widget _filterChip(String label, TransactionType? value) {
    final selected = _selectedFilter == value;
    final scheme = Theme.of(context).colorScheme;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      labelStyle: TextStyle(
        color: selected ? scheme.onPrimary : scheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      onSelected: (_) {
        setState(() => _selectedFilter = value);
      },
      selectedColor: scheme.primary,
      backgroundColor: scheme.surface,
      side: BorderSide(color: scheme.outlineVariant),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onUpdated;

  const _TransactionTile({required this.transaction, required this.onUpdated});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isIncome = transaction.type == TransactionType.income;

    return InkWell(
      onTap: () async {
        final changed = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => TransactionDetailsPage(transaction: transaction),
          ),
        );

        if (changed == true) {
          onUpdated();
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(categoryEmoji(context, transaction.category)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.description.isEmpty
                        ? categoryLabel(context, transaction.category)
                        : transaction.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd MMM • HH:mm').format(transaction.date),
                    style: TextStyle(
                      color: scheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '-'}${formatCurrencyFromCents(context, transaction.amount)}',
              style: TextStyle(
                color: isIncome ? const Color(0xFF14AE5C) : scheme.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
