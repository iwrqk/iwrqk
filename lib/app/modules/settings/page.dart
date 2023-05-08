import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../l10n.dart';
import '../../core/utils/display_util.dart';
import '../../routes/pages.dart';
import 'controller.dart';

class SettingsPage extends GetView<SettingsController> {
  final SettingsController _controller = Get.find();

  Widget _buildLanguageSetting(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            L10n.of(context).language,
            style: TextStyle(fontSize: 17.5),
          ),
        ),
        PopupMenuButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).cardColor),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Obx(
                    () => Text(
                      _controller.getCurrentLanguageName(),
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 15,
                    color: Colors.grey,
                  )
                ],
              )),
          itemBuilder: (context) {
            return L10n.languageMap.keys
                .map((e) => PopupMenuItem(
                      child: Text(
                        L10n.languageMap[e]!,
                        style: TextStyle(color: Colors.grey),
                      ),
                      value: e,
                    ))
                .toList();
          },
          onSelected: (value) {
            _controller.configService.localeCode = value;
          },
        )
      ],
    );
  }

  Widget _buildThemeSetting(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            L10n.of(context).theme,
            style: TextStyle(fontSize: 17.5),
          ),
        ),
        PopupMenuButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).cardColor),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Obx(
                    () => Text(
                      _controller.getCurrentThemeName(context),
                      style: TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FaIcon(
                    FontAwesomeIcons.chevronDown,
                    size: 15,
                    color: Colors.grey,
                  )
                ],
              )),
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                child: Text(
                  L10n.of(context).theme_system,
                  style: TextStyle(color: Colors.grey),
                ),
                value: ThemeMode.system,
              ),
              PopupMenuItem(
                child: Text(
                  L10n.of(context).theme_light_mode,
                  style: TextStyle(color: Colors.grey),
                ),
                value: ThemeMode.light,
              ),
              PopupMenuItem(
                child: Text(
                  L10n.of(context).theme_dark_mode,
                  style: TextStyle(color: Colors.grey),
                ),
                value: ThemeMode.dark,
              ),
            ];
          },
          onSelected: (value) {
            _controller.configService.themeMode = value;
          },
        )
      ],
    );
  }

  Widget _buildEnableAdultCoverBlur(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            L10n.of(context).setting_cover_blur,
            style: TextStyle(fontSize: 17.5),
          ),
        ),
        Obx(
          () => Container(
            height: 20,
            margin: EdgeInsets.only(left: 10),
            child: CupertinoSwitch(
              value: _controller.configService.adultCoverBlur,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                _controller.configService.adultCoverBlur = value;
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEnableBiometric(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            L10n.of(context).unlock_by_biometric,
            style: TextStyle(fontSize: 17.5),
          ),
        ),
        Obx(
          () => Container(
            height: 20,
            margin: EdgeInsets.only(left: 10),
            child: CupertinoSwitch(
              value: _controller.autoLockService.enableAuthByBiometrics,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                if (value) {
                  controller.getBiometricsAuth().then((value) {
                    _controller.autoLockService.enableAuthByBiometrics = value;
                  });
                } else {
                  _controller.autoLockService.enableAuthByBiometrics = value;
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildEnableAutoLock(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            L10n.of(context).setting_auto_lock,
            style: TextStyle(fontSize: 17.5),
          ),
        ),
        Obx(
          () => Container(
            height: 20,
            margin: EdgeInsets.only(left: 10),
            child: CupertinoSwitch(
              value: _controller.autoLockService.enableAutoLock,
              activeColor: Theme.of(context).primaryColor,
              onChanged: (value) {
                if (value) {
                  Get.toNamed(AppRoutes.setPassword)?.then((value) {
                    if (value is bool) {
                      _controller.autoLockService.enableAutoLock = value;
                    }
                  });
                } else {
                  _controller.autoLockService.enableAutoLock = value;
                }
              },
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return InkWell(
      onTap: _controller.logout,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              L10n.of(context).logout,
              style: TextStyle(fontSize: 17.5),
            ),
          ),
          FaIcon(FontAwesomeIcons.rightToBracket, color: Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DisplayUtil.reset(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: FaIcon(FontAwesomeIcons.chevronLeft),
        ),
        centerTitle: true,
        title: Text(
          L10n.of(context).user_settings,
        ),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          SettingTitle(title: L10n.of(context).setting_appearance),
          SettingGroup(
            children: [
              _buildThemeSetting(context),
              _buildLanguageSetting(context),
              _buildEnableAdultCoverBlur(context),
            ],
          ),
          SettingTitle(title: L10n.of(context).setting_security),
          Obx(
            () => SettingGroup(
              children: [
                _buildEnableAutoLock(context),
                if (controller.autoLockService.enableAutoLock)
                  _buildEnableBiometric(context),
              ],
            ),
          ),
          if (controller.accountService.isLogin)
            SettingGroup(
              children: [
                _buildLogoutButton(context),
              ],
            ),
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
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17.5,
        ),
      ),
    );
  }
}

class SettingGroup extends StatelessWidget {
  final List<Widget> children;

  const SettingGroup({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).canvasColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 2.5),
              child: children[index],
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 1,
              color: Theme.of(context).cardColor,
            );
          },
          itemCount: children.length,
        ));
  }
}
