import 'package:flutter/material.dart';
import 'package:vaultz/app.dart';

import 'package:vaultz/controllers/settings_controller.dart';
import 'package:get/get.dart';
import 'core/dependencies.dart' as dep;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dep.init();

  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = Get.find<SettingsController>();
  await settingsController.loadSettings();

  runApp(const Application());
}
