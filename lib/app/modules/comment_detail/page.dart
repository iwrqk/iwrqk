import 'package:auto_size_text/auto_size_text.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../l10n.dart';
import '../../global_widgets/comments/comments_list/widget.dart';
import '../../global_widgets/comments/send_comment_bottom_sheet/widget.dart';
import '../../global_widgets/comments/user_comment.dart';
import 'controller.dart';

class CommentDetailPage extends GetWidget<CommentDetailController> {
  const CommentDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const FaIcon(FontAwesomeIcons.chevronLeft),
          ),
          shape: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0,
            ),
          ),
          centerTitle: true,
          title: Text(
            L10n.of(context).comment,
          ),
        ),
        floatingActionButton: controller.showToTopButton
            ? Padding(
                padding: const EdgeInsets.only(bottom: 75),
                child: FloatingActionButton(
                  onPressed: controller.jumpToTop,
                  backgroundColor: Theme.of(context).canvasColor,
                  foregroundColor: Colors.grey,
                  child: const FaIcon(FontAwesomeIcons.arrowUp),
                ),
              )
            : null,
        body: ExtendedNestedScrollView(
          controller: controller.scrollController,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: UserComment(
                uploaderUserName: controller.uploaderUserName,
                comment: controller.parentComment,
                showReplies: false,
                canJumpToDetail: false,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                alignment: Alignment.centerLeft,
                child: AutoSizeText(
                  L10n.of(context).replies,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
          body: Column(
            children: [
              Expanded(
                child: CommentsList(
                  uploaderUserName: controller.uploaderUserName,
                  sourceType: controller.sourceType,
                  sourceId: controller.sourceId,
                  parentId: controller.parentComment.id,
                  canJumpToDetail: false,
                ),
              ),
              InkWell(
                onTap: () {
                  Get.bottomSheet(SendCommentBottomSheet(
                    sourceId: controller.sourceId,
                    sourceType: controller.sourceType,
                    parentId: controller.parentComment.id,
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: AutoSizeText(
                        L10n.of(context).comments_send_comment,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
