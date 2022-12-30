import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:vaultz/services/settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController extends GetxController {
  SettingsController(this._settingsService);

  // Make SettingsService a private variable so it is not used directly.
  final SettingsService _settingsService;

  // Make ThemeMode a private variable so it is not updated directly without
  // also persisting the changes with the SettingsService.
  late ThemeMode _themeMode;

  // Allow Widgets to read the user's preferred ThemeMode.
  ThemeMode get themeMode => _themeMode;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  bool _biometricAuthenticated = false;
  bool get bioAuth => _biometricAuthenticated;

  /// Load the user's settings from the SettingsService. It may load from a
  /// local database or the internet. The controller only knows it can load the
  /// settings from the service.
  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();
    updateTheme(_themeMode);
    _biometricAuthenticated = await _settingsService.isBiometricAuthenticated();
    update();
  }

  /// Update and persist the ThemeMode based on the user's selection.
  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;

    // Do not perform any work if new and old ThemeMode are identical
    if (newThemeMode == _themeMode) return;

    // Otherwise, store the new ThemeMode in memory
    _themeMode = newThemeMode;
    updateTheme(newThemeMode);
    // Important! Inform listeners a change has occurred.
    update();

    // Persist the changes to a local database or the internet using the
    // SettingService.
    await _settingsService.updateThemeMode(newThemeMode);
  }

  void updateTheme(ThemeMode newThemeMode) {
    if (newThemeMode == ThemeMode.dark) _isDarkMode = true;
    if (newThemeMode == ThemeMode.light) _isDarkMode = false;
    if (newThemeMode == ThemeMode.system) {
      var brightness = SchedulerBinding.instance.window.platformBrightness;
      _isDarkMode = (brightness == Brightness.dark);
    }
    update();
  }

  Future<void> enableDarkMode(bool darkMode) async {
    if (darkMode) {
      _isDarkMode = true;
      updateThemeMode(ThemeMode.dark);
    } else {
      _isDarkMode = false;
      updateThemeMode(ThemeMode.light);
    }
    update();
  }

  Future<void> updateBiometricAuth(bool auth) async {
    _biometricAuthenticated = auth;
    await _settingsService.updateBiometricAuthentication(auth);
    update();
  }
}
