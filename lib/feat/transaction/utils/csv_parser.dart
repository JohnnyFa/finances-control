import 'package:csv/csv.dart';
import 'package:finances_control/feat/transaction/domain/enum_transaction.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/utils/category_detector.dart';

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

      final date = _parseDate(cols[dateIndex]);
      final amount = double.parse(cols[amountIndex].replaceAll(',', '.'));

      if (amount < 0) continue;

      final description = cols[descIndex];

      transactions.add(
        Transaction(
          amount: (amount * 100).toInt(),
          type: TransactionType.expense,
          category: CategoryDetector.detect(description),
          date: date,
          description: description,
          externalId: _generateExternalId(date, amount, description),
        ),
      );
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

  String _generateExternalId(DateTime date, double amount, String description) {
    final normalized = description.toLowerCase().trim();

    return '${date.toIso8601String()}_${amount}_${normalized.hashCode}';
  }
}
