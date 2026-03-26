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
    final month = _parseMonthFromQuery(query);
    final cleanedQuery = _removeMonthFromQuery(query);

    return transactions.where((tx) {
      final matchesType = selectedFilter == null || tx.type == selectedFilter;

      final description = tx.description.trim().toLowerCase();
      final category = categoryLabel(context, tx.category).toLowerCase();

      final searchQuery = cleanedQuery.toLowerCase();

      final matchesQuery =
          searchQuery.isEmpty ||
          description.contains(searchQuery) ||
          category.contains(searchQuery);

      final matchesMonth = month == null || tx.date.month == month;

      return matchesType && matchesQuery && matchesMonth;
    }).toList();
  }
}

String _removeMonthFromQuery(String query) {
  final words = query.toLowerCase().trim().split(RegExp(r'\s+'));

  const monthKeys = {
    'jan','janeiro','feb','fev','february','fevereiro',
    'mar','março','march','abr','april','abril',
    'may','mai','jun','june','junho',
    'jul','july','julho','aug','agosto','august',
    'sep','set','september','setembro',
    'oct','out','october','outubro',
    'nov','november','novembro',
    'dec','dez','december','dezembro',
  };

  final filtered = words.where((w) => !monthKeys.contains(w));

  return filtered.join(' ');
}

int? _parseMonthFromQuery(String query) {
  final words = query.toLowerCase().trim().split(RegExp(r'\s+'));

  const monthMap = {
    1: {'jan', 'janeiro', 'january'},
    2: {'fev', 'fevereiro', 'feb', 'february'},
    3: {'mar', 'março', 'march'},
    4: {'abr', 'abril', 'apr', 'april'},
    5: {'mai', 'maio', 'may'},
    6: {'jun', 'junho', 'june'},
    7: {'jul', 'julho', 'july'},
    8: {'ago', 'agosto', 'aug', 'august'},
    9: {'set', 'setembro', 'sep', 'september'},
    10: {'out', 'outubro', 'oct', 'october'},
    11: {'nov', 'novembro', 'november'},
    12: {'dez', 'dezembro', 'dec', 'december'},
  };

  for (final word in words) {
    for (final entry in monthMap.entries) {
      if (entry.value.contains(word)) {
        return entry.key;
      }
    }
  }

  return null;
}
