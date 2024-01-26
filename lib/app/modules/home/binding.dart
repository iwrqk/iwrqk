import 'package:get/get.dart';

import '../tabs/forum_tab/controller.dart';
import '../tabs/images_tab/controller.dart';
import '../tabs/subscription_tab/controller.dart';
import '../tabs/videos_tab/controller.dart';
import 'controller.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());

    Get.lazyPut<SubscriptionTabController>(() => SubscriptionTabController());
    Get.lazyPut<VideosTabController>(() => VideosTabController());
    Get.lazyPut<ImagesTabController>(() => ImagesTabController());
    Get.lazyPut<ForumTabController>(() => ForumTabController());
  }
}
