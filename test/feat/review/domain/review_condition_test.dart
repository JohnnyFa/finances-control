import 'package:finances_control/feat/review/domain/review_condition.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReviewCondition.isMet', () {
    test('true when all thresholds reached and not yet requested', () {
      const c = ReviewCondition(
        entryCount: 5,
        transactionCount: 3,
        csvImportCount: 1,
        reviewRequested: false,
      );
      expect(c.isMet, isTrue);
    });

    test('false when reviewRequested is true', () {
      const c = ReviewCondition(
        entryCount: 10,
        transactionCount: 10,
        csvImportCount: 10,
        reviewRequested: true,
      );
      expect(c.isMet, isFalse);
    });

    test('false when entryCount below threshold', () {
      const c = ReviewCondition(
        entryCount: 4,
        transactionCount: 3,
        csvImportCount: 1,
        reviewRequested: false,
      );
      expect(c.isMet, isFalse);
    });

    test('false when transactionCount below threshold', () {
      const c = ReviewCondition(
        entryCount: 5,
        transactionCount: 2,
        csvImportCount: 1,
        reviewRequested: false,
      );
      expect(c.isMet, isFalse);
    });

    test('false when csvImportCount below threshold', () {
      const c = ReviewCondition(
        entryCount: 5,
        transactionCount: 3,
        csvImportCount: 0,
        reviewRequested: false,
      );
      expect(c.isMet, isFalse);
    });

    test('true at exact boundary values', () {
      const c = ReviewCondition(
        entryCount: 5,
        transactionCount: 3,
        csvImportCount: 1,
        reviewRequested: false,
      );
      expect(c.isMet, isTrue);
    });
  });
}
