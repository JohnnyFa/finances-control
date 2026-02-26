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
  String _query = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TransactionViewModel>().load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.of(context).pushNamed(
            HomePath.transaction.path,
          );

          if (added == true && mounted) {
            context.read<TransactionViewModel>().load();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _TransactionHeader(
            query: _query,
            searchController: _searchController,
            onQueryChanged: (value) => setState(() => _query = value),
          ),
          const SizedBox(height: 14),
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
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        state.errorMessage ?? context.appStrings.unexpected_error,
                        style: TextStyle(color: scheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final filtered = _applyFilters(state.transactions);

                if (filtered.isEmpty) {
                  return Center(child: Text(context.appStrings.no_data));
                }

                final grouped = _groupByMonth(filtered);

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final monthGroup = grouped[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _MonthHeader(
                          month: monthGroup.month,
                          totalCents: monthGroup.totalCents,
                        ),
                        ...monthGroup.transactions.map(
                          (tx) => _TransactionTile(
                            transaction: tx,
                            onUpdated: () =>
                                context.read<TransactionViewModel>().load(),
                          ),
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

  List<Transaction> _applyFilters(List<Transaction> transactions) {
    return transactions.where((tx) {
      final matchesType = _selectedFilter == null || tx.type == _selectedFilter;
      final description = tx.description.trim().toLowerCase();
      final category = categoryLabel(context, tx.category).toLowerCase();
      final query = _query.toLowerCase();
      final matchesQuery = query.isEmpty ||
          description.contains(query) ||
          category.contains(query);

      return matchesType && matchesQuery;
    }).toList();
  }

  List<_MonthTransactionGroup> _groupByMonth(List<Transaction> transactions) {
    final groups = <String, List<Transaction>>{};

    for (final tx in transactions) {
      final key = '${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}';
      groups.putIfAbsent(key, () => []).add(tx);
    }

    final entries = groups.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return entries.map((entry) {
      final monthTransactions = entry.value
        ..sort((a, b) => b.date.compareTo(a.date));

      var totalCents = 0;
      for (final tx in monthTransactions) {
        totalCents += tx.type == TransactionType.income ? tx.amount : -tx.amount;
      }

      return _MonthTransactionGroup(
        month: DateTime(monthTransactions.first.date.year, monthTransactions.first.date.month),
        totalCents: totalCents,
        transactions: monthTransactions,
      );
    }).toList();
  }

  Widget _buildFilters() {
    return SizedBox(
      height: 42,
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
      showCheckmark: false,
      labelStyle: TextStyle(
        color: selected ? scheme.onPrimary : scheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      onSelected: (_) {
        setState(() => _selectedFilter = value);
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

class _TransactionHeader extends StatelessWidget {
  final String query;
  final TextEditingController searchController;
  final ValueChanged<String> onQueryChanged;

  const _TransactionHeader({
    required this.query,
    required this.searchController,
    required this.onQueryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                IconButton.filled(
                  onPressed: () => Navigator.of(context).maybePop(),
                  style: IconButton.styleFrom(
                    backgroundColor: scheme.onPrimary.withValues(alpha: 0.2),
                    foregroundColor: scheme.onPrimary,
                  ),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.appStrings.transactions,
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        context.appStrings.recurring_transactions,
                        style: TextStyle(
                          color: scheme.onPrimary.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: searchController,
              onChanged: onQueryChanged,
              cursorColor: scheme.primary,
              style: TextStyle(color: scheme.onSurface),
              decoration: InputDecoration(
                hintText: context.appStrings.description,
                hintStyle: TextStyle(color: scheme.onSurface.withValues(alpha: 0.6)),
                prefixIcon: const Icon(Icons.search_rounded),
                prefixIconColor: scheme.onSurface.withValues(alpha: 0.7),
                filled: true,
                fillColor: scheme.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          searchController.clear();
                          onQueryChanged('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final DateTime month;
  final int totalCents;

  const _MonthHeader({required this.month, required this.totalCents});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final monthLabel = DateFormat.yMMMM(
      Localizations.localeOf(context).toString(),
    ).format(month);

    final isPositive = totalCents >= 0;

    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 16, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              monthLabel,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                color: scheme.onSurface,
              ),
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'}${formatCurrencyFromCents(context, totalCents.abs())}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: isPositive ? const Color(0xFF14AE5C) : scheme.error,
            ),
          ),
        ],
      ),
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
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSurface,
                    ),
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
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthTransactionGroup {
  final DateTime month;
  final int totalCents;
  final List<Transaction> transactions;

  const _MonthTransactionGroup({
    required this.month,
    required this.totalCents,
    required this.transactions,
  });
}
