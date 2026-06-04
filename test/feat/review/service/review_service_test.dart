import 'package:finances_control/feat/review/service/review_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late _MockInAppReview mockInAppReview;
  late ReviewService service;

  setUp(() {
    mockInAppReview = _MockInAppReview();
    service = ReviewService(inAppReview: mockInAppReview);
  });

  test('requestReview calls plugin when available', () async {
    when(() => mockInAppReview.isAvailable()).thenAnswer((_) async => true);
    when(() => mockInAppReview.requestReview()).thenAnswer((_) async {});

    await service.requestReview();

    verify(() => mockInAppReview.requestReview()).called(1);
  });

  test('requestReview does not call plugin when unavailable', () async {
    when(() => mockInAppReview.isAvailable()).thenAnswer((_) async => false);

    await service.requestReview();

    verifyNever(() => mockInAppReview.requestReview());
  });
}

class _MockInAppReview extends Mock implements InAppReview {}
