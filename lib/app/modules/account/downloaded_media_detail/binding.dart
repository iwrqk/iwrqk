import 'package:get/get.dart';

import 'controller.dart';

class DownloadedMediaDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DownloadedMediaDetailController>(
      () => DownloadedMediaDetailController(),
    );
  }
}
