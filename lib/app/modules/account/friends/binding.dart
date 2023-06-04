import 'package:get/get.dart';

import 'controller.dart';

class FriendsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendsController>(() => FriendsController());
  }
}
