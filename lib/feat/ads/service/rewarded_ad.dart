import 'dart:async';

import 'package:finances_control/feat/ads/utils/ad_ids.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  RewardedAd? _rewardedAd;

  Future<void> loadAd() async {
    await RewardedAd.load(
      adUnitId: AdIds.rewardAd,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
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
    Timer? dismissFallbackTimer;
    final completer = Completer<bool>();

    void completeIfPending(bool value) {
      if (!completer.isCompleted) {
        completer.complete(value);
      }
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;

        unawaited(loadAd());

        if (rewarded) {
          completeIfPending(true);
          return;
        }

        dismissFallbackTimer = Timer(const Duration(milliseconds: 500), () {
          completeIfPending(false);
        });
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;

        unawaited(loadAd());

        dismissFallbackTimer?.cancel();
        completeIfPending(false);
      },
    );

    _rewardedAd!.show(
      onUserEarnedReward: (_, _) {
        rewarded = true;
        dismissFallbackTimer?.cancel();
        completeIfPending(true);
      },
    );

    return completer.future;
  }
}
