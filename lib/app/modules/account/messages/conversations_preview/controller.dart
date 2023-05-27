import 'package:get/get.dart';

import '../../../../data/services/user_service.dart';
import 'widgets/messages_preview_list/controller.dart';

class ConversationsPreviewController extends GetxController {
  ConversationsPreviewController();

  final UserService userService = Get.find();

  @override
  void onInit() {
    super.onInit();

    Get.put(ConversationsPreviewListController());
  }
}
