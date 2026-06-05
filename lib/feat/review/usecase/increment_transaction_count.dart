import 'package:finances_control/feat/review/data/repo/review_repository.dart';

class IncrementTransactionCountUseCase {
  final ReviewRepository repository;
  IncrementTransactionCountUseCase(this.repository);
  Future<void> call() => repository.incrementTransactionCount();
}
