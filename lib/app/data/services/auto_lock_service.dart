import 'package:get/get.dart';

import '../../routes/pages.dart';
import '../providers/storage_provider.dart';

abstract class AutoLockConfigKey {
  static const String enable = "enable";
  static const String password = "password";
  static const String enableAuthByBiometrics = "enableAuthByBiometrics";
}

class AutoLockService extends GetxController {
  final RxBool _enableAutoLock = false.obs;

  bool get enableAutoLock => _enableAutoLock.value;

  set enableAutoLock(bool enableAutoLock) {
    _enableAutoLock.value = enableAutoLock;
    StorageProvider.setAutoLockConfig(AutoLockConfigKey.enable, enableAutoLock);
  }

  final RxString _password = ''.obs;

  String get password => _password.value;

  set password(String password) {
    _password.value = password;
    StorageProvider.setAutoLockConfig(AutoLockConfigKey.password, password);
  }

  final RxBool _enableAuthByBiometrics = false.obs;

  bool get enableAuthByBiometrics => _enableAuthByBiometrics.value;

  set enableAuthByBiometrics(bool enableAuthByBiometrics) {
    _enableAuthByBiometrics.value = enableAuthByBiometrics;
    StorageProvider.setAutoLockConfig(
        AutoLockConfigKey.enableAuthByBiometrics, enableAuthByBiometrics);
  }

  void resumed() {
    if (enableAutoLock) {
      Get.toNamed(AppRoutes.lock);
    }
  }

  @override
  void onInit() {
    super.onInit();
    Future.wait([
      StorageProvider.getAutoLockConfigByKey(AutoLockConfigKey.enable),
      StorageProvider.getAutoLockConfigByKey(AutoLockConfigKey.password),
      StorageProvider.getAutoLockConfigByKey(
          AutoLockConfigKey.enableAuthByBiometrics),
    ]).then((value) {
      _enableAutoLock.value = value[0] ?? false;
      _password.value = value[1] ?? '';
      _enableAuthByBiometrics.value = value[2] ?? false;
    });
  }
}
