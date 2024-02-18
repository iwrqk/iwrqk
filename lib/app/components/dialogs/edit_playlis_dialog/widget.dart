import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import 'controller.dart';

class EditPlaylistDialog extends GetWidget<EditPlaylistDialogController> {
  final Function()? onChanged;
  final String? editId;
  final bool isEdit;

  const EditPlaylistDialog({
    Key? key,
    this.onChanged,
    this.editId,
    this.isEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEdit ? t.playlist.edit_title : t.playlist.create,
      ),
      content: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Theme(
          data: Theme.of(context).brightness == Brightness.light
              ? ThemeData.light()
              : ThemeData.dark(),
          child: TextFormField(
            controller: controller.titleEditingController,
            decoration: InputDecoration(
              isDense: true,
              hintText: t.playlist.title,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.editingPlaylist
                ? null
                : () {
                    controller.editPlaylist(
                      isEdit: isEdit,
                      editId: editId,
                      onChanged: onChanged,
                    );
                  },
            child: Text(t.notifications.confirm),
          ),
        )
      ],
    );
  }
}
