import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../data/enums/types.dart';
import '../../data/services/user_service.dart';

class SendCommentBottomSheetController extends GetxController {
  final UserService _userService = Get.find();
  final formKey = GlobalKey<FormState>();

  final RxBool _sendingComment = false.obs;

  bool get sendingComment => _sendingComment.value;

  TextEditingController contentController = TextEditingController();

  final FocusNode contentFocusNode = FocusNode();

  late CommentsSourceType sourceType;
  late String sourceId;
  String? parentId;

  void init({
    required CommentsSourceType sourceType,
    required String sourceId,
    String? parentId,
  }) {
    this.sourceType = sourceType;
    this.sourceId = sourceId;
    this.parentId = parentId;
  }

  Future<void> sendComment() async {
    String content = contentController.text;
    bool success = false;

    if (content.isEmpty) {
      SmartDialog.showToast(t.message.comment.content_empty);
      return;
    }

    _sendingComment.value = true;

    await _userService
        .sendComment(
      sourceType: sourceType,
      sourceId: sourceId,
      content: content,
    )
        .then((value) {
      success = value;
    });

    _sendingComment.value = false;

    if (success) {
      SmartDialog.showToast(t.message.comment.sent);
      Get.back();
    }
  }
}
