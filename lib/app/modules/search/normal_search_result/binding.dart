import 'package:get/get.dart';

import 'controller.dart';

class NormalSearchResultBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NormalSearchResultController>(
        () => NormalSearchResultController());
  }
}
