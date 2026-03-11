import 'dart:convert';

import 'package:file_picker/file_picker.dart';

class CsvFilePickerService {
  Future<String?> pickCsvContent() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
      withData: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final bytes = result.files.single.bytes;
    if (bytes == null || bytes.isEmpty) {
      throw const FormatException('Could not read CSV bytes.');
    }

    return utf8.decode(bytes);
  }
}
