import 'package:in_app_review/in_app_review.dart';

class ReviewService {
  final InAppReview _inAppReview;

  ReviewService({InAppReview? inAppReview})
      : _inAppReview = inAppReview ?? InAppReview.instance;

  Future<void> requestReview() async {
    if (await _inAppReview.isAvailable()) {
      await _inAppReview.requestReview();
    }
  }
}
