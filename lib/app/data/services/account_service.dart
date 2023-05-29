import 'dart:convert';

import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../core/utils/display_util.dart';
import '../enums/result.dart';
import '../providers/api_provider.dart';
import '../providers/storage_provider.dart';

class AccountService extends GetxService {
  String? token;
  String? accessToken;

  final RxBool _isLogin = false.obs;

  bool get isLogin => _isLogin.value;

  set isLogin(bool isLogin) {
    _isLogin.value = isLogin;
  }

  void reset() {
    token = null;
    accessToken = null;
    isLogin = false;
  }

  bool _isExpired(String tokenStr) {
    var payload = jsonDecode(
        utf8.decode(base64.decode(base64.normalize(tokenStr.split('.')[1]))));
    var exp = payload["exp"];
    return exp < DateTime.now().millisecondsSinceEpoch / 1000;
  }

  bool isTokenExpired() {
    return token == null ? true : _isExpired(token!);
  }

  bool isAccessTokenExpired() {
    return accessToken == null ? true : _isExpired(accessToken!);
  }

  void notifyTokenExpired() {
    if (token != null && _isExpired(token!)) {
      showToast(DisplayUtil.messageNeedLogin);
    }
  }

  Future<ApiResult<void>> _login(String email, String password) async {
    ApiResult<dynamic> results = await ApiProvider.login(email, password);

    if (results.success) {
      token = results.data;
      await StorageProvider.setUserToken(token!);
    }

    return ApiResult(
        data: null, success: results.success, message: results.message);
  }

  Future<ApiResult<void>> getAccessToken() async {
    ApiResult<dynamic> results = await ApiProvider.getAccessToken();

    if (results.success) {
      accessToken = results.data;
    }

    return ApiResult(
        data: null, success: results.success, message: results.message);
  }

  void logout() {
    reset();
    StorageProvider.cleanUserToken();
  }

  Future<ApiResult<void>> login({
    required String email,
    required String password,
  }) async {
    ApiResult<void> results = await _login(email, password);

    if (results.success) {
      results = await getAccessToken();
    }

    if (results.success) {
      isLogin = true;
    }

    return results;
  }

  Future<bool> canLoginFromCache() async {
    token = await StorageProvider.userToken;

    if (token != null) {
      if (_isExpired(token!)) {
        return false;
      } else {
        return true;
      }
    }

    return false;
  }

  Future<ApiResult<void>> loginFromCache() async {
    ApiResult<void> results = ApiResult(data: null, success: false);

    token = await StorageProvider.userToken;

    if (_isExpired(token!)) {
      results = await getAccessToken();
    } else {
      isLogin = true;
      results = ApiResult(data: null, success: true);
    }

    return results;
  }
}
