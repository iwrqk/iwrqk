import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:queue/queue.dart';

import '../../../const/iwara.dart';
import '../../services/account_service.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;

  RefreshTokenInterceptor(this._dio);

  AccountService accountService = Get.find<AccountService>();
  Queue queue = Queue();

  String accessTokenUrl =
      "https://${IwaraConst.apiHost}${IwaraConst.accessTokenPath}";

  Future<String?> getAccessToken() async {
    if (accountService.isTokenExpired()) {
      accountService.notifyTokenExpired();
      return null;
    } else {
      if (accountService.isAccessTokenExpired()) {
        return null;
      } else {
        return accountService.accessToken;
      }
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    bool needRegetAccessToken = false;

    if (response.statusCode == 401) {
      needRegetAccessToken = true;
    } else {
      if (accountService.isLogin &&
          response.requestOptions.path != accessTokenUrl) {
        if (await getAccessToken() == null) {
          needRegetAccessToken = true;
        }
      }
    }

    if (needRegetAccessToken) {
      bool success = await queue.add(() async {
        var requestToken = response.requestOptions.headers["authorization"];
        var globalToken = "Bearer ${accountService.accessToken}";

        if (requestToken == globalToken || requestToken == null) {
          return await accountService.getAccessToken().then((value) {
            if (value.success) {
              response.requestOptions.headers["authorization"] =
                  "Bearer ${accountService.accessToken}";
              return true;
            } else {
              return false;
            }
          });
        }
        return true;
      });

      if (success) {
        return handler.resolve(await _dio.request(
          response.requestOptions.path,
          data: response.requestOptions.data,
          queryParameters: response.requestOptions.queryParameters,
          options: Options(
            method: response.requestOptions.method,
            headers: response.requestOptions.headers,
          ),
        ));
      } else {
        return handler.next(response);
      }
    } else {
      return handler.next(response);
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path == accessTokenUrl) {
      options.headers["authorization"] = "Bearer ${accountService.token}";
    } else {
      String? accessToken = await getAccessToken();
      if (accessToken != null) {
        options.headers["authorization"] = "Bearer $accessToken";
      }
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.next(err);
  }
}
