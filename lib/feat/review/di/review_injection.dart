import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/review/data/repo/review_repository.dart';
import 'package:finances_control/feat/review/data/repo/review_repository_impl.dart';
import 'package:finances_control/feat/review/service/review_service.dart';
import 'package:finances_control/feat/review/usecase/check_review_condition.dart';
import 'package:finances_control/feat/review/usecase/increment_entry_count.dart';
import 'package:finances_control/feat/review/usecase/increment_transaction_count.dart';
import 'package:finances_control/feat/review/usecase/mark_csv_uploaded.dart';

void reviewInjection() {
  getIt.registerLazySingleton<ReviewRepository>(() => ReviewRepositoryImpl());
  getIt.registerLazySingleton(() => ReviewService());
  getIt.registerLazySingleton(
    () => CheckReviewConditionUseCase(getIt<ReviewRepository>()),
  );
  getIt.registerLazySingleton(
    () => IncrementEntryCountUseCase(getIt<ReviewRepository>()),
  );
  getIt.registerLazySingleton(
    () => IncrementTransactionCountUseCase(getIt<ReviewRepository>()),
  );
  getIt.registerLazySingleton(
    () => MarkCsvUploadedUseCase(getIt<ReviewRepository>()),
  );
}
