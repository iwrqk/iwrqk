import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/services/user_service.dart';

class EditPlaylistDialogController extends GetxController {
  final UserService _userService = Get.find();

  TextEditingController titleEditingController = TextEditingController();

  final RxBool _editingPlaylist = false.obs;
  bool get editingPlaylist => _editingPlaylist.value;

  Future<void> editPlaylist({
    bool isEdit = false,
    String? editId,
    Function()? onChanged,
  }) async {
    String title = titleEditingController.text;
    bool success = false;

    if (title.isEmpty) {
      SmartDialog.showToast(t.message.playlist.empty_playlist_title);
      return;
    }

    _editingPlaylist.value = true;

    if (isEdit) {
      success = await _userService.editPlaylistTitle(editId!, title);
    } else {
      success = await _userService.createPlaylist(title);
    }

    _editingPlaylist.value = false;

    if (success) {
      Get.back();
      SmartDialog.showToast(isEdit
          ? t.message.playlist.playlist_title_edited
          : t.message.playlist.playlist_created);
      onChanged?.call();
    }
  }
}
