import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends GetxService {
  final FlutterSecureStorage storage;
  final SharedPreferences sharedPreferences;

  SettingsService({required this.storage, required this.sharedPreferences});

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<ThemeMode> themeMode() async {
    var _mode = sharedPreferences.getString('themeMode');
    if (_mode != null) {
      if (_mode == 'dark')
        return ThemeMode.dark;
      else
        return ThemeMode.light;
    }
    return ThemeMode.system;
  }

  /// Persists the user's preferred ThemeMode to local or remote storage.
  Future<bool> updateThemeMode(ThemeMode theme) async {
    // Get.changeThemeMode(theme);
    // Use the shared_preferences package to persist settings locally or the
    // http package to persist settings over the network.
    var _mode = 'light';
    if (theme == ThemeMode.dark) _mode = 'dark';

    if (theme == ThemeMode.system) {
      return await sharedPreferences.remove('themeMode');
    }

    return await sharedPreferences.setString('themeMode', _mode);
  }

  Future<bool> isBiometricAuthenticated() async {
    // storage.read(key: key)
    return sharedPreferences.getBool('bioMetricAuthentication') ?? false;
  }

  Future<bool> updateBiometricAuthentication(bool enable) async {
    return await sharedPreferences.setBool('bioMetricAuthentication', enable);
  }
}
