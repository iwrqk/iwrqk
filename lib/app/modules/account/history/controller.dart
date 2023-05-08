import 'package:get/get.dart';

import '../../../data/providers/storage_provider.dart';
import 'widgets/history_media_preview_list/controller.dart';

class HistoryController extends GetxController {
  Map<String, HistoryMediaPreviewListController> childrenControllers = {};
  late List<String> childrenControllerTags;

  @override
  void onInit() {
    super.onInit();

    childrenControllerTags = List.generate(3, (index) => "history_list_$index");

    for (String tag in childrenControllerTags) {
      Get.lazyPut(() => HistoryMediaPreviewListController(), tag: tag);
    }
  }

  Future<void> refreshHistoryList() async {
    for (String tag in childrenControllerTags) {
      await childrenControllers[tag]?.refreshData(showSplash: true);
    }
  }

  Future<void> cleanHistoryList() async {
    await StorageProvider.cleanHistoryList();
    await refreshHistoryList();
  }
}
