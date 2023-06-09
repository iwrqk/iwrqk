import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ThreadController extends GetxController {
  final ScrollController scrollController = ScrollController();

  late String title;
  late String starterUserName;
  late String channelName;
  late String threadId;
  late bool locked;

  final RxBool _showToTopButton = false.obs;
  bool get showToTopButton => _showToTopButton.value;

  @override
  void onInit() {
    super.onInit();

    dynamic arguments = Get.arguments;

    title = arguments['title'];
    starterUserName = arguments['starterUserName'];
    channelName = arguments['channelName'];
    threadId = arguments['threadId'];
    locked = arguments['locked'];

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
