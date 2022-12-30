import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetConnect implements GetxService {
  late String? token;
  final String appBaseUrl;

  late Map<String, String> _mainHeaders;
  late Map<String, String> _fileHeaders;
  late FlutterSecureStorage storage;
  // late SharedPreferences sharedPreferences;

  ApiClient({required this.appBaseUrl, this.token}) {
    baseUrl = appBaseUrl;
    timeout = const Duration(seconds: 30);

    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    _fileHeaders = {
      // 'Content-Type': 'multipart/form-data; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
  }

  void updateHeader(String? token) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    _fileHeaders = {'Authorization': 'Bearer $token'};
  }

  Future<Response> getData(String url) async {
    try {
      Response response = await get(url, headers: _mainHeaders);
      //returns the successful json object
      // return response.data;
      return _response(response);
    } catch (e) {
      //returns the error object if there is
      // return e.response!.data;
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> postData(String url, dynamic body) async {
    try {
      Response response = await post(url, body, headers: _mainHeaders);
      return _response(response);
    } on SocketException {
      return Response(statusCode: 502, statusText: "No internet connection!");
    } on HttpException {
      return Response(statusCode: 500, statusText: "Something went wrong!");
    } catch (e) {
      //returns the error object if there is
      // return e.response!.data;
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> patchData(String url, dynamic data) async {
    try {
      Response response = await patch(url, data, headers: _mainHeaders);
      return _response(response);
    } on SocketException {
      return Response(statusCode: 502, statusText: "No internet connection!");
    } on HttpException {
      return Response(statusCode: 500, statusText: "Something went wrong!");
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> putData(String url, FormData data) async {
    try {
      Response response = await put(url, data, headers: _fileHeaders);
      print("afer puttting");
      print(response.body);
      return _response(response);
    } on SocketException {
      return Response(statusCode: 502, statusText: "No internet connection!");
    } on HttpException {
      return Response(statusCode: 500, statusText: "Something went wrong!");
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> putDataOnly(String url, dynamic data) async {
    try {
      Response response = await put(url, data, headers: _fileHeaders);
      return _response(response);
    } on SocketException {
      return Response(statusCode: 502, statusText: "No internet connection!");
    } on HttpException {
      return Response(statusCode: 500, statusText: "Something went wrong!");
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Future<Response> deleteData(String url, {dynamic body}) async {
    try {
      Response response = await delete(url, headers: _mainHeaders);
      return _response(response);
    } catch (e) {
      return Response(statusCode: 1, statusText: e.toString());
    }
  }

  Response _response(Response response) {
    Response _response;
    switch (response.statusCode) {
      case 200:
      case 201:
        return Response(statusCode: 200, body: response.body);
      case 400:
      case 401:
        _response =
            Response(statusCode: response.statusCode, body: response.body);
        break;
      case 500:
      case 501:
      case 502:
        _response = Response(
            statusCode: 0,
            statusText: "Something went wrong!",
            body: response.body);
        break;
      default:
        _response =
            Response(statusCode: 0, statusText: "Something went wrong!");
    }
    return responseError(_response);
  }

  Response responseError(Response? response, {String? fallback}) {
    var error = fallback ??
        response?.body?['message'] ??
        response?.statusText ??
        "Something went wrong!";

    if (response?.body?['errors'] != null &&
        response?.body['errors'][0] != null) {
      error = response?.body['errors'][0]['message'] ?? error;
    }
    return Response(statusCode: response?.statusCode ?? 0, statusText: error);
  }
}
