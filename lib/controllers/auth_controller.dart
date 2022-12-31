import 'package:vaultz/models/ResponseModel.dart';
import 'package:vaultz/models/User.model.dart';
import 'package:vaultz/repository/auth_repo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
// app auth controller

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  final FlutterSecureStorage storage;
  AuthController({required this.authRepo, required this.storage});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _authorized = false;
  bool get isAuthorized => _authorized;
//
  User? _user;
  User? get user => _user;

  String? _session;
  String? get session => _session;

  bool _bioAuth = false;
  bool get bioAuth => _bioAuth;
  String? _bioVaultPass;
  String? get bioVaultzPass => _bioVaultPass;

  Future<void> initAuthUser() async {
    final userSessionToken = await storage.read(key: "session");
    final vaultPass = await storage.read(key: "vaultzBioLoginPass");
    if (userSessionToken != null) {
      var _user = await getCurrentUser();
      _authorized = _user.isSuccess;
      _session = userSessionToken;
    }
    if (vaultPass != null) {
      _bioAuth = true;
      _bioVaultPass = vaultPass;
    }
  }

  Future<ResponseModel> loginUser(String email, String password) async {
    _isLoading = true;
    update();
    late ResponseModel responseModel;

    Response response = await authRepo.login(email, password);
    if (response.statusCode == 200) {
      // @demo:byPass
      await authRepo.saveUserToken(token: response.body['_token']);
      responseModel = ResponseModel(true, 'Login Successfull');
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyLogin(String verificationCode) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyCode(verificationCode);

    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (response.body['verified']) await authRepo.saveUserToken();
      responseModel = ResponseModel(true, 'Login Successfull');
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> registerUser(dynamic data) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registerUser(data);
    late ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, 'Register Successfull');
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> getCurrentUser() async {
    _isLoading = true;
    update();
    Response response = await authRepo.getCurrentUser();
    late ResponseModel responseModel;

    if (response.statusCode == 200) {
      _user = User.fromJson(response.body['currentUser']);
      responseModel = ResponseModel(true, 'Profile Fetched');
    } else {
      responseModel = ResponseModel(false, response.statusText);
      logoutUser();
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> updateBioAuth(bool enable, {String? vaultzPass}) async {
    if (enable && vaultzPass != null) {
      await storage.write(key: "vaultzBioLoginPass", value: vaultzPass);
    } else {
      await storage.delete(key: "vaultzBioLoginPass");
    }
    _bioAuth = enable;
    update();
  }

  Future<void> logoutUser() async {
    await updateBioAuth(false);
    await authRepo.remoUserToken();
    _authorized = false;
    _user = null;
    update();
  }
}
