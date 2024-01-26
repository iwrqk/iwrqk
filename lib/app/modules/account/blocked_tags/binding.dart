import 'package:get/get.dart';

import 'add_tag/controller.dart';
import 'controller.dart';

class BlockedTagsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlockedTagsController>(() => BlockedTagsController());
    Get.put<AddTagController>(AddTagController());
  }
}
