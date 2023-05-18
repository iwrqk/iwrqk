import 'package:get/get.dart';

import 'widgets/playlist_detail_media_preview_list/controller.dart';

class PlayListDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlatlistDetailMediaPreviewListController>(
        () => PlatlistDetailMediaPreviewListController());
  }
}
