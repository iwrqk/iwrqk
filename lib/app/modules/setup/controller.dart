import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../core/utils/display_util.dart';
import '../../data/services/config_service.dart';

class SetupController extends GetxController {
  PageController pageController = PageController();
  ConfigService configService = Get.find();

  void setLanguage(String localeCode) {
    configService.localeCode = localeCode;
    configService.languageSetted = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DisplayUtil.reset(Get.context!);
    });
  }
}
