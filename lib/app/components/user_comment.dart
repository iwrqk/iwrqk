import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../data/enums/types.dart';
import '../data/models/comment.dart';
import '../data/models/user.dart';
import '../data/providers/translate_provider.dart';
import '../data/services/user_service.dart';
import '../utils/display_util.dart';
import 'edit_comment_bottom_sheet/widget.dart';
import 'iwr_markdown.dart';
import 'network_image.dart';
import 'replies_detail.dart';
import 'translated_content.dart';

class UserComment extends StatefulWidget {
  final CommentModel comment;
  final String uploaderUserName;
  final bool showReplies;
  final bool canJumpToDetail;
  final bool showDivider;
  final String? sourceId;
  final CommentsSourceType? sourceType;
  final bool isMyComment;
  final void Function(Map)? onUpdated;

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
    this.onUpdated,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UserCommentState();
}

class _UserCommentState extends State<UserComment>
    with AutomaticKeepAliveClientMixin {
  String? translatedContent;

  void _gotoUserProfile(String userName) {
    Get.toNamed("/profile?userName=$userName");
  }

  void _getTranslatedContent() async {
    if (translatedContent != null) return;
    TranslateProvider.google(
      text: widget.comment.body,
    ).then((value) {
      if (value.success) {
        setState(() {
          translatedContent = value.data;
        });
      } else {
        SmartDialog.showToast(value.message!);
      }
    });
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
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: EditCommentBottomSheet(
                            isEdit: true,
                            editId: widget.comment.id,
                            editInitialContent: widget.comment.body,
                            onChanged: (String content) => widget.onUpdated
                                ?.call({"state": "edit", "content": content}),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      t.comment.edit_comment,
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "delete",
                    onTap: () {
                      final UserService userService = Get.find();
                      userService.deleteComment(
                        id: widget.comment.id,
                      );
                      widget.onUpdated?.call({"state": "delete"});
                    },
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
        style: TextStyle(
            color: Theme.of(context).colorScheme.outline, fontSize: 12.5),
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
            selectable: !widget.canJumpToDetail,
            data: widget.comment.body,
          ),
          if (translatedContent != null)
            TranslatedContent(
              padding: const EdgeInsets.only(top: 12),
              translatedContent: translatedContent!,
            ),
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
          SizedBox(height: widget.showDivider ? 12 : 8),
          if (widget.showDivider) const Divider(height: 0),
        ],
      ),
    );
  }

  CommentsSourceType getDetailSourceType() {
    switch (widget.sourceType) {
      case CommentsSourceType.video:
        return CommentsSourceType.videoReplies;
      case CommentsSourceType.image:
        return CommentsSourceType.imageReplies;
      case CommentsSourceType.profile:
        return CommentsSourceType.profileReplies;
      default:
        return CommentsSourceType.videoReplies;
    }
  }

  void _jumpToDetail() {
    if (widget.canJumpToDetail) {
      bool showInPage = widget.sourceType == CommentsSourceType.profile;
      CommentsSourceType detailSourceType = getDetailSourceType();
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

    Widget child = Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserWidget(context),
          _buildContent(context),
        ],
      ),
    );

    return widget.canJumpToDetail
        ? InkWell(
            onTap: () {
              _jumpToDetail();
            },
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: widget.comment.body));
            },
            child: child)
        : child;
  }

  @override
  bool get wantKeepAlive => true;
}
