import 'package:get/get.dart';

import 'controller.dart';

class PlayListDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<PlaylistDetailController>(() => PlaylistDetailController());
  }
}
