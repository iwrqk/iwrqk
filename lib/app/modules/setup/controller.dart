import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/intl_localizations.dart';

import '../../../l10n.dart';
import '../../core/utils/display_util.dart';
import '../../data/services/config_service.dart';

class SetupController extends GetxController {
  PageController pageController = PageController();
  ConfigService configService = Get.find();

  late AppLocalizations l10n;

  @override
  void onInit() {
    super.onInit();
    l10n = L10n.of(Get.context!);
  }

  void setLanguage(String localeCode) {
    configService.languageSetted = true;
    configService.localeCode = localeCode;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      DisplayUtil.reset(Get.context!);
      l10n = DisplayUtil.l10n;
    });
  }
}
