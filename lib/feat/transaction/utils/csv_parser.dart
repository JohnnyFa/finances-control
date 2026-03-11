import 'package:csv/csv.dart';
import 'package:finances_control/feat/transaction/domain/category.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';

class CsvParser {
  List<Transaction> parse(String csvString) {
    final normalized = csvString.trim();
    if (normalized.isEmpty) {
      throw const FormatException('CSV file is empty.');
    }

    final delimiter = normalized.contains(';') ? ';' : ',';
    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
      eol: '\n',
    ).convert(normalized, fieldDelimiter: delimiter);

    if (rows.length < 2) {
      throw const FormatException(
        'CSV must include a header and at least one row.',
      );
    }

    final headers = rows.first
        .map((cell) => cell.toString().trim().toLowerCase())
        .toList();

    const requiredColumns = ['amount', 'type', 'category', 'date', 'description'];

    for (final column in requiredColumns) {
      if (!headers.contains(column)) {
        throw FormatException('CSV header is missing "$column" column.');
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
        return index >= 0 && index < row.length
            ? row[index].toString().trim()
            : '';
      }

      final amountRaw = valueFor('amount').replaceAll(',', '.');
      final amountDouble = double.tryParse(amountRaw);
      if (amountDouble == null) {
        throw FormatException('Invalid amount at line ${i + 1}: "$amountRaw".');
      }

      final type = _parseType(valueFor('type'));
      final category = _parseCategory(valueFor('category'));
      final date = DateTime.tryParse(valueFor('date'));

      if (date == null) {
        throw FormatException(
          'Invalid date at line ${i + 1}. Use ISO-8601 format (e.g. 2026-01-31).',
        );
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
      throw const FormatException('CSV did not contain valid transaction rows.');
    }

    return transactions;
  }

  TransactionType _parseType(String rawType) {
    final normalized = rawType.trim().toLowerCase();

    if (normalized == 'income') {
      return TransactionType.income;
    }

    if (normalized == 'expense') {
      return TransactionType.expense;
    }

    throw FormatException(
      'Invalid transaction type "$rawType". Use income or expense.',
    );
  }

  Category _parseCategory(String rawCategory) {
    final normalized = rawCategory.trim().toLowerCase();

    for (final category in Category.values) {
      if (category.name == normalized) {
        return category;
      }
    }

    final availableCategories = Category.values
        .map((category) => category.name)
        .join(', ');
    throw FormatException(
      'Invalid category "$rawCategory". Use one of: $availableCategories.',
    );
  }
}
