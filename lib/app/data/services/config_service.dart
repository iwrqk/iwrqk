import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../const/widget.dart';
import '../models/account/settings/filter_setting.dart';
import '../providers/config_provider.dart';
import '../providers/storage_provider.dart';

abstract class DynamicConfigKey {
  static const String firstRun = "firstRun";

  static const String themeMode = "themeMode";
  static const String enableDynamicColor = "enableDynamicColor";
  static const String customColor = "customColor";

  static const String workMode = "workMode";
}

abstract class ConfigKey {
  static const String localeCode = "localeCode";

  static const String displayMode = "displayMode";

  static const String playerSetting = "playerSetting";

  static const String notificationPlayer = "notificationPlayer";
}

class ConfigService extends GetxService {
  final GStorageConfig setting = StorageProvider.config;

  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;
  ThemeMode get themeMode => _themeMode.value;
  set themeMode(ThemeMode themeMode) {
    _themeMode.value = themeMode;
    Get.changeThemeMode(themeMode);
    setting[DynamicConfigKey.themeMode] = themeMode.index;
  }

  final RxBool _enableDynamicColor = false.obs;
  bool get enableDynamicColor => _enableDynamicColor.value;
  set enableDynamicColor(bool value) {
    _enableDynamicColor.value = value;
    setting[DynamicConfigKey.enableDynamicColor] = value;
  }

  final RxInt _customColor = 0.obs;
  int get customColor => _customColor.value;
  set customColor(int value) {
    _customColor.value = value;
    setting[DynamicConfigKey.customColor] = value;
  }

  final RxBool _workMode = false.obs;
  bool get workMode => _workMode.value;
  set workMode(bool workMode) {
    _workMode.value = workMode;
    setting[DynamicConfigKey.workMode] = workMode;
  }

  final RxDouble _gridChildAspectRatio = 1.0.obs;
  double get gridChildAspectRatio => _gridChildAspectRatio.value;
  set gridChildAspectRatio(double gridChildAspectRatio) {
    _gridChildAspectRatio.value = gridChildAspectRatio;
  }

  final Rx<FilterSettingModel> _filterSetting = FilterSettingModel().obs;
  FilterSettingModel get filterSetting => _filterSetting.value;
  set filterSetting(FilterSettingModel filterSetting) {
    _filterSetting.value = filterSetting;
  }

  int crossAxisCount = 2;

  void calculateGridChildAspectRatio(Size size, Orientation orientation) {
    int number = size.width / WidgetConst.mediaPreviewPerferedWidth ~/ 1;

    if (orientation == Orientation.landscape) {
      number = size.width / WidgetConst.mediaPreviewPerferedWidth ~/ 1;
    } else {
      number = 2;
    }

    if (number <= 0) return;

    var width = (size.width - (number + 1) * 8) / number;
    var height = width * 9 / 16 +
        WidgetConst.mediaPreviewTitleHeight * Get.textScaleFactor;

    gridChildAspectRatio = width / height;
    crossAxisCount = number;
  }

  void setLocale(AppLocale locale) {
    LocaleSettings.setLocale(locale);
    setting[ConfigKey.localeCode] = locale.languageTag;
  }

  void resetEasyRefresh() {
    EasyRefresh.defaultFooterBuilder = () => ClassicFooter(
          dragText: t.refresh.drag_to_load,
          armedText: t.refresh.release_to_load,
          readyText: t.notifications.loading,
          processingText: t.notifications.loading,
          processedText: t.refresh.success,
          noMoreText: t.refresh.no_more,
          failedText: t.refresh.failed,
          messageText: t.refresh.last_load,
        );
  }

  @override
  void onInit() {
    super.onInit();

    _enableDynamicColor.value =
        setting.get(DynamicConfigKey.enableDynamicColor, defaultValue: true);
    _customColor.value =
        setting.get(DynamicConfigKey.customColor, defaultValue: 10);
    _themeMode.value = ThemeMode
        .values[setting.get(DynamicConfigKey.themeMode, defaultValue: 0)];

    _workMode.value =
        setting.get(DynamicConfigKey.workMode, defaultValue: false);
  }

  Future<void> checkLatestVersion(
      {bool showNoAvailable = false, String? noAvailableMessage}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    await ConfigProvider.getConfig().then((value) async {
      if (value.success) {
        if (value.data!.latestVersion != currentVersion) {
          // todo:
        } else {
          if (showNoAvailable) {
            // todo:
          }
        }
      }
    });
  }
}
