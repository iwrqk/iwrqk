import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:iwrqk/app/data/models/account/settings/player_setting.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/const/widget.dart';
import '../../global_widgets/dialogs/notify_update_dialog.dart';
import '../models/account/settings/filter_setting.dart';
import '../providers/config_provider.dart';
import '../providers/storage_provider.dart';

abstract class ConfigKey {
  static const String firstRun = "firstRun";

  static const String themeMode = "themeMode";
  static const String localeCode = "localeCode";

  static const String playerSetting = "playerSetting";

  static const String filterSetting = "filterSetting";

  static const String adultCoverBlur = "adultCoverBlur";
  static const String notificationPlayer = "notificationPlayer";
  static const String autoPlay = "autoPlay";
}

class ConfigService extends GetxService {
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  late bool firstRun;
  late bool languageSetted;

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

  final RxBool _notificationPlayer = false.obs;
  bool get notificationPlayer => _notificationPlayer.value;
  set notificationPlayer(bool value) {
    _notificationPlayer.value = value;
    StorageProvider.setConfig(ConfigKey.notificationPlayer, value);
  }

  final RxBool _autoPlay = true.obs;
  bool get autoPlay => _autoPlay.value;
  set autoPlay(bool value) {
    _autoPlay.value = value;
    StorageProvider.setConfig(ConfigKey.autoPlay, value);
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

  Locale? get locale {
    if (_localeCode.value.isEmpty) {
      return null;
    }
    return formatLocale(_localeCode.value);
  }

  Locale formatLocale(String locale) {
    if (locale.contains("_")) {
      final localeList = locale.split("_");
      return Locale(localeList[0], localeList[1]);
    }
    return Locale(locale);
  }

  final RxString _localeCode = "".obs;
  String get localeCode => _localeCode.value;
  set localeCode(String code) {
    _localeCode.value = code;
    StorageProvider.setConfig(ConfigKey.localeCode, code);
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

  void setFirstRun(bool value) {
    firstRun = value;
    StorageProvider.setConfig(ConfigKey.firstRun, value);
  }

  @override
  void onInit() {
    super.onInit();
    if (StorageProvider.getConfigByKey(ConfigKey.firstRun) == null) {
      firstRun = true;
      languageSetted = false;
    } else {
      languageSetted = true;
      firstRun = false;
    }
    if (!firstRun) {
      _localeCode.value =
          StorageProvider.getConfigByKey(ConfigKey.localeCode) ?? "en";
    }

    _themeMode.value = ThemeMode
        .values[StorageProvider.getConfigByKey(ConfigKey.themeMode) ?? 0];

    _audltCoverBlur.value =
        StorageProvider.getConfigByKey(ConfigKey.adultCoverBlur) ?? false;
    _notificationPlayer.value =
        StorageProvider.getConfigByKey(ConfigKey.notificationPlayer) ?? false;
    _autoPlay.value =
        StorageProvider.getConfigByKey(ConfigKey.autoPlay) ?? true;

    var playerSettingJson =
        StorageProvider.getConfigByKey(ConfigKey.playerSetting);
    if (playerSettingJson != null) {
      _playerSetting = PlayerSetting.fromJson(playerSettingJson);
    }
  }

  Future<void> checkLatestVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    await ConfigProvider.getConfig().then((value) async {
      if (value.success) {
        if (value.data!.latestVersion != currentVersion) {
          await Get.dialog(
            NotifyUpdateDialog(
              isForce: value.data!.forceUpdate,
            ),
            barrierDismissible: value.data!.forceUpdate,
          );
        }
      }
    });
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
          SchedulerBinding.instance.addPostFrameCallback((_) {
            _localeCode.value = locale.toString();
          });
          return locale;
        }
      }
    }
    return const Locale("en");
  }
}
