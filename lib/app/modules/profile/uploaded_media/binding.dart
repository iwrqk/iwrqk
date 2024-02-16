import 'package:get/get.dart';

import 'controller.dart';

class UploadedMediaBinding extends Bindings {
  @override
  void dependencies() {
    Get.create<UploadedMediaController>(() => UploadedMediaController());
  }
}
