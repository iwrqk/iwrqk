import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import 'controller.dart';
import 'widgets/posts_list/widget.dart';

class ThreadPage extends GetWidget<ThreadController> {
  ThreadPage({super.key});

  final String title = Get.arguments['title'];
  final String starterUserName = Get.arguments['starterUserName'];
  final String channelName = Get.arguments['channelName'];
  final String threadId = Get.arguments['threadId'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: FaIcon(FontAwesomeIcons.chevronLeft),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0,
          ),
        ),
        centerTitle: true,
        title: Text(
          L10n.of(context).thread,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PostList(
              title: title,
              starterUserName: starterUserName,
              channelName: channelName,
              threadId: threadId,
            ),
          ),
          InkWell(
            onTap: () {
              // Get.bottomSheet(SendCommentBottomSheet(
              //   sourceId: _controller.media.id,
              //   sourceType: _controller.mediaType == MediaType.video
              //       ? CommentsSourceType.video
              //       : CommentsSourceType.image,
              // ));
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
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: AutoSizeText(
                  L10n.of(context).comments_send_comment,
                  maxLines: 1,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
