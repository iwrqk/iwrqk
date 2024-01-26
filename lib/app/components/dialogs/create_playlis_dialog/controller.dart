import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/services/user_service.dart';

class CreatePlaylistDialogController extends GetxController {
  final UserService _userService = Get.find();

  TextEditingController titleEditingController = TextEditingController();
  final RxBool _addingPlaylist = false.obs;

  bool get addingPlaylist => _addingPlaylist.value;

  Future<void> createPlaylist(
    Function()? onChanged,
  ) async {
    String title = titleEditingController.text;
    bool success = false;

    if (title.isEmpty) {
      SmartDialog.showToast(t.message.playlist.empty_playlist_title);
      return;
    }

    _addingPlaylist.value = true;

    success = await _userService.createPlaylist(title);

    _addingPlaylist.value = false;

    if (success) {
      Get.back();
      SmartDialog.showToast(t.message.playlist.playlist_created);
      onChanged?.call();
    }
  }
}
