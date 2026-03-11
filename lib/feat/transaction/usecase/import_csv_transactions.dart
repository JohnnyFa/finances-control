import 'package:finances_control/feat/transaction/data/transaction/repo/transaction_repository.dart';
import 'package:finances_control/feat/transaction/domain/transaction.dart';
import 'package:finances_control/feat/transaction/services/csv_file_picker_service.dart';
import 'package:finances_control/feat/transaction/utils/csv_parser.dart';

class ImportCsvTransactionsUseCase {
  final CsvFilePickerService filePickerService;
  final CsvParser csvParser;
  final TransactionRepository repository;

  ImportCsvTransactionsUseCase({
    required this.filePickerService,
    required this.csvParser,
    required this.repository,
  });

  Future<int> call() async {
    final csvContent = await filePickerService.pickCsvContent();

    if (csvContent == null) {
      return 0;
    }

    final transactions = csvParser.parse(csvContent);

    if (transactions.isEmpty) {
      return 0;
    }

    final filtered = <Transaction>[];

    for (final tx in transactions) {
      if (tx.externalId == null) {
        filtered.add(tx);
        continue;
      }

      final exists = await repository.existsByExternalId(tx.externalId!);

      if (!exists) {
        filtered.add(tx);
      }
    }

    if (filtered.isEmpty) {
      return 0;
    }

    await repository.insertMany(filtered);

    return filtered.length;
  }
}