import 'dart:convert';

import 'package:finances_control/core/remote_config/enum/remote_config_key.dart';
import 'package:finances_control/core/remote_config/extensions/remote_config_key_x.dart';
import 'package:finances_control/core/remote_config/implementation/app_remote_config.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class FirebaseRemoteConfigImpl implements AppRemoteConfig {
  final FirebaseRemoteConfig remoteConfig;

  FirebaseRemoteConfigImpl(this.remoteConfig);

  @override
  String getString(RemoteConfigKey key) {
    return remoteConfig.getString(key.key);
  }

  @override
  bool getBool(RemoteConfigKey key) {
    return remoteConfig.getBool(key.key);
  }

  @override
  Map<String, dynamic>? getJson(RemoteConfigKey key) {
    final jsonString = remoteConfig.getString(key.key);

    if (jsonString.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(jsonString);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      debugPrint('⚠️ RemoteConfig ${key.key} is not a JSON object');
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  List<Map<String, dynamic>> getJsonList(RemoteConfigKey key) {
    final jsonString = remoteConfig.getString(key.key);

    if (jsonString.isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonString);

      if (decoded is List) {
        return decoded
            .whereType<Map<String, dynamic>>()
            .toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}