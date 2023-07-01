import 'package:get/get.dart';

import 'controller.dart';

class ChannelBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChannelController>(() => ChannelController());
  }
}
