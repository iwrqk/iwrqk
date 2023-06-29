import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../l10n.dart';
import 'controller.dart';

class SendPostBottomSheet
    extends GetWidget<SendPostBottomSheetController> {
  final String threadId;

  const SendPostBottomSheet({
    super.key,
    required this.threadId,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (BuildContext context) {
        return SafeArea(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Theme(
                    data: Theme.of(context).brightness == Brightness.light
                        ? ThemeData.light()
                        : ThemeData.dark(),
                    child: TextField(
                      controller: controller.contentController,
                      minLines: 2,
                      maxLines: 5,
                      maxLength: 100000,
                      autofocus: true,
                      cursorColor: Theme.of(context).primaryColor,
                      decoration: InputDecoration(
                        hintText: L10n.of(context).send,
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),
              Obx(
                () => CupertinoButton(
                  onPressed: controller.sending
                      ? null
                      : () {
                          controller.sendPost(
                            threadId,
                            L10n.of(context).message_content_empty,
                            L10n.of(context).message_comment_sent,
                          );
                        },
                  child: Text(
                    L10n.of(context).send,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
