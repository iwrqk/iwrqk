import 'package:dio/dio.dart';

import '../../core/const/config.dart';
import '../enums/result.dart';
import '../models/config.dart';

class ConfigProvider {
  static late Dio _dio;

  static void init() {
    _dio = Dio();

    _dio.options.headers = {
      "user-agent":
          "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.5672.76 Mobile Safari/537.36"
    };
  }

  static Future<ApiResult<ConfigModel>> getConfig() async {
    String? message;
    ConfigModel? data;
    try {
      final response = await _dio.get(ConfigConst.githubUrl);
      data = ConfigModel.fromJson(response.data);
    } catch (e) {
      message = e.toString();
    }
    return ApiResult(data: data, message: message, success: message == null);
  }
}
