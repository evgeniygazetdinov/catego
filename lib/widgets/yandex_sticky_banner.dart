import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import '../config/ads_config.dart';

/// Адаптивный sticky banner Яндекс Рекламы внизу экрана.
class YandexStickyBanner extends StatefulWidget {
  const YandexStickyBanner({
    super.key,
    this.adUnitId,
  });

  /// Если не задан — выбирается по платформе из [AdsConfig].
  final String? adUnitId;

  @override
  State<YandexStickyBanner> createState() => _YandexStickyBannerState();
}

class _YandexStickyBannerState extends State<YandexStickyBanner> {
  BannerAd? _banner;
  StreamSubscription<BannerAdLoadState>? _loadStateSubscription;
  StreamSubscription<BannerAdEvent>? _eventsSubscription;
  var _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    _createAndLoadBanner();
  }

  Future<void> _createAndLoadBanner() async {
    final width = MediaQuery.sizeOf(context).width.toInt();
    final adSize = BannerAdSize.sticky(width: width);
    final banner = BannerAd(adSize: adSize);

    _loadStateSubscription = banner.loadStateStream.listen((state) {
      if (state is BannerAdLoadStateLoaded && mounted) {
        setState(() {});
      }
    });

    _eventsSubscription = banner.events.listen((_) {});

    if (!mounted) {
      await banner.destroy();
      return;
    }

    setState(() => _banner = banner);
    await banner.load(
      AdRequest(adUnitId: widget.adUnitId ?? AdsConfig.stickyBannerAdUnitId),
    );
  }

  @override
  void dispose() {
    _loadStateSubscription?.cancel();
    _eventsSubscription?.cancel();
    _banner?.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banner = _banner;
    if (banner == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AdWidget(bannerAd: banner),
      ),
    );
  }
}
