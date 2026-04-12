import 'package:finances_control/core/analytics/analytics_service.dart';
import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/core/logger/app_logger.dart';
import 'package:finances_control/feat/ads/utils/ad_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdService {
  InterstitialAd? _interstitialAd;

  void loadAd() {
    if (_interstitialAd != null) return;

    InterstitialAd.load(
      adUnitId: AdIds.interstitial,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          getIt<AnalyticsService>().trackViewAd();
        },
        onAdFailedToLoad: (error) {
          AppLogger.error('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void showAd() {
    if (_interstitialAd == null) {
      loadAd();
      return;
    }

    _interstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _interstitialAd = null;
            loadAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _interstitialAd = null;
            loadAd();
          },
        );

    getIt<AnalyticsService>().trackClickAd();
    _interstitialAd!.show();
  }
}
