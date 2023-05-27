import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../l10n.dart';
import '../../core/utils/display_util.dart';
import '../../data/enums/types.dart';
import '../../data/models/comment.dart';
import '../../data/models/user.dart';
import '../../routes/pages.dart';
import '../iwr_markdown.dart';
import '../reloadable_image.dart';

class UserComment extends StatelessWidget {
  final CommentModel comment;
  final String uploaderUserName;
  final bool showReplies;
  final bool canJumpToDetail;
  final String? sourceId;
  final CommentsSourceType? sourceType;

  const UserComment({
    Key? key,
    required this.comment,
    required this.uploaderUserName,
    this.showReplies = true,
    this.canJumpToDetail = true,
    this.sourceId,
    this.sourceType,
  }) : super(key: key);

  void _gotoUserProfile(String userName) {
    Get.toNamed(
      AppRoutes.profile,
      arguments: userName,
      preventDuplicates: false,
    );
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
        _gotoUserProfile(comment.user.username);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: ReloadableImage(
              imageUrl: comment.user.avatarUrl,
              width: 30,
              height: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              comment.user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (uploaderUserName == comment.user.username)
            _buildUploaderBadge(context)
        ],
      ),
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
            data: comment.body,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              DisplayUtil.getDisplayTime(DateTime.parse(comment.createdAt)),
              style: const TextStyle(color: Colors.grey, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _repliesBuilder(BuildContext context, int index) {
    UserModel user = comment.children[index].user;
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
          if (uploaderUserName == user.username)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _buildUploaderBadge(context),
            ),
          const TextSpan(text: "："),
          TextSpan(text: comment.children[index].body.replaceAll("\n", ""))
        ],
      ),
      style: const TextStyle(overflow: TextOverflow.ellipsis),
      maxLines: 5,
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
                data: comment.body),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                DisplayUtil.getDisplayTime(DateTime.parse(comment.createdAt)),
                style: const TextStyle(color: Colors.grey, fontSize: 12.5),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5)),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount:
                          comment.numReplies >= 2 ? 2 : comment.numReplies,
                      itemBuilder: _repliesBuilder),
                  Visibility(
                    visible: comment.numReplies > 2,
                    child: GestureDetector(
                      onTap: _jumpToDetail,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          L10n.of(context).comments_see_all_replies(
                              comment.numReplies.toString()),
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ));
  }

  void _jumpToDetail() {
    if (canJumpToDetail) {
      late CommentsSourceType detailSourceType;
      switch (sourceType!) {
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
          'uploaderUserName': uploaderUserName,
          'parentComment': comment,
          'sourceId': sourceId!,
          'sourceType': detailSourceType,
        },
        preventDuplicates: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _jumpToDetail,
      child: Container(
        color: Theme.of(context).canvasColor,
        padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: comment.children.isEmpty || showReplies == false
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
    );
  }
}
