import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/media_preview/media_preview_grid/controller.dart';
import '../../components/user_preview/users_preview_list/controller.dart';

class SearchResultController extends GetxController
    with GetTickerProviderStateMixin {
  late UsersPreviewListController childUsersController;

  late String keyword;

  late TabController tabController;

  final RxBool _showToTopButton = false.obs;
  bool get showToTopButton => _showToTopButton.value;
  set showToTopButton(bool value) => _showToTopButton.value = value;

  final List<String> childrenMediaControllerTags = [
    "search_result_videos",
    "search_result_images",
  ];

  List<String> get tabTagList => [
        "_latest",
        "_trending",
        "_popularity",
        "_most_views",
        "_most_likes",
      ];

  final String childUsersControllerTag = "search_result_users";

  @override
  void onInit() {
    super.onInit();

    keyword = Get.arguments;

    tabController = TabController(length: 3, vsync: this);

    for (String tag in childrenMediaControllerTags) {
      for (String tabTag in tabTagList) {
        Get.lazyPut(() => MediaPreviewGridController(), tag: tag + tabTag);
      }
    }

    Get.lazyPut(() => UsersPreviewListController(),
        tag: childUsersControllerTag);

    childUsersController =
        Get.find<UsersPreviewListController>(tag: childUsersControllerTag);
  }
}
