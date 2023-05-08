import 'package:get/get.dart';

import 'controller.dart';

class LockBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LockController>(() => LockController());
  }
}
