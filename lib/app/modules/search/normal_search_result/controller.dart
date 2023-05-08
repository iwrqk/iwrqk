import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../global_widgets/user_preview/users_preview_list/controller.dart';
import '../search_result_media_preview_list/controller.dart';

class NormalSearchResultController extends GetxController {
  Map<String, SearchResultMediaPreviewListController> childrenControllers = {};
  late UsersPreviewListController childUsersController;
  late String keyword;

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

    for (String tag in childrenMediaControllerTags) {
      Get.lazyPut(() => SearchResultMediaPreviewListController(), tag: tag);
    }

    Get.lazyPut(() => UsersPreviewListController(),
        tag: childUsersControllerTag);

    childUsersController =
        Get.find<UsersPreviewListController>(tag: childUsersControllerTag);
  }

  void resetKeyword() {
    for (String tag in childrenMediaControllerTags) {
      childrenControllers[tag]?.resetKeyword(keyword);
    }
    if (childUsersController.initialized) {
      childUsersController.resetKeyword(keyword);
    }
  }

  void onSearchTextChanged(String text) {
    _showSearchSuffix.value = text.isNotEmpty;
  }

  void clearSearchText() {
    searchEditingController.clear();
    _showSearchSuffix.value = false;
  }
}
