import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../services/user_service.dart';
import '../screens/login_screen.dart';

class Network {
  static dio.Response? response;
  static final dio.Dio _dio = dio.Dio();

  static Future<dynamic> postApi(
    String endUrl,
    dynamic data,
    Map<String, dynamic> header,
  ) async {
    try {
      response = await _dio.post(
        endUrl,
        options: dio.Options(headers: header),
        data: data,
      );
      if (response?.statusCode == 401) {
        await UserService.logout();
        Get.offAll(() => const LoginScreen());
        return null;
      }
      log(response.toString());
      return response!.data;
    } on dio.DioException catch (e) {
      if (e.response == null) {
        log("===========> Error: \\${e.error}");
      } else {
        return e.response!.data;
      }
    }
  }

  static Future<dynamic> getApi(String endUrl) async {
    try {
      response = await _dio.get(
        endUrl,
      );
      log(response.toString());
      return response!.data;
    } on dio.DioException catch (e) {
      if (e.response == null) {
        log("===========> Error: \\${e.error}");
      } else {
        return e.response!.data;
      }
    }
  }
} 