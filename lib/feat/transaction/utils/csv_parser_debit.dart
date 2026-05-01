import 'package:csv/csv.dart';
import 'package:diacritic/diacritic.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/utils/category_detector.dart';

import '../services/csv_header_detector.dart';

class CsvParserDebit {
  List<Transaction> parse(String csv) {
    final normalizedCsv = csv.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // 🔥 Detect delimiter (CRITICAL FIX)
    final firstLine = normalizedCsv.split('\n').first;
    final delimiter = _detectDelimiter(firstLine);

    final rows = CsvToListConverter(
      shouldParseNumbers: false,
      eol: '\n',
      fieldDelimiter: delimiter,
    ).convert(normalizedCsv);

    if (rows.isEmpty) return [];

    final headers = rows.first.map((e) => e.toString()).toList();

    final dateIndex = CsvHeaderDetector.findDateColumn(headers);
    final amountIndex = CsvHeaderDetector.findAmountColumn(headers);
    final descIndex = CsvHeaderDetector.findDescriptionColumn(headers);

    if (dateIndex == null || amountIndex == null || descIndex == null) {
      throw Exception('CSV format not recognized');
    }

    final transactions = <Transaction>[];

    for (final row in rows.skip(1)) {
      if (row.length <=
          [dateIndex, amountIndex, descIndex]
              .reduce((a, b) => a > b ? a : b)) {
        continue;
      }

      final cols = row.map((e) => e.toString()).toList();

      final dateStr = cols[dateIndex].trim();
      final amountStr = cols[amountIndex].trim();
      final description = cols[descIndex].trim();

      if (dateStr.isEmpty || amountStr.isEmpty) continue;

      try {
        final date = _parseDate(dateStr);
        final amount = _parseAmount(amountStr);

        if (amount == 0) continue;

        final type = amount < 0
            ? TransactionType.expense
            : TransactionType.income;

        final absoluteAmount = amount.abs();

        transactions.add(
          Transaction(
            amount: (absoluteAmount * 100).round(),
            type: type,
            category: CategoryDetector.detect(description),
            date: date,
            description: description,
            externalId: _generateExternalId(date, amount, description),
          ),
        );
      } catch (_) {
        continue;
      }
    }

    return transactions;
  }

  // 🔥 Detect CSV delimiter correctly
  String _detectDelimiter(String headerLine) {
    if (headerLine.contains('\t')) return '\t';
    if (headerLine.contains(';')) return ';';
    return ',';
  }

  DateTime _parseDate(String raw) {
    try {
      return DateTime.parse(raw);
    } catch (_) {}

    final parts = raw.split('/');

    if (parts.length == 3) {
      return DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
    }

    throw FormatException('Invalid date format: $raw');
  }

  /// ✅ Handles BOTH BR and US formats safely
  double _parseAmount(String value) {
    final trimmed = value.trim();

    // 1.234,56 → BR
    if (trimmed.contains(',') && trimmed.contains('.')) {
      return double.parse(
        trimmed
            .replaceAll('.', '')
            .replaceAll(',', '.'),
      );
    }

    // 123,45 → BR simple
    if (trimmed.contains(',')) {
      return double.parse(
        trimmed.replaceAll(',', '.'),
      );
    }

    // 123.45 → US
    return double.parse(trimmed);
  }

  String _generateExternalId(
      DateTime date,
      double amount,
      String description,
      ) {
    final normalized = removeDiacritics(description.toLowerCase().trim());

    return '${date.toIso8601String()}_${amount}_${normalized.hashCode}';
  }
}