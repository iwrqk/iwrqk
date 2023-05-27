import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/app/data/models/settings/player_setting.dart';

import '../../core/const/widget.dart';
import '../models/settings/filter_setting.dart';
import '../providers/storage_provider.dart';

abstract class ConfigKey {
  static const String firstRun = "firstRun";

  static const String themeMode = "themeMode";
  static const String localeCode = "localeCode";

  static const String playerSetting = "playerSetting";

  static const String filterSetting = "filterSetting";
  static const String adultCoverBlur = "adultCoverBlur";
}

class ConfigService extends GetxService {
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  late bool firstLoad;

  ThemeMode get themeMode => _themeMode.value;

  set themeMode(ThemeMode themeMode) {
    _themeMode.value = themeMode;
    Get.changeThemeMode(themeMode);
    StorageProvider.setConfig(ConfigKey.themeMode, themeMode.index);
  }

  final RxBool _audltCoverBlur = false.obs;

  bool get adultCoverBlur => _audltCoverBlur.value;

  set adultCoverBlur(bool audltCoverBlur) {
    _audltCoverBlur.value = audltCoverBlur;
    StorageProvider.setConfig(ConfigKey.adultCoverBlur, audltCoverBlur);
  }

  final Rx<FilterSettingModel> _filterSetting = FilterSettingModel().obs;

  FilterSettingModel get filterSetting => _filterSetting.value;

  set filterSetting(FilterSettingModel filterSetting) {
    _filterSetting.value = filterSetting;
    StorageProvider.setConfig(ConfigKey.filterSetting, filterSetting.toJson());
  }

  PlayerSetting _playerSetting = PlayerSetting();

  PlayerSetting get playerSetting => _playerSetting;

  set playerSetting(PlayerSetting playerSetting) {
    _playerSetting = playerSetting;
    StorageProvider.setConfig(ConfigKey.playerSetting, playerSetting.toJson());
  }

  final RxString _localeCode = "en".obs;

  Locale? get locale {
    if (_localeCode.value.isEmpty) {
      return null;
    }
    return formatLocale(_localeCode.value);
  }

  String get localeCode => _localeCode.value;

  set localeCode(String code) {
    _localeCode.value = code;
    StorageProvider.setConfig(ConfigKey.localeCode, code);
  }

  Locale formatLocale(String locale) {
    if (locale.contains("_")) {
      final localeList = locale.split("_");
      return Locale(localeList[0], localeList[1]);
    }
    return Locale(locale);
  }

  final RxDouble _gridChildAspectRatio = 1.0.obs;
  double get gridChildAspectRatio => _gridChildAspectRatio.value;
  set gridChildAspectRatio(double gridChildAspectRatio) {
    _gridChildAspectRatio.value = gridChildAspectRatio;
  }

  int crossAxisCount = 2;

  void calculateGridChildAspectRatio(Size size, Orientation orientation) {
    int number = size.width / WidgetConst.mediaPreviewPerferedWidth ~/ 1;

    if (orientation == Orientation.landscape) {
      number = size.width / WidgetConst.mediaPreviewPerferedWidth ~/ 1;
    } else {
      number = 2;
    }

    var width = (size.width - (number + 1) * 8) / number;
    var height = width * 9 / 16 + WidgetConst.mediaPreviewTitleHeight;

    gridChildAspectRatio = width / height;
    crossAxisCount = number;
  }

  @override
  void onInit() {
    super.onInit();
    if (StorageProvider.getConfigByKey(ConfigKey.firstRun) == null) {
      firstLoad = true;
      StorageProvider.setConfig(ConfigKey.firstRun, false);
    } else {
      firstLoad = false;
    }
    if (!firstLoad) {
      _localeCode.value =
          StorageProvider.getConfigByKey(ConfigKey.localeCode) ?? "en";
    }

    _themeMode.value = ThemeMode
        .values[StorageProvider.getConfigByKey(ConfigKey.themeMode) ?? 0];
    _audltCoverBlur.value =
        StorageProvider.getConfigByKey(ConfigKey.adultCoverBlur) ?? false;
    var playerSettingJson =
        StorageProvider.getConfigByKey(ConfigKey.playerSetting);
    if (playerSettingJson != null) {
      _playerSetting = PlayerSetting.fromJson(playerSettingJson);
    }
  }

  Locale? localeListResolutionCallback(
      List<Locale>? locales, Iterable<Locale> supportedLocales) {
    String? cachedLocale = StorageProvider.getConfigByKey(ConfigKey.localeCode);
    if (cachedLocale != null) {
      return formatLocale(cachedLocale);
    }
    if (locales != null) {
      for (final locale in locales) {
        if (supportedLocales.contains(locale)) {
          StorageProvider.setConfig(ConfigKey.localeCode, locale.toString());
          _localeCode.value = locale.toString();
          return locale;
        }
      }
    }
    return const Locale("en");
  }
}
