import 'package:get/get.dart';

import '../../../data/providers/storage_provider.dart';
import 'widgets/downloads_media_preview_list/controller.dart';

class DownloadsController extends GetxController {
  Map<String, DownloadsMediaPreviewListController> childrenControllers = {};
  late List<String> childrenControllerTags;
  @override
  void onInit() {
    super.onInit();

    childrenControllerTags =
        List.generate(2, (index) => "downloads_list_$index");

    for (String tag in childrenControllerTags) {
      Get.lazyPut(() => DownloadsMediaPreviewListController(), tag: tag);
    }
  }

  Future<void> refreshHistoryList() async {
    for (String tag in childrenControllerTags) {
      await childrenControllers[tag]?.refreshData(showSplash: true);
    }
  }

  Future<void> cleanDownloadVideoRecords() async {
    await StorageProvider.cleanDownloadVideoRecords();
    await refreshHistoryList();
  }
}
