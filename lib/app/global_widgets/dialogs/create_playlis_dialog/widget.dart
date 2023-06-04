import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
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
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        L10n.of(context).playlist_create,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: TextField(
        cursorColor: Theme.of(context).primaryColor,
        controller: controller.titleEditingController,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
          hintText: L10n.of(context).playlist_title,
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
      ),
      contentPadding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      actions: [
        Obx(
          () => CupertinoButton(
            onPressed: controller.addingPlaylist
                ? null
                : () {
                    controller.createPlaylist(
                      onChanged,
                      L10n.of(context).message_empty_playlist_title,
                      L10n.of(context).message_playlist_created,
                    );
                  },
            child: Text(
              L10n.of(context).confirm,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
