import 'package:finances_control/feat/transaction/services/csv_file_picker_service.dart';
import 'package:finances_control/feat/transaction/usecase/add_transaction.dart';
import 'package:finances_control/feat/transaction/utils/csv_parser.dart';

class ImportCsvTransactionsUseCase {
  final CsvFilePickerService filePickerService;
  final CsvParser csvParser;
  final AddTransactionUseCase addTransactionUseCase;

  ImportCsvTransactionsUseCase({
    required this.filePickerService,
    required this.csvParser,
    required this.addTransactionUseCase,
  });

  Future<int> call() async {
    final csvContent = await filePickerService.pickCsvContent();
    if (csvContent == null) {
      return 0;
    }

    final transactions = csvParser.parse(csvContent);

    for (final transaction in transactions) {
      await addTransactionUseCase(transaction);
    }

    return transactions.length;
  }
}
