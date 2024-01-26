import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/storage_provider.dart';
import 'widgets/history_media_preview_list/controller.dart';

class HistoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  Map<String, HistoryMediaPreviewListController> childrenControllers = {};
  late List<String> childrenControllerTags;

  final RxBool _enableMultipleSelection = false.obs;
  bool get enableMultipleSelection => _enableMultipleSelection.value;
  set enableMultipleSelection(bool value) =>
      _enableMultipleSelection.value = value;

  List checkedList = [];

  final RxInt _checkedCount = 0.obs;
  int get checkedCount => _checkedCount.value;
  set checkedCount(int value) => _checkedCount.value = value;

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 3, vsync: this);

    childrenControllerTags = List.generate(3, (index) => "history_list_$index");

    for (String tag in childrenControllerTags) {
      Get.lazyPut(() => HistoryMediaPreviewListController(), tag: tag);
    }
  }

  void toggleChecked(String id, [bool all = false]) {
    if (checkedList.contains(id)) {
      checkedList.remove(id);
      checkedCount--;
    } else {
      checkedList.add(id);
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
    for (String id in checkedList) {
      await StorageProvider.historyList
          .deleteWhere((element) => element.id == id);
    }
    checkedList.clear();
    checkedCount = 0;
    await refreshHistoryList();
  }

  Future<void> refreshHistoryList() async {
    for (String tag in childrenControllerTags) {
      await childrenControllers[tag]?.refreshData(showSplash: true);
    }
  }

  Future<void> cleanHistoryList() async {
    await StorageProvider.historyList.clean();
    await refreshHistoryList();
  }
}
