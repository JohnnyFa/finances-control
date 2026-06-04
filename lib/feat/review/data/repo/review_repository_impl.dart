import 'package:finances_control/core/shared_preferences/preferences_keys.dart';
import 'package:finances_control/feat/review/data/repo/review_repository.dart';
import 'package:finances_control/feat/review/domain/review_condition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  @override
  Future<ReviewCondition> getCondition() async {
    final prefs = await SharedPreferences.getInstance();
    return ReviewCondition(
      entryCount: prefs.getInt(PreferencesKeys.reviewEntryCount) ?? 0,
      transactionCount:
          prefs.getInt(PreferencesKeys.reviewTransactionCount) ?? 0,
      csvImportCount: prefs.getInt(PreferencesKeys.reviewCsvImportCount) ?? 0,
      reviewRequested: prefs.getBool(PreferencesKeys.reviewRequested) ?? false,
    );
  }

  @override
  Future<void> incrementEntryCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      PreferencesKeys.reviewEntryCount,
      (prefs.getInt(PreferencesKeys.reviewEntryCount) ?? 0) + 1,
    );
  }

  @override
  Future<void> incrementTransactionCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      PreferencesKeys.reviewTransactionCount,
      (prefs.getInt(PreferencesKeys.reviewTransactionCount) ?? 0) + 1,
    );
  }

  @override
  Future<void> incrementCsvImportCount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      PreferencesKeys.reviewCsvImportCount,
      (prefs.getInt(PreferencesKeys.reviewCsvImportCount) ?? 0) + 1,
    );
  }

  @override
  Future<void> markReviewRequested() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PreferencesKeys.reviewRequested, true);
  }
}
