import 'package:finances_control/feat/review/data/repo/review_repository.dart';

class MarkCsvUploadedUseCase {
  final ReviewRepository repository;
  MarkCsvUploadedUseCase(this.repository);
  Future<void> call() => repository.incrementCsvImportCount();
}
