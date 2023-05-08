import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/media_preview/media_preview_grid/controller.dart';
import 'widgets/filter_dialog/widget.dart';

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

  void popFilterDialog() {
    Get.dialog(FilterDialog(
      targetTag: _tabTagList[tabController.index],
    ));
  }

  void scrollToTop() {
    ScrollController controller = scrollControllers[tabController.index];
    if (controller.hasClients) {
      controller.animateTo(0,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void scrollToTopRefresh() {
    ScrollController controller = scrollControllers[tabController.index];
    if (controller.hasClients) {
      controller.animateTo(-100,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }
}
