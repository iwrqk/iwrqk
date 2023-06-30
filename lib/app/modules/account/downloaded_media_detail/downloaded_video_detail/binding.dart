import 'package:get/get.dart';

import 'controller.dart';

class DownloadedVideoDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DownloadedVideoDetailController>(
      () => DownloadedVideoDetailController(),
    );
  }
}
