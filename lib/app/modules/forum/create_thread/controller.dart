import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/services/user_service.dart';

class CreateThreadController extends GetxController {
  CreateThreadController();

  final UserService _userService = Get.find();

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  late String channelName;

  @override
  void onInit() {
    super.onInit();
    channelName = Get.arguments!;
  }

  void createThread() {
    if (titleController.text.isEmpty) {
      SmartDialog.showToast(t.message.create_thread.title_empty);
    } else if (contentController.text.isEmpty) {
      SmartDialog.showToast(t.message.create_thread.title_empty);
    } else {
      _userService
          .createThread(
        channelName: channelName,
        title: titleController.text,
        content: contentController.text,
      )
          .then((value) {
        if (value) {
          Get.back();
        }
      });
    }
  }
}
