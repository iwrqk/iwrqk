import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

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

  void createThread(String titleEmptyMessage, String contentEmptyMessage) {
    if (titleController.text.isEmpty) {
      showToast(titleEmptyMessage);
    } else if (contentController.text.isEmpty) {
      showToast(contentEmptyMessage);
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
