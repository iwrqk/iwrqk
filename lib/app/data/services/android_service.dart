import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../global_widgets/media/iwr_player/controller.dart';
import '../../routes/pages.dart';

class AndroidService extends GetxService {
  static const String backChannel = "android/on_back";
  final platform = const MethodChannel(backChannel);

  IwrPlayerController? currentPlayer;

  void unsetPlayer() {
    currentPlayer = null;
  }

  AndroidService() {
    platform.setMethodCallHandler((call) async {
      if (call.method == "onBack") {
        if (Get.currentRoute == AppRoutes.home ||
            Get.currentRoute == AppRoutes.root) {
          await platform.invokeMethod("backHome");
        } else if (Get.currentRoute.isEmpty) {
          processExitFullScreen();
        } else {
          Get.back();
        }
      }
    });
  }

  void processExitFullScreen() {
    if (currentPlayer == null) {
      Get.back();
    } else {
      currentPlayer?.toggleFullScreen();
    }
  }
}
