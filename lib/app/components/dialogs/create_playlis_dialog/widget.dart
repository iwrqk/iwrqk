import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import 'controller.dart';

class CreatePlaylistDialog extends GetWidget<CreatePlaylistDialogController> {
  final Function()? onChanged;

  const CreatePlaylistDialog({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        t.playlist.create,
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
            onPressed: controller.addingPlaylist
                ? null
                : () {
                    controller.createPlaylist(onChanged);
                  },
            child: Text(t.notifications.confirm),
          ),
        )
      ],
    );
  }
}
