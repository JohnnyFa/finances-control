import 'package:finances_control/core/analytics/analytics_service.dart';
import 'package:finances_control/core/di/setup_locator.dart';
import 'package:finances_control/feat/ads/utils/ad_ids.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' as ads;

class AdWidget extends StatefulWidget {
  const AdWidget({super.key});

  @override
  State<AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  ads.BannerAd? _bannerAd;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = ads.BannerAd(
      size: ads.AdSize.banner,
      adUnitId: AdIds.banner,
      request: const ads.AdRequest(),
      listener: ads.BannerAdListener(
        onAdLoaded: (ad) {
          getIt<AnalyticsService>().trackViewAd();
          setState(() {
            _loaded = true;
          });
        },
        onAdOpened: (ad) {
          getIt<AnalyticsService>().trackClickAd();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox();

    return Container(
      color: Colors.transparent,
      height: _bannerAd!.size.height.toDouble(),
      width: _bannerAd!.size.width.toDouble(),
      child: ads.AdWidget(ad: _bannerAd!),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
