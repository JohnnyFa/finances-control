import 'package:finances_control/feat/review/data/repo/review_repository.dart';

class IncrementEntryCountUseCase {
  final ReviewRepository repository;
  IncrementEntryCountUseCase(this.repository);
  Future<void> call() => repository.incrementEntryCount();
}
