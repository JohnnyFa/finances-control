import 'package:flutter/material.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/ui/transaction_label_resolver.dart';

class TransactionFilter {
  static List<Transaction> applyFilters(
    List<Transaction> transactions,
    TransactionType? selectedFilter,
    String query,
    BuildContext context,
  ) {
    return transactions.where((tx) {
      final matchesType = selectedFilter == null || tx.type == selectedFilter;
      final description = tx.description.trim().toLowerCase();
      final category = categoryLabel(context, tx.category).toLowerCase();
      final searchQuery = query.toLowerCase();
      final matchesQuery = searchQuery.isEmpty ||
          description.contains(searchQuery) ||
          category.contains(searchQuery);

      return matchesType && matchesQuery;
    }).toList();
  }
}
