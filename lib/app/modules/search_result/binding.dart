import 'package:get/get.dart';

import 'controller.dart';

class SearchResultBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchResultController>(() => SearchResultController());
  }
}
