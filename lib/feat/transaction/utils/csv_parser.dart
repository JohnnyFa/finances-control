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

    final accountType = CsvHeaderDetector.detectAccountType(headers);
    final transactions = <Transaction>[];

    for (final row in rows.skip(1)) {
      final cols = row.map((e) => e.toString()).toList();

      if (cols.length <= dateIndex ||
          cols.length <= amountIndex ||
          cols.length <= descIndex) {
        continue;
      }

      final date = _parseDate(cols[dateIndex]);
      final amount = _parseAmount(cols[amountIndex]);
      final description = cols[descIndex].trim();

      final type = resolveTransactionType(
        accountType: accountType,
        amount: amount,
        description: description,
      );

      if (type == null) continue;

      transactions.add(
        Transaction(
          amount: (amount.abs() * 100).toInt(),
          type: type,
          category: CategoryDetector.detect(description),
          date: date,
          description: description,
          externalId: _generateExternalId(date, amount.abs(), description),
        ),
      );
    }

    return transactions;
  }

  TransactionType? resolveTransactionType({
    required AccountType accountType,
    required double amount,
    required String description,
  }) {
    final normalizedDescription = CsvHeaderDetector.normalizeText(description);

    if (accountType == AccountType.credit) {
      final isCreditCardPayment = _creditCardPaymentKeywords.any(
        normalizedDescription.contains,
      );

      if (isCreditCardPayment) return null;

      return TransactionType.expense;
    }

    final isTransfer = _transferKeywords.any(normalizedDescription.contains);

    if (isTransfer) return null;

    if (amount > 0) return TransactionType.income;
    if (amount < 0) return TransactionType.expense;

    return null;
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

  double _parseAmount(String raw) {
    final trimmed = raw.trim();

    if (trimmed.isEmpty) {
      throw const FormatException('Invalid amount format');
    }

    final sanitized = trimmed.replaceAll(RegExp(r'[^0-9,.\-]'), '');
    final hasComma = sanitized.contains(',');
    final hasDot = sanitized.contains('.');

    String normalized;

    if (hasComma && hasDot) {
      final lastComma = sanitized.lastIndexOf(',');
      final lastDot = sanitized.lastIndexOf('.');
      final decimalSeparator = lastComma > lastDot ? ',' : '.';
      final thousandsSeparator = decimalSeparator == ',' ? '.' : ',';

      normalized = sanitized.replaceAll(thousandsSeparator, '');

      if (decimalSeparator == ',') {
        normalized = normalized.replaceAll(',', '.');
      }
    } else {
      normalized = sanitized.replaceAll(',', '.');
    }

    return double.parse(normalized);
  }

  String _generateExternalId(DateTime date, double amount, String description) {
    final normalized = description.toLowerCase().trim();

    return '${date.toIso8601String()}_${amount}_${normalized.hashCode}';
  }

  static const _creditCardPaymentKeywords = {
    'pagamento',
    'fatura',
    'pagamentorecebido',
  };

  static const _transferKeywords = {
    'transfer',
    'transferencia',
  };
}
