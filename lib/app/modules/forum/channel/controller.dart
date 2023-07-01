import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChannelController extends GetxController {
  final ScrollController scrollController = ScrollController();

  late String channelDisplayName;
  late String channelName;

  final RxBool _showToTopButton = false.obs;
  bool get showToTopButton => _showToTopButton.value;

  @override
  void onInit() {
    super.onInit();

    channelDisplayName = Get.arguments['channelDisplayName'];
    channelName = Get.arguments['channelName'];

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
