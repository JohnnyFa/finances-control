import 'package:finances_control/feat/review/data/repo/review_repository.dart';
import 'package:finances_control/feat/review/domain/review_condition.dart';

class CheckReviewConditionUseCase {
  final ReviewRepository repository;
  CheckReviewConditionUseCase(this.repository);
  Future<ReviewCondition> call() => repository.getCondition();
}
