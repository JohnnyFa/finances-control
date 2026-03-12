import 'package:flutter/foundation.dart';

class AdIds {
  static const _bannerTest = 'ca-app-pub-3940256099942544/6300978111';

  static const _bannerProd = 'ca-app-pub-3084358367947146/3777335424';

  static String get banner =>
      kReleaseMode ? _bannerProd : _bannerTest;

  static const _interstitialTest = 'ca-app-pub-3940256099942544/1033173712';

  static const _interstitialProd = 'ca-app-pub-3084358367947146/7193331676';

  static String get interstitial =>
      kReleaseMode ? _interstitialProd : _interstitialTest;
}