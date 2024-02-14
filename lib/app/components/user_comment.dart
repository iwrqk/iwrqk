import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../data/enums/types.dart';
import '../data/models/comment.dart';
import '../data/models/user.dart';
import '../routes/pages.dart';
import '../utils/display_util.dart';
import 'iwr_markdown.dart';
import 'network_image.dart';
import 'replies_detail.dart';

class UserComment extends StatefulWidget {
  final CommentModel comment;
  final String uploaderUserName;
  final bool showReplies;
  final bool canJumpToDetail;
  final bool showDivider;
  final String? sourceId;
  final CommentsSourceType? sourceType;
  final bool isMyComment;

  const UserComment({
    Key? key,
    required this.comment,
    required this.uploaderUserName,
    this.showReplies = true,
    this.canJumpToDetail = true,
    this.showDivider = true,
    this.sourceId,
    this.sourceType,
    this.isMyComment = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserCommentState();
}

class _UserCommentState extends State<UserComment>
    with AutomaticKeepAliveClientMixin {
  String? translatedContent;

  void _gotoUserProfile(String userName) {
    Get.toNamed(
      AppRoutes.profile,
      arguments: userName,
      preventDuplicates: false,
    );
  }

  void _getTranslatedContent() async {
    // TranslateProvider.google(
    //   text: widget.comment.body,
    // ).then((value) {
    //   if (value.success) {
    //     setState(() {
    //       translatedContent = value.data;
    //     });
    //   } else {
    //     showToast(value.message!);
    //   }
    // });
  }

  Widget _buildUploaderBadge(BuildContext context, [bool small = false]) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: small ? 1 : 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "UP",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: small ? 10 : 12,
        ),
      ),
    );
  }

  Widget _buildUserWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _gotoUserProfile(widget.comment.user.username);
      },
      child: Row(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: NetworkImg(
                    imageUrl: widget.comment.user.avatarUrl,
                    width: 40,
                    height: 40,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Text(
                      widget.comment.user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                if (widget.uploaderUserName == widget.comment.user.username)
                  _buildUploaderBadge(context)
              ],
            ),
          ),
          PopupMenuButton(
            padding: EdgeInsets.zero,
            position: PopupMenuPosition.under,
            icon: Icon(
              Icons.more_horiz,
              color: Theme.of(context).colorScheme.outline,
            ),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "translate",
                  onTap: _getTranslatedContent,
                  child: Text(
                    t.common.translate,
                  ),
                ),
                if (widget.isMyComment) ...[
                  PopupMenuItem<String>(
                    value: "edit",
                    child: Text(
                      t.comment.edit_comment,
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "delete",
                    child: Text(
                      t.comment.delete_comment,
                    ),
                  ),
                ]
              ];
            },
          )
        ],
      ),
    );
  }

  Widget _buildBottomWidget(BuildContext context) {
    String text =
        DisplayUtil.getDisplayTime(DateTime.parse(widget.comment.createdAt));
    if (widget.comment.createdAt != widget.comment.updatedAt) {
      text +=
          "\n${t.media.updated_at(time: DisplayUtil.getDisplayTime(DateTime.parse(widget.comment.updatedAt)))}";
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(
        text,
        style: const TextStyle(color: Colors.grey, fontSize: 12.5),
      ),
    );
  }

  Widget _repliesBuilder(BuildContext context, int index) {
    UserModel user = widget.comment.children[index].user;
    return InkWell(
      onTap: () {
        _jumpToDetail();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: user.name,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              if (widget.uploaderUserName == user.username)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: _buildUploaderBadge(context, true),
                ),
              const TextSpan(text: "："),
              TextSpan(
                text: widget.comment.children[index].body.replaceAll("\n", ""),
              )
            ],
          ),
          style: const TextStyle(overflow: TextOverflow.ellipsis),
          maxLines: 5,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IwrMarkdown(
            selectable: true,
            data: widget.comment.body,
          ),
          // if (translatedContent != null)
          //   TranslatedContent(
          //     padding: const EdgeInsets.only(top: 10),
          //     translatedContent: translatedContent!,
          //   ),
          _buildBottomWidget(context),
          if (!(widget.comment.children.isEmpty || widget.showReplies == false))
            Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.only(top: 6),
              color: Theme.of(context).colorScheme.onInverseSurface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...List.generate(
                    widget.comment.children.length >= 2
                        ? 2
                        : widget.comment.children.length,
                    (index) => _repliesBuilder(context, index),
                  ),
                  if (widget.comment.numReplies > 2)
                    InkWell(
                      onTap: () {
                        _jumpToDetail();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        child: Text(
                          t.comment.show_all_replies(
                              numReply: widget.comment.numReplies.toString()),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          if (widget.showDivider) const SizedBox(height: 12),
          if (widget.showDivider) const Divider(height: 0),
        ],
      ),
    );
  }

  void _jumpToDetail() {
    if (widget.canJumpToDetail) {
      late CommentsSourceType detailSourceType;
      bool showInPage = false;
      switch (widget.sourceType!) {
        case CommentsSourceType.video:
          detailSourceType = CommentsSourceType.videoReplies;
          break;
        case CommentsSourceType.image:
          detailSourceType = CommentsSourceType.imageReplies;
          break;
        case CommentsSourceType.profile:
          showInPage = true;
          detailSourceType = CommentsSourceType.profileReplies;
          break;
        default:
      }
      if (showInPage) {
        Get.to(
          () => RepliesDetail(
            uploaderUserName: widget.uploaderUserName,
            parentComment: widget.comment,
            sourceId: widget.sourceId!,
            showInPage: showInPage,
            sourceType: detailSourceType,
          ),
        );
      } else {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: true,
          barrierColor: Colors.transparent,
          builder: (context) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: RepliesDetail(
              uploaderUserName: widget.uploaderUserName,
              parentComment: widget.comment,
              sourceId: widget.sourceId!,
              showInPage: showInPage,
              sourceType: detailSourceType,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildUserWidget(context), _buildContent(context)],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
