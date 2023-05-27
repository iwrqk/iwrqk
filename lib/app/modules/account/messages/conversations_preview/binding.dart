import 'package:get/get.dart';

import 'controller.dart';

class ConversationsPreviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationsPreviewController>(
      () => ConversationsPreviewController(),
    );
  }
}
