import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ThreadController extends GetxController with GetTickerProviderStateMixin {
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

  bool _isFabVisible = true;
  final ScrollController scrollController = ScrollController();
  late AnimationController fabAnimationController;

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
