import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/enums/types.dart';
import '../../data/models/comment.dart';
import '../../data/services/user_service.dart';

class CommentDetailController extends GetxController {
  final UserService userService = Get.find();

  final ScrollController scrollController = ScrollController();
  final RxBool _showToTopButton = false.obs;

  bool get showToTopButton => _showToTopButton.value;

  late String uploaderUserName;
  late CommentModel parentComment;
  late String sourceId;
  late CommentsSourceType sourceType;

  @override
  void onInit() {
    super.onInit();

    dynamic arguments = Get.arguments;

    uploaderUserName = arguments['uploaderUserName'];
    parentComment = arguments['parentComment'];
    sourceId = arguments['sourceId'];
    sourceType = arguments['sourceType'];

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          MediaQuery.of(Get.context!).size.height / 2) {
        _showToTopButton.value = true;
      } else {
        _showToTopButton.value = false;
      }
    });
  }

  void jumpToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }
}
