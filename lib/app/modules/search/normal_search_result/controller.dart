import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../global_widgets/user_preview/users_preview_list/controller.dart';
import '../search_result_media_preview_list/controller.dart';

class NormalSearchResultController extends GetxController
    with GetTickerProviderStateMixin {
  Map<String, SearchResultMediaPreviewListController> childrenControllers = {};
  late UsersPreviewListController childUsersController;
  late String keyword;

  late TabController tabController;

  final RxBool _showToTopButton = false.obs;
  bool get showToTopButton => _showToTopButton.value;
  set showToTopButton(bool value) => _showToTopButton.value = value;

  TextEditingController searchEditingController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  final RxBool _showSearchSuffix = true.obs;

  bool get showSearchSuffix => _showSearchSuffix.value;

  set showSearchSuffix(bool value) {
    _showSearchSuffix.value = value;
  }

  final List<String> childrenMediaControllerTags = [
    "search_result_videos",
    "search_result_images",
  ];

  final String childUsersControllerTag = "search_result_users";

  @override
  void onInit() {
    super.onInit();

    keyword = Get.arguments;

    searchEditingController.text = keyword;

    tabController = TabController(length: 3, vsync: this);

    for (String tag in childrenMediaControllerTags) {
      Get.lazyPut(() => SearchResultMediaPreviewListController(), tag: tag);
    }

    Get.lazyPut(() => UsersPreviewListController(),
        tag: childUsersControllerTag);

    childUsersController =
        Get.find<UsersPreviewListController>(tag: childUsersControllerTag);
  }

  void jumpToTop() {
    switch (tabController.index) {
      case 0:
        childrenControllers['search_result_videos']?.jumpToTop();
        break;
      case 1:
        childrenControllers['search_result_images']?.jumpToTop();
        break;
      case 2:
        childUsersController.jumpToTop();
        break;
    }
  }

  void resetKeyword() {
    for (String tag in childrenMediaControllerTags) {
      childrenControllers[tag]?.resetKeyword(keyword);
    }
    if (childUsersController.initialized) {
      childUsersController.resetKeyword(keyword);
    }

    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onSearchTextChanged(String text) {
    _showSearchSuffix.value = text.isNotEmpty;
  }

  void clearSearchText() {
    searchEditingController.clear();
    _showSearchSuffix.value = false;
  }
}
