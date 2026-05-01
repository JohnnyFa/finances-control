import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/utils/csv_parser.dart';
import 'package:finances_control/feat/transaction/utils/csv_parser_debit.dart';
import 'package:diacritic/diacritic.dart';

class CsvParserResolver {
  static List<Transaction> parse(String csv) {
    if (_isDebitCsv(csv)) {
      return CsvParserDebit().parse(csv);
    } else {
      return CsvParser().parse(csv);
    }
  }

  static bool _isDebitCsv(String csv) {
    final normalized = csv.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    final lines = normalized.split('\n');

    if (lines.isEmpty) return false;

    final delimiter = _detectDelimiter(lines.first);

    final headers = lines.first
        .split(delimiter)
        .map((e) => removeDiacritics(e.toLowerCase().trim()))
        .toList();

    // 🥇 Exact format (your debit CSV)
    final isExactDebitFormat =
        headers.contains('identificador') &&
        headers.contains('valor') &&
        headers.contains('descricao');

    if (isExactDebitFormat) return true;

    // 🥈 Balance column (other banks)
    final hasBalance = headers.any(
      (h) => h.contains('saldo') || h.contains('balance'),
    );

    if (hasBalance) return true;

    // 🥉 Other hints
    final hasDebitHints = headers.any(
      (h) =>
          h.contains('tipo') ||
          h.contains('entrada') ||
          h.contains('saida') ||
          h.contains('moviment'),
    );

    if (hasDebitHints) return true;

    return false;
  }
}

String _detectDelimiter(String headerLine) {
  if (headerLine.contains(';')) return ';';
  return ',';
}
