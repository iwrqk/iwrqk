import 'package:get/get.dart';

import 'controller.dart';

class SetupBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetupController>(() => SetupController());
  }
}
