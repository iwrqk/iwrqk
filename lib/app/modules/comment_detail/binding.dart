import 'package:get/get.dart';

import 'controller.dart';

class CommentDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.create<CommentDetailController>(() => CommentDetailController());
  }
}
