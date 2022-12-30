import 'package:flutter/services.dart';
import 'package:vaultz/controllers/auth_controller.dart';
import 'package:vaultz/models/ResponseModel.dart';
import 'package:vaultz/models/User.model.dart';
import 'package:vaultz/repository/auth_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:vaultz/utils/constants.dart';
import 'dart:convert' show base64, utf8;
import 'package:webcrypto/webcrypto.dart';

// app auth controller

class VaultzController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final FlutterSecureStorage storage;
  VaultzController({required this.authRepo, required this.storage});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _authorized = false;
  bool get isAuthorized => _authorized;
//
  Uint8List? _key;
  Uint8List? get key => _key;

  Future<ResponseModel> loginWithBioAuth() async {
    return login(Get.find<AuthController>().bioVaultzPass!);
  }

  Future<ResponseModel> login(String password) async {
    _isLoading = true;
    update();

    late ResponseModel responseModel;
    try {
      final auth = Get.find<AuthController>();
      var rawUCodedKey = auth.user?.vaultzKey;
      var rawEncKey =
          Uri.decodeComponent(utf8.decode(base64.decode(rawUCodedKey!)));

      // derive key from pass and decrypt vault key
      var importedKey =
          await Pbkdf2SecretKey.importRawKey(utf8.encode(password));
      var pbkdf2bytes = await importedKey.deriveBits(
          AppConstants.PBKDF2DeriveBitLength,
          Hash.sha256,
          rawEncKey.codeUnits.sublist(12, 20),
          AppConstants.pbkdf2iterations);

      var keybytes = pbkdf2bytes.sublist(0, 32);
      var ivbytes = pbkdf2bytes.sublist(32);
      var encKeyData = rawEncKey.codeUnits.sublist(20);

      var key = await AesCbcSecretKey.importRawKey(keybytes);
      _key = await key.decryptBytes(encKeyData, ivbytes);

      responseModel = ResponseModel(true, 'Vaultz Authorized');
    } catch (e) {
      responseModel = ResponseModel(false, "Invalid master credential!");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> logout() async {
    _authorized = false;
    _key = null;
    update();
  }
}
