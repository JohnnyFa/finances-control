import 'dart:async';

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
        },
        onAdFailedToLoad: (error) {
          AppLogger.error('Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  void showAd() {
    showAdAndWait();
  }

  Future<bool> showAdAndWait() async {
    if (_interstitialAd == null) {
      loadAd();
      return false;
    }

    final completer = Completer<bool>();

    _interstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            _interstitialAd = null;
            loadAd();
            if (!completer.isCompleted) {
              completer.complete(true);
            }
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            _interstitialAd = null;
            loadAd();
            if (!completer.isCompleted) {
              completer.complete(false);
            }
          },
        );

    _interstitialAd!.show();
    return completer.future;
  }
}
