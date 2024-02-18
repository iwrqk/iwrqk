import 'package:get/get.dart';

import 'controller.dart';

class RulesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RulesController>(() => RulesController());
  }
}
