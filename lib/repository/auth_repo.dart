import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:vaultz/core/api_client.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo extends GetxService {
  final ApiClient apiClient;
  final FlutterSecureStorage storage;
  // final SharedPreferences sharedPrefences;
  AuthRepo({required this.apiClient, required this.storage});

  Future<Response> login(String email, String password) async {
    return await apiClient
        .postData('/account/login', {'email': email, 'password': password});
  }

  Future<Response> verifyCode(String code) async {
    return await apiClient.postData('/account/verify', {'verification': code});
  }

  Future<Response> registerUser(dynamic data) async {
    return await apiClient.postData('/account/register', data);
  }

  Future<Response> getCurrentUser() async {
    return await apiClient.getData('/account/me');
  }

  Future<Response> getUserProfileData() async {
    return await apiClient.getData('/account/me');
  }

  // temp for verification

  setAuthHeaderToken(String token) {
    apiClient.token = token;
    apiClient.updateHeader(token);
  }

// save current /input token
  saveUserToken({String? token}) async {
    var _token = token;
    if (token != null) {
      apiClient.token = token;
      apiClient.updateHeader(token);
    } else {
      _token = apiClient.token;
    }
    return await storage.write(key: 'session', value: _token);
  }

  remoUserToken() async {
    apiClient.token = null;
    apiClient.updateHeader(null);
    return await storage.delete(key: "session");
  }
}
