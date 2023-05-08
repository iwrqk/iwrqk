import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../../data/services/user_service.dart';

class CreatePlaylistDialogController extends GetxController {
  final UserService _userService = Get.find();

  TextEditingController titleEditingController = TextEditingController();
  final RxBool _addingPlaylist = false.obs;

  bool get addingPlaylist => _addingPlaylist.value;

  Future<void> createPlaylist(
    Function()? onChanged,
    String emptyMessage,
    String createdMessage,
  ) async {
    String title = titleEditingController.text;
    bool success = false;

    if (title.isEmpty) {
      showToast(emptyMessage);
      return;
    }

    _addingPlaylist.value = true;

    success = await _userService.createPlaylist(title);

    _addingPlaylist.value = false;

    if (success) {
      Get.back();
      showToast(createdMessage);
      onChanged?.call();
    }
  }
}
