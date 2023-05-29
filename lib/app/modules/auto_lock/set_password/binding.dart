import 'package:get/get.dart';

import 'controller.dart';

class SetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SetPasswordController>(() => SetPasswordController());
  }
}
