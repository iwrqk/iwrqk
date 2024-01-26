import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../../../data/services/user_service.dart';

class SendPostBottomSheetController extends GetxController {
  final UserService _userService = Get.find();
  final formKey = GlobalKey<FormState>();

  final RxBool _sending = false.obs;

  bool get sending => _sending.value;

  TextEditingController contentController = TextEditingController();

  final FocusNode contentFocusNode = FocusNode();

  Future<void> sendPost(String threadId) async {
    String content = contentController.text;
    bool success = false;

    if (content.isEmpty) {
      SmartDialog.showToast(t.message.comment.content_empty);
      return;
    }

    _sending.value = true;

    await _userService
        .sendPost(
      threadId: threadId,
      content: content,
    )
        .then((value) {
      success = value;
    });

    _sending.value = false;

    if (success) {
      SmartDialog.showToast(t.message.comment.sent);
      Get.back();
    }
  }
}
