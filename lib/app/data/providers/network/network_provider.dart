import 'package:dio/dio.dart';

import '../../../core/const/iwara.dart';
import 'refresh_token_interceptor.dart';

class NetworkProvider {
  static final NetworkProvider _singleton = NetworkProvider._internal();

  factory NetworkProvider() {
    return _singleton;
  }

  late Dio _dio;

  NetworkProvider._internal() {
    _dio = Dio();

    _dio.options.validateStatus = (status) => (status ?? 0) < 500;
    _dio.options.headers = {
      "accept": "application/json",
      "accept-encoding": "gzip, deflate, br",
      "accept-language": "zh-CN,zh;q=0.9,en;q=0.8,en-GB;q=0.7,en-US;q=0.6",
      "content-type": "application/json",
      "user-agent":
          "Mozilla/5.0 (Linux; Android 10) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Mobile Safari/537.36"
    };
    _dio.options.sendTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.baseUrl = "https://";
    _dio.interceptors.add(RefreshTokenInterceptor(_dio));
    _dio.interceptors.add(LogInterceptor());
  }

  void dispose() {
    _dio.close();
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) =>
      getFullUrl(
        "${IwaraConst.apiHost}$path",
        queryParameters: queryParameters,
        headers: headers,
      );

  Future<Response> getFullUrl(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    final response = await _dio.get(
      url,
      queryParameters: queryParameters,
      options: Options(headers: headers),
    );

    return response;
  }

  Future<Response> postFullUrl(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    final response = await _dio.post(
      url,
      queryParameters: queryParameters,
      options: Options(headers: headers),
      data: data,
    );

    return response;
  }

  Future<Response> post(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic data,
  }) =>
      postFullUrl(
        "${IwaraConst.apiHost}$path",
        queryParameters: queryParameters,
        headers: headers,
        data: data,
      );

  Future<Response> deleteFullUrl(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic data,
  }) async {
    final response = await _dio.delete(
      url,
      queryParameters: queryParameters,
      options: Options(headers: headers),
      data: data,
    );

    return response;
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    dynamic data,
  }) =>
      deleteFullUrl(
        "${IwaraConst.apiHost}$path",
        queryParameters: queryParameters,
        headers: headers,
        data: data,
      );
}
