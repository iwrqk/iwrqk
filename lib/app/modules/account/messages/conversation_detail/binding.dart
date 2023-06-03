import 'package:get/get.dart';

import 'controller.dart';

class ConversationDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationDetailController>(
        () => ConversationDetailController());
  }
}
