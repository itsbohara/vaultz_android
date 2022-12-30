import 'package:vaultz/controllers/bottom_tab_controller.dart';
import 'package:vaultz/controllers/directory.controller.dart';
import 'package:vaultz/controllers/file.controller.dart';
import 'package:vaultz/controllers/route_controller.dart';
import 'package:vaultz/controllers/settings_controller.dart';
import 'package:vaultz/controllers/vaultz_controller.dart';
import 'package:vaultz/repository/file_repo.dart';
import 'package:vaultz/repository/user_repo.dart';
import 'package:get/get.dart';
import 'package:vaultz/controllers/auth_controller.dart';
// import 'package:vaultz/controllers/settings_controller.dart';
import 'package:vaultz/core/api_client.dart';
import 'package:vaultz/repository/auth_repo.dart';

import 'package:vaultz/services/settings_service.dart';
import 'package:vaultz/utils/constants.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final storage = const FlutterSecureStorage();
  final _authToken = await storage.read(key: "session");

  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => storage);
  //api client
  Get.lazyPut(
      () => ApiClient(appBaseUrl: AppConstants.apiBASEURL, token: _authToken));

  Get.lazyPut(() => AuthRepo(apiClient: Get.find(), storage: Get.find()));

  //repos
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => FileRepo(apiClient: Get.find()));

  //service
  Get.lazyPut(() =>
      SettingsService(sharedPreferences: Get.find(), storage: Get.find()));

  // controllers
  Get.lazyPut(() => SettingsController(Get.find()));
  Get.lazyPut(() => BottomTabController());
  Get.lazyPut(() => AuthController(authRepo: Get.find(), storage: Get.find()));
  Get.lazyPut(
      () => VaultzController(authRepo: Get.find(), storage: Get.find()));

  Get.lazyPut(() => DirectoryController(fileRepo: Get.find()));

  Get.lazyPut(() => FileController(fileRepo: Get.find(), storage: Get.find()));
  Get.lazyPut(() => VaultzRouteController());
}
