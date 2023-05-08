import 'package:get/get.dart';

import 'widgets/favorite_media_preview_list/controller.dart';

class FavoritesController extends GetxController {
  Map<String, FavoriteMediaPreviewListController> childrenControllers = {};
  late List<String> childrenControllerTags;

  @override
  void onInit() {
    super.onInit();

    childrenControllerTags =
        List.generate(2, (index) => "favorite_list_$index");

    for (String tag in childrenControllerTags) {
      Get.lazyPut(() => FavoriteMediaPreviewListController(), tag: tag);
    }
  }
}
