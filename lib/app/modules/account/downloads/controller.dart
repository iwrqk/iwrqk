import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/storage_provider.dart';
import 'widgets/downloads_media_preview_list/controller.dart';

class DownloadsController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Map<String, DownloadsMediaPreviewListController> childrenControllers = {};
  late List<String> childrenControllerTags;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 2, vsync: this);

    childrenControllerTags =
        List.generate(2, (index) => "downloads_list_$index");

    for (String tag in childrenControllerTags) {
      Get.lazyPut(() => DownloadsMediaPreviewListController(), tag: tag);
    }
  }

  Future<void> refreshDownloadsList() async {
    for (String tag in childrenControllerTags) {
      await childrenControllers[tag]?.refreshData(showSplash: true);
    }
  }

  Future<void> cleanDownloadVideoRecords() async {
    await StorageProvider.downloadVideoRecords.clean();
    await refreshDownloadsList();
  }
}
