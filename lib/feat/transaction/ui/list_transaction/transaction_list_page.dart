import 'dart:async';

import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/ads/enum/ad_placement.dart';
import 'package:finances_control/feat/ads/ui/banner_add_widget.dart';
import 'package:finances_control/feat/ads/vm/ad_state.dart';
import 'package:finances_control/feat/ads/vm/ad_viewmodel.dart';
import 'package:finances_control/feat/home/route/home_path.dart';
import 'package:finances_control/feat/premium/presentation/ui/remove_ads_tile.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_state.dart';
import 'package:finances_control/feat/premium/presentation/vm/purchase_viewmodel.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/ui/list_transaction/transaction_tile.dart';
import 'package:finances_control/feat/transaction/ui/model/ui_model.dart';
import 'package:finances_control/feat/transaction/ui/list_transaction/month_header.dart';
import 'package:finances_control/feat/transaction/ui/list_transaction/transaction_filter_chips.dart';
import 'package:finances_control/feat/transaction/ui/list_transaction/transaction_header.dart';
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
  bool _hasChanges = false;
  late final AdViewModel _adViewModel;
  StreamSubscription<AdState>? _adSubscription;

  bool get _canShowAd {
    final adState = _adViewModel.state;
    return adState is AdLoaded && adState.shouldShow;
  }

  @override
  void initState() {
    super.initState();
    _adViewModel =
        getIt<AdViewModel>(param1: AdPlacement.transactions)..load();
    context.read<TransactionViewModel>().load();

    _adSubscription = _adViewModel.stream.listen((state) {
      if (!mounted) return;
      final shouldEnableAds = state is AdLoaded && state.shouldShow;

      context.read<TransactionViewModel>().setAdsEnabled(shouldEnableAds);

      if (shouldEnableAds) {
        context.read<TransactionViewModel>().interstitialService.loadAd();
      }
    });
  }

  @override
  void dispose() {
    _adSubscription?.cancel();
    _adViewModel.close();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purchaseViewModel = BlocProvider.maybeOf<PurchaseViewModel>(context);

    final scaffold = Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BlocBuilder<AdViewModel, AdState>(
        builder: (context, state) {
          if (state is AdLoaded && state.shouldShow) {
            return const AdWidget();
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final added = await Navigator.of(
            context,
          ).pushNamed(HomePath.transaction.path);

          if (added == true && mounted) {
            this.context.read<TransactionViewModel>().load();
            _hasChanges = true;
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
            onImportCsvPressed: () {
              context.read<TransactionViewModel>().importCsv();
            },
            onBackPressed: () => Navigator.pop(context, _hasChanges),
          ),
          BlocBuilder<AdViewModel, AdState>(
            builder: (context, state) {
              if (state is AdLoaded && state.shouldShow) {
                return const RemoveAdsTile();
              }

              return const SizedBox.shrink();
            },
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
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
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
                  return _EmptyTransactionsState();
                }

                final grouped = TransactionGrouper.groupByMonth(filtered);

                final items = <TransactionListItem>[];

                for (final group in grouped) {
                  items.add(
                    MonthHeaderItem(month: group.month, total: group.totalCents),
                  );

                  for (final tx in group.transactions) {
                    items.add(TransactionItem(tx));
                  }
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    if (item is MonthHeaderItem) {
                      return MonthHeader(month: item.month, totalCents: item.total);
                    }

                    if (item is TransactionItem) {
                      final tx = item.tx;

                      return TransactionTile(
                        transaction: tx,
                        onUpdated: () {
                          context.read<TransactionViewModel>().load();
                          _hasChanges = true;
                        },
                        onDelete: () async {
                          final id = tx.id;

                          if (id != null) {
                            await context.read<TransactionViewModel>().delete(tx);

                            if (context.mounted) {
                              context.read<TransactionViewModel>().load();
                            }

                            _hasChanges = true;
                          }
                        },
                      );
                    }

                    return const SizedBox();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );

    final content = purchaseViewModel != null
        ? BlocListener<PurchaseViewModel, PurchaseState>(
            listener: (context, state) {
              if (state is! PurchaseLoading) return;
              _adViewModel.load();
            },
            child: scaffold,
          )
        : scaffold;

    return BlocProvider.value(
      value: _adViewModel,
      child: BlocListener<TransactionViewModel, TransactionState>(
        listener: (context, state) {
          if (state is TransactionLoaded && state.importedCount != null) {
            _hasChanges = true;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                content: Row(
                  children: [
                    const Text('🎉', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.appStrings.csv_import_success(
                          state.importedCount!,
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );

            if (_canShowAd) {
              context.read<TransactionViewModel>().interstitialService.showAd();
            }
          }

          if (state is TransactionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                content: Row(
                  children: [
                    const Text('🚨', style: TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        context.appStrings.csv_import_failed(state.message),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        child: content,
      ),
    );
  }
}

class _EmptyTransactionsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🧾', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 20),
              Text(
                context.appStrings.no_transactions_yet,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                context.appStrings.start_tracking_expenses,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: scheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Text(
                      context.appStrings.tap_plus_to_add,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
