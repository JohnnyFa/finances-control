import 'package:finances_control/core/remote_config/enum/remote_config_key.dart';

extension RemoteConfigKeyX on RemoteConfigKey {
  String get key {
    switch (this) {
      case RemoteConfigKey.ebooks:
        return 'ebooks';
      case RemoteConfigKey.allowedAds:
        return 'allowed_ads';
    }
  }
}