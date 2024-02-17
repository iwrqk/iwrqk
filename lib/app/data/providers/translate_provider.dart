import 'package:dio/dio.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../enums/result.dart';

class TranslateProvider {
  static late Dio _dio;

  static void init() {
    _dio = Dio();

    _dio.options.headers = {
      "user-agent":
          "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.5672.76 Mobile Safari/537.36"
    };
  }

  static String get googleLocaleCode =>
      LocaleSettings.currentLocale.languageTag.replaceAll("-", "_");

  static Future<ApiResult<String>> google({
    required String text,
    String? source,
  }) async {
    String? message;
    String? data;
    try {
      final response = await Dio().get(
        "https://translate.googleapis.com/translate_a/t",
        queryParameters: {
          "client": "gtx",
          "sl": source ?? "auto",
          "tl": googleLocaleCode,
          "dt": "t",
          "q": text,
        },
      );
      data = response.data[0][0];
    } catch (e) {
      message = e.toString();
    }
    return ApiResult(data: data, message: message, success: message == null);
  }
}
