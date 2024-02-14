import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/media_preview/media_preview_grid/controller.dart';

class MediaGridTabController extends GetxController
    with GetTickerProviderStateMixin {
  late TabController tabController;
  late List<ScrollController> scrollControllers;

  late List<String> _tabTagList;

  void init({required List<String> tagList}) {
    _tabTagList = tagList;
    tabController = TabController(length: tagList.length, vsync: this);
    scrollControllers =
        List.generate(tagList.length, (index) => ScrollController());
    for (String tag in _tabTagList) {
      Get.lazyPut(() => MediaPreviewGridController(), tag: tag);
    }
  }

  void scrollToTop() {
    ScrollController controller = scrollControllers[tabController.index];
    if (controller.hasClients) {
      controller.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void scrollToTopRefresh() {
    ScrollController controller = scrollControllers[tabController.index];
    if (controller.hasClients) {
      controller.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
    refreshCurrentTab();
  }

  void refreshCurrentTab() {
    MediaPreviewGridController targetController =
        Get.find<MediaPreviewGridController>(
            tag: _tabTagList[tabController.index]);

    targetController.resetScrollPosition();
    targetController.refreshData(showSplash: true);
  }
}
