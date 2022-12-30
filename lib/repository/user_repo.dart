import 'package:vaultz/core/api_client.dart';
import 'package:get/get.dart';

class UserRepo extends GetxService {
  final ApiClient apiClient;
  UserRepo({required this.apiClient});

  Future<Response> updateName(String name) async {
    return await apiClient.postData('/account/update', {'name': name});
  }

  Future<Response> getUserProfileData() async {
    return await apiClient.getData('/account/me');
  }
}
