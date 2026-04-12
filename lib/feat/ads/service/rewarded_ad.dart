import 'dart:async';

import 'package:finances_control/core/analytics/analytics_service.dart';
import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/ads/utils/ad_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  RewardedAd? _rewardedAd;

  Future<void> loadAd() async {
    await RewardedAd.load(
      adUnitId: AdIds.rewardAd,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          getIt<AnalyticsService>().trackViewAd();
        },
        onAdFailedToLoad: (error) {
          _rewardedAd = null;
        },
      ),
    );
  }

  Future<bool> showAd() async {
    if (_rewardedAd == null) {
      return false;
    }

    bool rewarded = false;
    bool dismissed = false;
    final completer = Completer<bool>();

    void completeIfReady() {
      if (!completer.isCompleted && dismissed && rewarded) {
        completer.complete(true);
      }
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        dismissed = true;
        ad.dispose();
        _rewardedAd = null;

        unawaited(loadAd());

        completeIfReady();

        if (!completer.isCompleted) {
          Future<void>.delayed(const Duration(milliseconds: 300), () {
            if (!completer.isCompleted) {
              completer.complete(rewarded);
            }
          });
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;

        unawaited(loadAd());

        if (!completer.isCompleted) {
          completer.complete(false);
        }
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (_, _) {
        getIt<AnalyticsService>().trackClickAd();
        rewarded = true;
        completeIfReady();
      },
    );

    return completer.future;
  }
}
