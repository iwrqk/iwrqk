import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../../../data/services/user_service.dart';

class SendMessageBottomSheetController extends GetxController {
  final UserService _userService = Get.find();
  final formKey = GlobalKey<FormState>();

  final RxBool _sending = false.obs;

  bool get sending => _sending.value;

  TextEditingController contentController = TextEditingController();

  Future<void> sendMessage(
      String conversationId, String emptyMessage, String sentMessage) async {
    String content = contentController.text;
    bool success = false;

    if (content.isEmpty) {
      showToast(emptyMessage);
      return;
    }

    _sending.value = true;

    await _userService
        .sendMessage(
      conversationId: conversationId,
      content: content,
    )
        .then((value) {
      success = value;
    });

    _sending.value = false;

    if (success) {
      showToast(sentMessage);
      Get.back();
    }
  }
}
