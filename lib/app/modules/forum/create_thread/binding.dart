import 'package:get/get.dart';

import 'controller.dart';

class CreateThreadBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateThreadController>(() => CreateThreadController());
  }
}
