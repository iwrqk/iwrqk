import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/providers/storage_provider.dart';
import '../../data/services/account_service.dart';
import '../../data/services/config_service.dart';
import '../../data/services/plugin/pl_player/service_locator.dart';
import '../../routes/pages.dart';
import '../../utils/display_util.dart';

class SettingsController extends GetxController {
  final ConfigService configService = Get.find();
  final AccountService accountService = Get.find();

  ThemeMode getCurrentTheme() {
    return configService.themeMode;
  }

  void setThemeMode(ThemeMode themeMode) {
    configService.themeMode = themeMode;
  }

  String getCurrentLocalecode() {
    return DisplayUtil.getLocalecode();
  }

  void setLanguage(String localeCode) {
    configService.setLocale(localeCode);
    Get.updateLocale(Locale(localeCode));
  }

  final RxBool _autoPlay = false.obs;
  bool get autoPlay => _autoPlay.value;
  set autoPlay(bool value) {
    _autoPlay.value = value;
    StorageProvider.config[PLPlayerConfigKey.enableQuickDouble] = value;
  }

  final RxBool _backgroundPlay = false.obs;
  bool get backgroundPlay => _backgroundPlay.value;
  set backgroundPlay(bool value) {
    _backgroundPlay.value = value;
    videoPlayerServiceHandler.enableBackgroundPlay = value;
    StorageProvider.config[PLPlayerConfigKey.enableBackgroundPlay] = value;
  }

  final RxBool _enableProxy = false.obs;
  bool get enableProxy => _enableProxy.value;
  set enableProxy(bool value) {
    _enableProxy.value = value;
    StorageProvider.config[StorageKey.proxyEnable] = value;
  }

  bool get workMode => configService.workMode;
  set workMode(bool value) {
    configService.workMode = value;
  }

  @override
  void onInit() {
    super.onInit();
    _autoPlay.value =
        configService.config[PLPlayerConfigKey.enableQuickDouble] ?? true;
    _backgroundPlay.value =
        configService.config[PLPlayerConfigKey.enableBackgroundPlay] ?? false;
    _enableProxy.value =
        StorageProvider.config[StorageKey.proxyEnable] ?? false;
  }

  void logout() {
    accountService.logout();
    Get.offNamedUntil(AppRoutes.home, (route) => false);
  }
}
