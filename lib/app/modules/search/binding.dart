import 'package:get/get.dart';

import 'controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchController>(() => SearchController());
  }
}
