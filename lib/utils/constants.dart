import 'package:flutter/foundation.dart';

class AppConstants {
  static const int APP_VERSION = 1;
  static const int FILE_UL = 1024 * 1024 * 1024; //bytes = 1 GB
  // static const String apiBASEURL = kReleaseMode
  //     ? "https://vaultz.itsbohara.com/api"
  //     : "http://192.168.0.108:9999/api";
  // static const String apiBASEURL = "http://192.168.0.108:9999/api";
  static const String apiBASEURL = "https://vaultz.itsbohara.com/api";

  static const int pbkdf2iterations = 150000;
  static const int PBKDF2DeriveBitLength = 384;

  static const String MB_CLOUD_ENDPOINT =
      "https://cloud-server.itsbohara.com/v1/file/upload";
  static const String MB_CLOUD_API =
      "4877411e13fbb560444a9f198728bff94f94f62287099b0dbf758af201c9eb6d";
}
