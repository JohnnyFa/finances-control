import 'package:csv/csv.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/utils/expense_category_detector.dart';

import '../services/csv_header_detector.dart';

class CsvParser {
  List<Transaction> parse(String csv) {
    final normalizedCsv = csv.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
      eol: '\n',
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
      final cols = row.map((e) => e.toString()).toList();

      try {
        final date = _parseDate(cols[dateIndex]);
        final amount = _parseAmount(cols[amountIndex]);

        if (amount < 0) continue;

        final description = cols[descIndex];

        transactions.add(
          Transaction(
            amount: (amount * 100).toInt(),
            type: TransactionType.expense,
            category: ExpenseCategoryDetector.detect(description),
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

  double _parseAmount(String value) {
    final trimmed = value.trim();
    final isParenthesizedNegative =
        trimmed.startsWith('(') && trimmed.endsWith(')');

    final cleaned = trimmed.replaceAll(RegExp(r'[^\d,.\-]'), '');
    final sign = isParenthesizedNegative && !cleaned.startsWith('-')
        ? '-'
        : '';

    return _parseSignedAmount('$sign$cleaned');
  }

  double _parseSignedAmount(String cleaned) {
    final lastComma = cleaned.lastIndexOf(',');
    final lastDot = cleaned.lastIndexOf('.');

    if (lastComma != -1 && lastDot != -1) {
      if (lastComma > lastDot) {
        // BR → 1.234,56
        return double.parse(cleaned.replaceAll('.', '').replaceAll(',', '.'));
      } else {
        // US → 1,234.56
        return double.parse(cleaned.replaceAll(',', ''));
      }
    }

    if (lastComma != -1) {
      return double.parse(cleaned.replaceAll(',', '.'));
    }

    return double.parse(cleaned);
  }

  String _generateExternalId(DateTime date, double amount, String description) {
    final normalized = description.toLowerCase().trim();

    return '${date.toIso8601String()}_${amount}_${normalized.hashCode}';
  }
}
