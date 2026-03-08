import 'package:flutter/material.dart';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:csv/csv.dart';

class CsvParser {
  static List<Transaction> parse(String csvString, BuildContext context) {
    final normalized = csvString.trim();
    if (normalized.isEmpty) {
      throw FormatException(context.appStrings.csv_error_empty_file);
    }

    final delimiter = normalized.contains(';') ? ';' : ',';
    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
      eol: '\n',
    ).convert(normalized, fieldDelimiter: delimiter);

    if (rows.length < 2) {
      throw FormatException(context.appStrings.csv_error_missing_header_and_rows);
    }

    final headers = rows.first
        .map((cell) => cell.toString().trim().toLowerCase())
        .toList();

    final requiredColumns = ['amount', 'type', 'category', 'date', 'description'];

    for (final column in requiredColumns) {
      if (!headers.contains(column)) {
        throw FormatException(context.appStrings.csv_error_missing_column(column));
      }
    }

    final transactions = <Transaction>[];

    for (var i = 1; i < rows.length; i++) {
      final row = rows[i];

      if (row.every((cell) => cell.toString().trim().isEmpty)) {
        continue;
      }

      String valueFor(String key) {
        final index = headers.indexOf(key);
        return index >= 0 && index < row.length ? row[index].toString().trim() : '';
      }

      final amountRaw = valueFor('amount').replaceAll(',', '.');
      final amountDouble = double.tryParse(amountRaw);
      if (amountDouble == null) {
        throw FormatException(context.appStrings.csv_error_invalid_amount(i + 1, amountRaw));
      }

      final type = _parseType(valueFor('type'), context);
      final category = _parseCategory(valueFor('category'), type, context);
      final date = DateTime.tryParse(valueFor('date'));

      if (date == null) {
        throw FormatException(context.appStrings.csv_error_invalid_date(i + 1));
      }

      transactions.add(
        Transaction(
          amount: (amountDouble * 100).round().abs(),
          type: type,
          category: category,
          date: date,
          description: valueFor('description'),
        ),
      );
    }

    if (transactions.isEmpty) {
      throw FormatException(context.appStrings.csv_error_no_valid_rows);
    }

    return transactions;
  }

  static TransactionType _parseType(String rawType, BuildContext context) {
    final normalized = rawType.trim().toLowerCase();

    if (normalized == 'income') {
      return TransactionType.income;
    }

    if (normalized == 'expense') {
      return TransactionType.expense;
    }

    throw FormatException(context.appStrings.csv_error_invalid_transaction_type(rawType));
  }

  static Category _parseCategory(String rawCategory, TransactionType type, BuildContext context) {
    final normalized = rawCategory.trim().toLowerCase();

    for (final category in Category.values) {
      if (category.name == normalized) {
        return category;
      }
    }

    final availableCategories = Category.values
        .map((category) => category.name)
        .join(', ');
    throw FormatException(context.appStrings.csv_error_invalid_category(rawCategory, type.name, availableCategories));
  }
}
