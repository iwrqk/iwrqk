import 'package:get/get.dart';

import 'controller.dart';

class NormalSearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NormalSearchController>(() => NormalSearchController());
  }
}
