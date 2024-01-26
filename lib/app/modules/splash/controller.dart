import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../data/services/user_service.dart';
import '../../routes/pages.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  final UserService _userService = Get.find();

  void init(BuildContext context) {
    _runInitTask();
  }

  Future<void> _runInitTask() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (await _userService.accountService.canLoginFromCache()) {
        bool success =
            await _userService.accountService.loginFromCache().then((value) {
          if (value.success) {
            return true;
          } else {
            SmartDialog.showToast(t.account.require_login);
            return false;
          }
        });

        if (success) {
          success = await _userService.init();
        }

        if (!success) {
          _userService.accountService.logout();
          Get.offNamed(AppRoutes.home);
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Get.toNamed(AppRoutes.login);
          });
          return;
        }
      }

      Get.offNamed(AppRoutes.home);
      return;
    });
  }
}
