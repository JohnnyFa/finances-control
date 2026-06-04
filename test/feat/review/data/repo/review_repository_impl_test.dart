import 'package:finances_control/feat/review/data/repo/review_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ReviewRepositoryImpl repo;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repo = ReviewRepositoryImpl();
  });

  test('getCondition returns zeros and false by default', () async {
    final condition = await repo.getCondition();
    expect(condition.entryCount, 0);
    expect(condition.transactionCount, 0);
    expect(condition.csvImportCount, 0);
    expect(condition.reviewRequested, isFalse);
  });

  test('incrementEntryCount increments by one each call', () async {
    await repo.incrementEntryCount();
    await repo.incrementEntryCount();
    final condition = await repo.getCondition();
    expect(condition.entryCount, 2);
  });

  test('incrementTransactionCount increments by one each call', () async {
    await repo.incrementTransactionCount();
    final condition = await repo.getCondition();
    expect(condition.transactionCount, 1);
  });

  test('incrementCsvImportCount increments by one each call', () async {
    await repo.incrementCsvImportCount();
    final condition = await repo.getCondition();
    expect(condition.csvImportCount, 1);
  });

  test('markReviewRequested sets reviewRequested to true', () async {
    await repo.markReviewRequested();
    final condition = await repo.getCondition();
    expect(condition.reviewRequested, isTrue);
  });

  test('isMet becomes true after meeting all thresholds', () async {
    for (var i = 0; i < 5; i++) {
      await repo.incrementEntryCount();
    }
    for (var i = 0; i < 3; i++) {
      await repo.incrementTransactionCount();
    }
    await repo.incrementCsvImportCount();

    final condition = await repo.getCondition();
    expect(condition.isMet, isTrue);
  });

  test('isMet is false after markReviewRequested', () async {
    for (var i = 0; i < 5; i++) {
      await repo.incrementEntryCount();
    }
    for (var i = 0; i < 3; i++) {
      await repo.incrementTransactionCount();
    }
    await repo.incrementCsvImportCount();
    await repo.markReviewRequested();

    final condition = await repo.getCondition();
    expect(condition.isMet, isFalse);
  });
}
