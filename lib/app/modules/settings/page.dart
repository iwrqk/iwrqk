import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'controller.dart';
import 'widgets/custom_color_page.dart';
import 'widgets/display_mode_dialog.dart';
import 'widgets/proxy_dialog.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  Widget _buildMultiSetting<T>(
    BuildContext context, {
    required String title,
    required String description,
    required IconData iconData,
    required T currentOption,
    required Map<T, String> options,
    required void Function(T) onSelected,
  }) {
    Rx<T> selected = currentOption.obs;

    return _buildButton(
      context,
      title: title,
      description: description,
      iconData: iconData,
      onPressed: () {
        Get.dialog(
          AlertDialog(
            title: Text(title),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            content: Container(
              width: Get.width * 0.8,
              constraints: const BoxConstraints(maxHeight: 400),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              child: ListView(
                shrinkWrap: true,
                children: options.entries
                    .map(
                      (entry) => Obx(
                        () => RadioListTile<T>(
                          value: entry.key,
                          title: Text(entry.value),
                          groupValue: selected.value,
                          onChanged: (T? value) {
                            if (value != null) {
                              selected.value = value;
                            }
                          },
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  t.notifications.cancel,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  onSelected(selected.value);
                  Get.back();
                },
                child: Text(t.notifications.confirm),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSwitchSetting(
    BuildContext context, {
    required String title,
    required String description,
    required IconData iconData,
    required bool value,
    required void Function(bool) onChanged,
    bool restartRequired = false,
  }) {
    void onSwitch(bool value) {
      onChanged(value);
      if (restartRequired) {
        SmartDialog.showToast(t.message.restart_required);
      }
      HapticFeedback.mediumImpact();
    }

    return ListTile(
      enableFeedback: true,
      onTap: () {
        onSwitch(!value);
      },
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        description,
        style: Theme.of(context)
            .textTheme
            .titleSmall
            ?.copyWith(color: Theme.of(context).colorScheme.outline),
      ),
      leading: Icon(
        iconData,
        size: 28,
      ),
      trailing: Switch(
        value: value,
        onChanged: onSwitch,
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String title,
    required String description,
    required IconData iconData,
    required void Function() onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          description,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Theme.of(context).colorScheme.outline),
        ),
        leading: Icon(
          iconData,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildThemeSetting(BuildContext context) {
    return _buildMultiSetting<ThemeMode>(
      context,
      title: t.settings.theme,
      description: t.settings.theme_desc,
      iconData: Icons.wb_sunny,
      currentOption: controller.getCurrentTheme(),
      options: {
        ThemeMode.system: t.theme.system,
        ThemeMode.light: t.theme.light,
        ThemeMode.dark: t.theme.dark,
      },
      onSelected: (value) {
        controller.setThemeMode(value);
      },
    );
  }

  Widget _buildDynamicColorSetting(BuildContext context) {
    return Obx(
      () => _buildSwitchSetting(
        context,
        title: t.settings.dynamic_color,
        description: t.settings.dynamic_color_desc,
        iconData: Icons.palette,
        value: controller.configService.enableDynamicColor,
        onChanged: (value) {
          controller.configService.enableDynamicColor = value;
        },
      ),
    );
  }

  Widget _buildCustomColorButton(BuildContext context) {
    return _buildButton(
      context,
      title: t.settings.custom_color,
      description: t.settings.custom_color_desc,
      iconData: Icons.colorize,
      onPressed: () {
        Get.to(() => const CustomColorPage());
      },
    );
  }

  Widget _buildWorkModeSetting(BuildContext context) {
    return Obx(
      () => _buildSwitchSetting(
        context,
        title: t.settings.work_mode,
        description: t.settings.work_mode_desc,
        iconData: Icons.work,
        value: controller.workMode,
        onChanged: (value) {
          controller.workMode = value;
        },
      ),
    );
  }

  Widget _buildAutoPlaySetting(BuildContext context) {
    return Obx(
      () => _buildSwitchSetting(
        context,
        title: t.settings.autoplay,
        description: t.settings.autoplay_desc,
        iconData: Icons.play_circle,
        value: controller.autoPlay,
        onChanged: (value) {
          controller.autoPlay = value;
        },
      ),
    );
  }

  Widget _buildBackgroundPlaySetting(BuildContext context) {
    return Obx(
      () => _buildSwitchSetting(
        context,
        title: t.settings.background_play,
        description: t.settings.background_play_desc,
        iconData: Icons.music_video,
        value: controller.backgroundPlay,
        onChanged: (value) {
          controller.backgroundPlay = value;
        },
      ),
    );
  }

  Widget _buildDownloadPathSetting(BuildContext context) {
    return Obx(
      () => _buildButton(
        context,
        title: t.settings.download_path,
        description: controller.downloadPath,
        iconData: Icons.download,
        onPressed: controller.changeDownloadPath,
      ),
    );
  }

  Widget _buildLoggingSetting(BuildContext context) {
    return Obx(
      () => _buildSwitchSetting(
        context,
        title: t.settings.enable_logging,
        description: t.settings.enable_logging_desc,
        iconData: Icons.assignment_late,
        value: controller.enableLogging,
        restartRequired: true,
        onChanged: (value) {
          controller.enableLogging = value;
        },
      ),
    );
  }

  Widget __buildClearLogsButton(BuildContext context) {
    return Obx(
      () => _buildButton(
        context,
        title: t.settings.clear_log,
        description: t.settings.clear_log_desc(size: controller.logSize),
        iconData: Icons.delete,
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: Text(t.settings.clear_log),
              content: Text(t.message.are_you_sure_to_do_that),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    t.notifications.cancel,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    controller.clearLogs();
                    Get.back();
                  },
                  child: Text(t.notifications.confirm),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerboseLoggingSetting(BuildContext context) {
    return Obx(
      () => _buildSwitchSetting(
        context,
        title: t.settings.enable_verbose_logging,
        description: t.settings.enable_verbose_logging_desc,
        iconData: Icons.description,
        value: controller.enableVerboseLogging,
        restartRequired: true,
        onChanged: (value) {
          controller.enableVerboseLogging = value;
        },
      ),
    );
  }

  Widget _buildMediaScanSetting(BuildContext context) {
    return Obx(
      () => _buildSwitchSetting(
        context,
        title: t.settings.allow_media_scan,
        description: t.settings.allow_media_scan_desc,
        iconData: Icons.folder_open,
        value: controller.allowMediaScan,
        onChanged: (value) {
          controller.allowMediaScan = value;
          controller.downloadService.allowMediaScan(value);
        },
      ),
    );
  }

  Widget _buildLanguageSetting(BuildContext context) {
    return _buildMultiSetting<String>(
      context,
      title: t.settings.language,
      description: t.settings.language_desc,
      iconData: Icons.translate,
      currentOption: controller.getCurrentLocalecode(),
      options: t.locales,
      onSelected: (value) {
        controller.setLanguage(value);
      },
    );
  }

  Widget _buildLicenseButton(BuildContext context) {
    return _buildButton(
      context,
      title: t.settings.thrid_party_license,
      description: t.settings.thrid_party_license_desc,
      iconData: Icons.info,
      onPressed: () async {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String currentVersion = packageInfo.version;

        showLicensePage(
          context: Get.context!,
          applicationName: "IwrQk",
          applicationVersion: currentVersion,
          applicationLegalese: "Iwara Quick!",
        );
      },
    );
  }

  Widget _buildDisplayModeButton(BuildContext context) {
    return _buildButton(
      context,
      title: t.settings.display_mode,
      description: t.settings.display_mode_desc,
      iconData: Icons.tv,
      onPressed: () {
        Get.dialog(const DisplayModeDialog());
      },
    );
  }

  Widget _buildEnableProxySetting(BuildContext context) {
    return Obx(
      () => _buildSwitchSetting(
        context,
        title: t.settings.enable_proxy,
        description: t.settings.enable_proxy_desc,
        iconData: Icons.wifi,
        value: controller.enableProxy,
        restartRequired: true,
        onChanged: (value) {
          controller.enableProxy = value;
        },
      ),
    );
  }

  Widget _buildSetProxyButton(BuildContext context) {
    return _buildButton(
      context,
      title: t.settings.proxy,
      description: t.settings.proxy_desc,
      iconData: Icons.dns,
      onPressed: () {
        Get.dialog(ProxyDialog());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.user.settings,
        ),
      ),
      body: ListView(
        children: [
          SettingTitle(title: t.settings.appearance),
          _buildThemeSetting(context),
          _buildDynamicColorSetting(context),
          Obx(
            () => Visibility(
              visible: !controller.configService.enableDynamicColor,
              child: _buildCustomColorButton(context),
            ),
          ),
          _buildLanguageSetting(context),
          if (GetPlatform.isAndroid) _buildDisplayModeButton(context),
          _buildWorkModeSetting(context),
          SettingTitle(title: t.settings.network),
          _buildEnableProxySetting(context),
          _buildSetProxyButton(context),
          SettingTitle(title: t.settings.player),
          _buildAutoPlaySetting(context),
          _buildBackgroundPlaySetting(context),
          if (!GetPlatform.isIOS) SettingTitle(title: t.settings.download),
          if (!GetPlatform.isIOS) _buildDownloadPathSetting(context),
          if (GetPlatform.isAndroid) _buildMediaScanSetting(context),
          SettingTitle(title: t.settings.logging),
          _buildLoggingSetting(context),
          __buildClearLogsButton(context),
          _buildVerboseLoggingSetting(context),
          SettingTitle(title: t.settings.about),
          _buildLicenseButton(context),
        ],
      ),
    );
  }
}

class SettingTitle extends StatelessWidget {
  final String title;

  const SettingTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
