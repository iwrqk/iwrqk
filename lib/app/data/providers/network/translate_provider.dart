import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class TranslateProvider {
  late Dio _dio;

  void init() {
    _dio = Dio();

    _dio.options.headers = {
      "user-agent":
          "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.5672.76 Mobile Safari/537.36"
    };
  }

  static String getGoogleLocaleCode(Locale locale) {
    if (locale.countryCode == null) {
      return locale.languageCode;
    } else {
      return "${locale.languageCode}-${locale.countryCode}";
    }
  }

  static Future<String> google({
    required String text,
    String? source,
    required String target,
  }) async {
    final response = await Dio().get(
      "https://translate.googleapis.com/translate_a/single",
      queryParameters: {
        "client": "gtx",
        "sl": source ?? "auto",
        "tl": target,
        "dt": "t",
        "q": text,
      },
    );

    return response.data[0][0][0];
  }
}
