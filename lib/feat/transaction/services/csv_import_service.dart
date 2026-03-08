import 'dart:convert';
import 'package:finances_control/core/extensions/context_extensions.dart';
import 'package:finances_control/feat/transaction/utils/csv_parser.dart';
import 'package:finances_control/feat/transaction/viewmodel/transaction_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CsvImportService {
  static Future<void> importFromCsv(BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        withData: true,
      );

      if (!context.mounted || result == null || result.files.isEmpty) {
        return;
      }

      final bytes = result.files.single.bytes;
      if (bytes == null || bytes.isEmpty) {
        throw FormatException(context.appStrings.csv_error_could_not_read_bytes);
      }

      final csvString = utf8.decode(bytes);
      final parsedTransactions = CsvParser.parse(csvString, context);
      final importedCount = await context
          .read<TransactionViewModel>()
          .importCsvTransactions(parsedTransactions);

      if (!context.mounted) {
        return;
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(context.appStrings.csv_import_success(importedCount))),
      );
    } catch (e) {
      if (!context.mounted) {
        return;
      }

      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(context.appStrings.csv_import_failed('$e'))),
      );
    }
  }
}
