import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:finances_control/core/services/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _FirebaseAnalyticsMock extends Mock implements FirebaseAnalytics {}

void main() {
  late _FirebaseAnalyticsMock firebaseAnalytics;
  late AnalyticsService analyticsService;

  setUp(() {
    firebaseAnalytics = _FirebaseAnalyticsMock();
    analyticsService = AnalyticsService(firebaseAnalytics);

    when(
      () => firebaseAnalytics.logEvent(
        name: any(named: 'name'),
        parameters: any(named: 'parameters'),
        callOptions: any(named: 'callOptions'),
      ),
    ).thenAnswer((_) async {});
  });

  test('converts bool parameters to strings before logging', () async {
    await analyticsService.logEvent(
      'purchase_state',
      parameters: {
        'is_trial': true,
        'is_renewing': false,
        'count': 1,
      },
    );

    verify(
      () => firebaseAnalytics.logEvent(
        name: 'purchase_state',
        parameters: {
          'is_trial': 'true',
          'is_renewing': 'false',
          'count': 1,
        },
        callOptions: any(named: 'callOptions'),
      ),
    ).called(1);
  });
}
