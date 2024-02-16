import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../data/models/forum/thread.dart';
import '../../../data/providers/api_provider.dart';

class ThreadController extends GetxController
    with GetTickerProviderStateMixin, StateMixin {
  late ThreadModel thread;
  String? threadId;
  bool fromExternal = false;
  late String channelName;

  final RxBool _showTitle = false.obs;
  bool get showTitle => _showTitle.value;
  set showTitle(bool value) => _showTitle.value = value;

  bool _isFabVisible = true;
  final ScrollController scrollController = ScrollController();
  late AnimationController fabAnimationController;

  @override
  void onInit() {
    super.onInit();

    threadId = Get.parameters['threadId'];
    channelName = Get.parameters['channelName']!;
    if (Get.arguments != null) {
      thread = Get.arguments['threadModel'];
    } else {
      fromExternal = true;
      loadData();
    }

    fabAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fabAnimationController.forward();

    scrollController.addListener(() {
      final ScrollDirection direction =
          scrollController.position.userScrollDirection;
      if (scrollController.position.pixels >= 55) {
        _showTitle.value = true;
      } else {
        _showTitle.value = false;
      }

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

  Future<void> refreshData({bool showSplash = false}) async {
    if (showSplash) {
      change(null, status: RxStatus.loading());
    } else {
      change(null, status: RxStatus.success());
    }
    await loadData();
  }

  Future<void> loadData() async {
    String? message;
    bool success = true;

    await ApiProvider.getThread(channelName: channelName, threadId: threadId!)
        .then((value) {
      success = value.success;
      if (!success) {
        message = value.message;
      } else {
        thread = value.data!;
      }
    });

    if (!success) {
      change(null, status: RxStatus.error(message!));
      return;
    } else {
      change(null, status: RxStatus.success());
    }
  }
}
