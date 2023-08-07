import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../routes/pages.dart';

class AndroidService extends GetxService {
  static const String backChannel = "android/on_back";
  final platform = const MethodChannel(backChannel);

  AndroidService() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "onBack") {
        if (Get.currentRoute == AppRoutes.home ||
            Get.currentRoute == AppRoutes.root) {
          await platform.invokeMethod("backHome");
        } else {
          Get.back();
        }
      }
    });
  }
}
