import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../core/utils/display_util.dart';
import '../../data/providers/translate_provider.dart';
import '../../data/services/auto_lock_service.dart';
import '../../data/services/config_service.dart';
import '../../data/services/user_service.dart';
import '../../routes/pages.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  final UserService _userService = Get.find();
  final ConfigService _configService = Get.find();
  final AutoLockService _autoLockService = Get.find();

  @override
  void onInit() {
    super.onInit();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    animation = Tween<double>(begin: 0, end: 2)
        .chain(
          CurveTween(curve: Curves.ease),
        )
        .animate(animationController);
  }

  void init(BuildContext context) {
    DisplayUtil.init(context);
    TranslateProvider.init();
    _configService.calculateGridChildAspectRatio(
      MediaQuery.of(context).size,
      MediaQuery.of(context).orientation,
    );
    if (_configService.firstRun) {
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        Get.offAndToNamed(AppRoutes.setup);
      });
    } else {
      _runInitTask();
    }
  }

  Future<void> _runInitTask() async {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (_autoLockService.enableAutoLock) {
        Get.offAndToNamed(AppRoutes.home);
        Get.toNamed(AppRoutes.lock);
        return;
      }

      if (await _userService.accountService.canLoginFromCache()) {
        bool success =
            await _userService.accountService.loginFromCache().then((value) {
          if (value.success) {
            return true;
          } else {
            showToast(DisplayUtil.messageNeedLogin);
            return false;
          }
        });

        if (success) {
          success = await _userService.init();
        }

        if (!success) {
          Get.offAndToNamed(AppRoutes.home);
          Get.toNamed(AppRoutes.login);
          return;
        }
      }

      Get.offAndToNamed(AppRoutes.home);
      return;
    });
  }

  @override
  void onClose() {
    animationController.dispose();
  }
}
