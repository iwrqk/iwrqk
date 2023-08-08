import 'package:get/get.dart';

import 'controller.dart';

class BlockedTagsBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<BlockedTagsController>(() => BlockedTagsController());
  }
}