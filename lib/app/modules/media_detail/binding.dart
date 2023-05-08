import 'package:get/get.dart';

import 'controller.dart';

class MediaDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<MediaDetailController>(() => MediaDetailController());
  }
}
