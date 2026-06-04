import 'package:finances_control/feat/review/domain/review_condition.dart';

abstract class ReviewRepository {
  Future<ReviewCondition> getCondition();
  Future<void> incrementEntryCount();
  Future<void> incrementTransactionCount();
  Future<void> incrementCsvImportCount();
  Future<void> markReviewRequested();
}
