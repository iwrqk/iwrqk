import 'package:get/get.dart';

import 'controller.dart';

class DownloadsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DownloadsController>(() => DownloadsController());
  }
}
