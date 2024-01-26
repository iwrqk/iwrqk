import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../data/enums/types.dart';
import '../data/models/comment.dart';
import '../data/services/user_service.dart';
import 'comments_list/widget.dart';
import 'send_comment_bottom_sheet/widget.dart';
import 'user_comment.dart';

class RepliesDetail extends StatelessWidget {
  final String uploaderUserName;
  final CommentModel parentComment;
  final String sourceId;
  final bool showInPage;
  final CommentsSourceType sourceType;

  RepliesDetail({
    super.key,
    required this.uploaderUserName,
    required this.parentComment,
    required this.sourceId,
    this.showInPage = false,
    required this.sourceType,
  });

  final UserService userService = Get.find();

  @override
  Widget build(BuildContext context) {
    Widget fab = FloatingActionButton(
      onPressed: () {
        Get.bottomSheet(SendCommentBottomSheet(
          sourceId: sourceId,
          sourceType: sourceType,
          parentId: parentComment.id,
        ));
      },
      child: const Icon(Icons.reply),
    );

    if (showInPage) {
      return Scaffold(
        appBar: AppBar(
          title: Text(t.comment.comment_detail),
        ),
        floatingActionButton: fab,
        body: CommentsList(
          uploaderUserName: uploaderUserName,
          sourceType: sourceType,
          sourceId: sourceId,
          parentId: parentComment.id,
          canJumpToDetail: false,
          paginated: false,
          parentComment: UserComment(
            uploaderUserName: uploaderUserName,
            comment: parentComment,
            showReplies: false,
            canJumpToDetail: false,
            showDivider: false,
            isMyComment: userService.user?.id == uploaderUserName,
          ),
        ),
      );
    } else {
      return Container(
        color: Theme.of(context).colorScheme.background,
        height: Get.height - Get.width / 16 * 9 - Get.mediaQuery.padding.top,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 46,
                  padding: const EdgeInsets.only(left: 12, right: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(t.comment.comment_detail),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: CommentsList(
                    uploaderUserName: uploaderUserName,
                    sourceType: sourceType,
                    sourceId: sourceId,
                    parentId: parentComment.id,
                    canJumpToDetail: false,
                    paginated: false,
                    parentComment: UserComment(
                      uploaderUserName: uploaderUserName,
                      comment: parentComment,
                      showReplies: false,
                      canJumpToDetail: false,
                      showDivider: false,
                      isMyComment: userService.user?.id == uploaderUserName,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: Get.mediaQuery.padding.bottom + 16,
              right: 14,
              child: fab,
            ),
          ],
        ),
      );
    }
  }
}
