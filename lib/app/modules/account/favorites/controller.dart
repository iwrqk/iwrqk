import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/media/media.dart';
import '../../../data/models/media/video.dart';
import 'widgets/favorite_media_preview_list/controller.dart';

class FavoritesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Map<String, FavoriteMediaPreviewListController> childrenControllers = {};
  late List<String> childrenControllerTags;

  final RxBool _enableMultipleSelection = false.obs;
  bool get enableMultipleSelection => _enableMultipleSelection.value;
  set enableMultipleSelection(bool value) =>
      _enableMultipleSelection.value = value;

  List<String> checkedVideoList = [];
  List<String> checkedImageList = [];

  final RxInt _checkedCount = 0.obs;
  int get checkedCount => _checkedCount.value;
  set checkedCount(int value) => _checkedCount.value = value;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 2, vsync: this);

    childrenControllerTags =
        List.generate(2, (index) => "favorite_list_$index");

    for (String tag in childrenControllerTags) {
      Get.lazyPut(() => FavoriteMediaPreviewListController(), tag: tag);
    }
  }

  void toggleChecked(MediaModel media, [bool all = false]) {
    if (media is VideoModel) {
      toggleVideoChecked(media.id, all);
    } else {
      toggleImageChecked(media.id, all);
    }
  }

  bool contains(MediaModel media) {
    if (media is VideoModel) {
      return checkedVideoList.contains(media.id);
    } else {
      return checkedImageList.contains(media.id);
    }
  }

  void toggleVideoChecked(String id, [bool all = false]) {
    if (checkedVideoList.contains(id)) {
      checkedVideoList.remove(id);
      checkedCount--;
    } else {
      checkedVideoList.add(id);
      checkedCount++;
    }
    update();
  }

  void toggleImageChecked(String id, [bool all = false]) {
    if (checkedImageList.contains(id)) {
      checkedImageList.remove(id);
      checkedCount--;
    } else {
      checkedImageList.add(id);
      checkedCount++;
    }
    update();
  }

  void toggleCheckedAll() {
    childrenControllers[childrenControllerTags[tabController.index]]
        ?.toggleCheckedAll();
    update();
  }

  void deleteChecked() async {
    // for (String id in checkedList) {
    //   await StorageProvider.historyList
    //       .deleteWhere((element) => element.id == id);
    // }
    // checkedList.clear();
    // checkedCount = 0;
    // await refreshHistoryList();
  }
}
