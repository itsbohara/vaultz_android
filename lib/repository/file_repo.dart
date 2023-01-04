import 'dart:io';

import 'package:get/get.dart';
import 'package:vaultz/controllers/auth_controller.dart';
import 'package:vaultz/core/api_client.dart';
import 'package:vaultz/utils/constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class FileRepo extends GetxService {
  final ApiClient apiClient;
  // final FlutterSecureStorage storage;
  // final SharedPreferences sharedPrefences;
  FileRepo({required this.apiClient});

  Future<Response> uploadFile(File file,
      {String? dir, bool mbCloud = false}) async {
    var fileName = file.path.split('/').last;
    if (mbCloud) {
      return uploadToMBCloud(file, fileName, dir: dir, encrypted: false);
    }
    var uploadFile = MultipartFile(file, filename: fileName);
    final form = FormData({'file': uploadFile});
    if (dir != null) form.fields.add(MapEntry('directory', dir));

    return await apiClient.putData("/directory/local/new", form);
    // return await GetConnect().post(AppConstants.MB_CLOUD_SERVER, )
  }

  Future<Response> uploadEncryptedFile(
      File file, String fileName, String fileType,
      {String? dir, bool mbCloud = false}) async {
    if (mbCloud) {
      return await uploadToMBCloud(file, fileName,
          fileType: fileType, dir: dir, encrypted: true);
    }
    var uploadFile =
        MultipartFile(file, filename: fileName, contentType: fileType);
    final form = FormData({'file': uploadFile, "encrypted": true});
    if (dir != null) form.fields.add(MapEntry('directory', dir));

    return await apiClient.putData("/directory/local/new", form);
  }

  Future<Response> uploadToMBCloud(File file, String fileName,
      {String? dir, String? fileType, bool encrypted = false}) async {
    MultipartFile uploadFile;
    if (encrypted) {
      uploadFile = MultipartFile(file,
          filename: "$fileName.Vltz", contentType: fileType!);
    } else {
      uploadFile = MultipartFile(file, filename: fileName);
    }
    final form = FormData({
      'file': uploadFile,
      "encrypted": encrypted,
      "api": AppConstants.MB_CLOUD_API
    });
    if (dir != null) {
      form.fields
          .add(MapEntry('dir', "${Get.find<AuthController>().user?.id}/$dir"));
    }

    var res = await GetConnect().post(AppConstants.MB_CLOUD_ENDPOINT, form);
    var cloudFile = res.body['data']['file'];
    var body = {
      "name": cloudFile['name'],
      'originalname': fileName,
      'path': cloudFile['path'],
      'size': file.lengthSync(),
      'mimetype': fileType,
      'url': res.body['data']['url'],
      'encrypted': encrypted,
      'directory': dir
    };
    return await apiClient.putDataOnly("/directory/new", body);
  }

  Future<Response> getFolders({bool hidden = false}) async {
    return await apiClient.getData('/folders?hidden=$hidden');
  }

  Future<Response> getFiles({bool hidden = false}) async {
    return await apiClient.getData('/files?hidden=$hidden');
  }

  Future<Response> getFolder(String folderID) async {
    return await apiClient.getData('/directory/$folderID');
  }

  Future<Response> getTrash() async {
    return await apiClient.getData('/trash');
  }

  Future<Response> getTrashFolder(String folderID) async {
    return await apiClient.getData('/trash/$folderID');
  }

  Future<Response> newFolder(dynamic data) async {
    return await apiClient.postData('/directory/new', data);
  }

  Future<Response> updateFolder(String folderID, dynamic data) async {
    return await apiClient.patchData('/directory/$folderID', data);
  }

  Future<Response> trashFolder(String folderID) async {
    return await apiClient.deleteData('/directory/$folderID/trash');
  }

  Future<Response> restoreFolder(String folderID) async {
    return await apiClient.deleteData('/directory/$folderID/restore');
  }

  Future<Response> deleteFolder(String folderID) async {
    return await apiClient.deleteData('/directory/$folderID');
  }

  Future<Response> updateFile(String fileID, dynamic data) async {
    return await apiClient.patchData('/file/$fileID', data);
  }

  Future<Response> trashFile(String fileID) async {
    return await apiClient.deleteData('/file/$fileID/trash');
  }

  Future<Response> restoreFile(String fileID) async {
    return await apiClient.deleteData('/file/$fileID/restore');
  }

  Future<Response> deleteFile(String fileID) async {
    return await apiClient.deleteData('/file/$fileID');
  }

  Future<Response> clearTrash() async {
    return await apiClient.deleteData('/trash');
  }
}
