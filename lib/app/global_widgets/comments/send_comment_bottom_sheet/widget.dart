import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../data/enums/types.dart';
import 'controller.dart';

class SendCommentBottomSheet
    extends GetWidget<SendCommentBottomSheetController> {
  final CommentsSourceType sourceType;
  final String sourceId;
  final String? parentId;

  const SendCommentBottomSheet({
    super.key,
    required this.sourceType,
    required this.sourceId,
    this.parentId,
  });

  @override
  Widget build(BuildContext context) {
    controller.init(
        sourceType: sourceType, sourceId: sourceId, parentId: parentId);

    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (BuildContext context) {
        return Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: controller.contentController,
                    minLines: 2,
                    maxLines: 5,
                    maxLength: 1000,
                    autofocus: true,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      hintText: L10n.of(context).comments_send_comment,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Obx(
                () => CupertinoButton(
                  child: Text(
                    L10n.of(context).send,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  onPressed: controller.sendingComment
                      ? null
                      : () {
                          controller.sendComment(
                            L10n.of(context).message_empty_comment,
                            L10n.of(context).message_comment_sent,
                          );
                        },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
