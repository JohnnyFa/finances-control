import 'package:finances_control/core/remote_config/enum/remote_config_key.dart';

abstract class AppRemoteConfig {
  String getString(RemoteConfigKey key);

  bool getBool(RemoteConfigKey key);

  Map<String, dynamic>? getJson(RemoteConfigKey key);

  List<Map<String, dynamic>> getJsonList(RemoteConfigKey key);
}