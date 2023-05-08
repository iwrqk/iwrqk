import 'package:get/get.dart';

import 'controller.dart';

class PlaylistsPreviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaylistsPreviewController>(() => PlaylistsPreviewController());
  }
}
