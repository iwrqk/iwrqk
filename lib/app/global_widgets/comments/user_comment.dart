import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../../l10n.dart';
import '../../core/utils/display_util.dart';
import '../../data/enums/types.dart';
import '../../data/models/comment.dart';
import '../../data/models/user.dart';
import '../../data/providers/translate_provider.dart';
import '../../routes/pages.dart';
import '../iwr_markdown.dart';
import '../reloadable_image.dart';
import '../translated_content.dart';

class UserComment extends StatefulWidget {
  final CommentModel comment;
  final String uploaderUserName;
  final bool showReplies;
  final bool canJumpToDetail;
  final String? sourceId;
  final CommentsSourceType? sourceType;
  final bool isMyComment;

  const UserComment({
    Key? key,
    required this.comment,
    required this.uploaderUserName,
    this.showReplies = true,
    this.canJumpToDetail = true,
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
    TranslateProvider.google(
      text: widget.comment.body,
    ).then((value) {
      if (value.success) {
        setState(() {
          translatedContent = value.data;
        });
      } else {
        showToast(value.message!);
      }
    });
  }

  Widget _buildUploaderBadge(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        "UP",
        style: TextStyle(color: Colors.white, fontSize: 12.5),
      ),
    );
  }

  Widget _buildUserWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _gotoUserProfile(widget.comment.user.username);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: ReloadableImage(
              imageUrl: widget.comment.user.avatarUrl,
              width: 30,
              height: 30,
            ),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(
                widget.comment.user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (widget.uploaderUserName == widget.comment.user.username)
            _buildUploaderBadge(context)
        ],
      ),
    );
  }

  Widget _buildBottomWidget(BuildContext context) {
    String text =
        DisplayUtil.getDisplayTime(DateTime.parse(widget.comment.createdAt));
    if (widget.comment.createdAt != widget.comment.updatedAt) {
      text +=
          "\n${L10n.of(context).updated_at(DisplayUtil.getDisplayTime(DateTime.parse(widget.comment.updatedAt)))}";
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: Colors.grey, fontSize: 12.5),
            ),
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: "translate",
                  child: Text(
                    L10n.of(context).translate,
                  ),
                ),
                if (widget.isMyComment) ...[
                  PopupMenuItem<String>(
                    value: "edit",
                    child: Text(
                      L10n.of(context).edit,
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: "delete",
                    child: Text(
                      L10n.of(context).delete,
                    ),
                  ),
                ]
              ];
            },
            onSelected: (String value) {
              if (value == "translate") {
                _getTranslatedContent();
              }
            },
            child: FaIcon(
              FontAwesomeIcons.ellipsis,
              size: 15,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }

  Widget _repliesBuilder(BuildContext context, int index) {
    UserModel user = widget.comment.children[index].user;
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: user.name,
            style: const TextStyle(color: Colors.grey),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _gotoUserProfile(user.username);
              },
          ),
          if (widget.uploaderUserName == user.username)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _buildUploaderBadge(context),
            ),
          const TextSpan(text: "："),
          TextSpan(
              text: widget.comment.children[index].body.replaceAll("\n", ""))
        ],
      ),
      style: const TextStyle(overflow: TextOverflow.ellipsis),
      maxLines: 5,
    );
  }

  Widget _buildContentWithoutReplies(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IwrMarkdown(
            padding: const EdgeInsets.only(top: 5),
            selectable: true,
            data: widget.comment.body,
          ),
          if (translatedContent != null)
            TranslatedContent(
              padding: const EdgeInsets.only(top: 10),
              translatedContent: translatedContent!,
            ),
          _buildBottomWidget(context),
        ],
      ),
    );
  }

  Widget _buildContentWithReplies(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IwrMarkdown(
            selectable: true,
            padding: const EdgeInsets.only(top: 5),
            data: widget.comment.body,
          ),
          if (translatedContent != null)
            TranslatedContent(
              padding: const EdgeInsets.only(top: 10),
              translatedContent: translatedContent!,
            ),
          _buildBottomWidget(context),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.comment.numReplies >= 2
                      ? 2
                      : widget.comment.numReplies,
                  itemBuilder: _repliesBuilder,
                ),
                Visibility(
                  visible: widget.comment.numReplies > 2,
                  child: GestureDetector(
                    onTap: _jumpToDetail,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        L10n.of(context).comments_see_all_replies(
                            widget.comment.numReplies.toString()),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _jumpToDetail() {
    if (widget.canJumpToDetail) {
      late CommentsSourceType detailSourceType;
      switch (widget.sourceType!) {
        case CommentsSourceType.video:
          detailSourceType = CommentsSourceType.videoReplies;
          break;
        case CommentsSourceType.image:
          detailSourceType = CommentsSourceType.imageReplies;
          break;
        case CommentsSourceType.profile:
          detailSourceType = CommentsSourceType.profileReplies;
          break;
        default:
      }
      Get.toNamed(
        AppRoutes.commentDetail,
        arguments: {
          'uploaderUserName': widget.uploaderUserName,
          'parentComment': widget.comment,
          'sourceId': widget.sourceId!,
          'sourceType': detailSourceType,
        },
        preventDuplicates: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: _jumpToDetail,
      child: Card(
        color: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.comment.children.isEmpty ||
                          widget.showReplies == false
                      ? [
                          _buildUserWidget(context),
                          _buildContentWithoutReplies(context)
                        ]
                      : [
                          _buildUserWidget(context),
                          _buildContentWithReplies(context),
                        ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
