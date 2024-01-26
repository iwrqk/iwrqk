import 'package:get/get.dart';

import 'widgets/playlists_preview_list/controller.dart';

class PlaylistsPreviewController extends GetxController {
  late String userId;
  late bool requireMyself;

  late String tag;
  late PlaylistsPreviewListController _targetController;

  @override
  void onInit() {
    super.onInit();

    dynamic arguments = Get.arguments;

    userId = arguments["userId"];
    requireMyself = arguments["requireMyself"] ?? false;

    tag = "playlists_$userId";

    Get.lazyPut(
      () => PlaylistsPreviewListController(),
      tag: tag,
    );

    _targetController = Get.find<PlaylistsPreviewListController>(
      tag: tag,
    );
  }

  Future<void> refreshData() {
    return _targetController.refreshData(showSplash: true);
  }
}
