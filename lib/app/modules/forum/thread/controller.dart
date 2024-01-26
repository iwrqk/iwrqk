import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ThreadController extends GetxController {
  final ScrollController scrollController = ScrollController();

  late String title;
  late String starterUserName;
  late String starteName;
  late String timestamp;
  late String starterAvatarUrl;
  late String channelName;
  late String threadId;
  late bool locked;

  final RxBool _showTitle = false.obs;
  bool get showTitle => _showTitle.value;
  set showTitle(bool value) => _showTitle.value = value;

  @override
  void onInit() {
    super.onInit();

    dynamic arguments = Get.arguments;

    title = arguments['title'];
    starterUserName = arguments['starterUserName'];
    starteName = arguments['starterName'];
    timestamp = arguments['timestamp'];
    starterAvatarUrl = arguments['starterAvatarUrl'];
    channelName = arguments['channelName'];
    threadId = arguments['threadId'];
    locked = arguments['locked'];

    scrollController.addListener(() {
      if (scrollController.position.pixels >= 55) {
        _showTitle.value = true;
      } else {
        _showTitle.value = false;
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
