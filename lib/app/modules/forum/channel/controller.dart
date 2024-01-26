import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChannelController extends GetxController
    with GetTickerProviderStateMixin {
  late String channelDisplayName;
  late String channelName;

  final RxBool _showToTopButton = false.obs;
  bool get showToTopButton => _showToTopButton.value;

  bool _isFabVisible = true;
  final ScrollController scrollController = ScrollController();
  late AnimationController fabAnimationController;

  @override
  void onInit() {
    super.onInit();

    channelDisplayName = Get.arguments['channelDisplayName'];
    channelName = Get.arguments['channelName'];

    fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fabAnimationController.forward();

    scrollController.addListener(() {
      final ScrollDirection direction =
          scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.forward) {
        if (!_isFabVisible) {
          _isFabVisible = true;
          fabAnimationController.forward();
        }
      } else if (direction == ScrollDirection.reverse) {
        if (_isFabVisible) {
          _isFabVisible = false;
          fabAnimationController.reverse();
        }
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
