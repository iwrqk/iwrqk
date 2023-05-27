import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/display_util.dart';
import '../../../../data/models/forum/post.dart';
import '../../../../global_widgets/iwr_markdown.dart';
import '../../../../global_widgets/reloadable_image.dart';
import '../../../../routes/pages.dart';

class Post extends StatelessWidget {
  final PostModel post;
  final int index;
  final String starterUserName;

  const Post({
    Key? key,
    required this.post,
    required this.index,
    required this.starterUserName,
  }) : super(key: key);

  Widget _buildStarterBadge(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        "OP",
        style: TextStyle(color: Colors.white, fontSize: 12.5),
      ),
    );
  }

  Widget _buildUserWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoutes.profile,
          arguments: post.user.username,
          preventDuplicates: false,
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: ReloadableImage(
              imageUrl: post.user.avatarUrl,
              width: 30,
              height: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              post.user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          if (starterUserName == post.user.username) _buildStarterBadge(context)
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IwrMarkdown(
            padding: const EdgeInsets.only(top: 5),
            selectable: true,
            data: post.body,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "#${index + 1} ",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: DisplayUtil.getDisplayTime(
                      DateTime.parse(post.createAt),
                    ),
                    style: const TextStyle(color: Colors.grey, fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildUserWidget(context),
        _buildContent(context),
      ]),
    );
  }
}
