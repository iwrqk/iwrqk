import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ThreadController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final RxBool _showToTopButton = false.obs;

  bool get showToTopButton => _showToTopButton.value;

  late String title;
  late String starterUserName;
  late String channelName;
  late String threadId;

  @override
  void onInit() {
    super.onInit();

    dynamic arguments = Get.arguments;

    title = arguments['title'];
    starterUserName = arguments['starterUserName'];
    channelName = arguments['channelName'];
    threadId = arguments['threadId'];

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        _showToTopButton.value = true;
      } else {
        _showToTopButton.value = false;
      }
    });
  }
}
