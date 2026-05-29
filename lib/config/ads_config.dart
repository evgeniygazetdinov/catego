import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Идентификаторы рекламных блоков РСЯ.
///
/// Для тестов: `demo-banner-yandex`.
/// Перед релизом замените на блоки из https://partner.yandex.ru
abstract final class AdsConfig {
  static const demoStickyBannerAdUnitId = 'demo-banner-yandex';

  // TODO: подставьте реальные ad unit ID после создания блоков в РСЯ.
  static const androidStickyBannerAdUnitId = demoStickyBannerAdUnitId;
  static const iosStickyBannerAdUnitId = demoStickyBannerAdUnitId;

  static String get stickyBannerAdUnitId {
    if (kIsWeb) return demoStickyBannerAdUnitId;
    if (Platform.isIOS) return iosStickyBannerAdUnitId;
    return androidStickyBannerAdUnitId;
  }
}
