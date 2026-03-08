import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/home/route/home_path.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/services/csv_import_service.dart';
import 'package:finances_control/feat/transaction/ui/widgets/month_header.dart';
import 'package:finances_control/feat/transaction/ui/widgets/transaction_filter_chips.dart';
import 'package:finances_control/feat/transaction/ui/widgets/transaction_header.dart';
import 'package:finances_control/feat/transaction/ui/widgets/transaction_tile.dart';
import 'package:finances_control/feat/transaction/utils/transaction_filter.dart';
import 'package:finances_control/feat/transaction/utils/transaction_grouper.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_state.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.of(context).pushNamed(
            HomePath.transaction.path,
          );

          if (added == true && mounted) {
            this.context.read<TransactionViewModel>().load();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          TransactionHeader(
            query: _query,
            searchController: _searchController,
            onQueryChanged: (value) => setState(() => _query = value),
            onImportCsvPressed: () => CsvImportService.importFromCsv(context),
          ),

          const SizedBox(height: 14),

          TransactionFilterChips(
            selectedFilter: _selectedFilter,
            onFilterChanged: (value) => setState(() => _selectedFilter = value),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: BlocBuilder<TransactionViewModel, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TransactionError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        state.message.isNotEmpty
                            ? state.message
                            : context.appStrings.unexpected_error,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (state is! TransactionLoaded) {
                  return const SizedBox();
                }

                final filtered = TransactionFilter.applyFilters(
                  state.transactions,
                  _selectedFilter,
                  _query,
                  context,
                );

                if (filtered.isEmpty) {
                  return Center(child: Text(context.appStrings.no_data));
                }

                final grouped = TransactionGrouper.groupByMonth(filtered);

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final monthGroup = grouped[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MonthHeader(
                          month: monthGroup.month,
                          totalCents: monthGroup.totalCents,
                        ),

                        ...monthGroup.transactions.map(
                          (tx) => TransactionTile(
                            transaction: tx,
                            onUpdated: () {
                              context.read<TransactionViewModel>().load();
                            },
                            onDelete: () async {
                              final id = tx.id;
                              if (id != null) {
                                await context.read<TransactionViewModel>().delete(id);
                                if (context.mounted) {
                                  context.read<TransactionViewModel>().load();
                                }
                              }
                            },
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
}
