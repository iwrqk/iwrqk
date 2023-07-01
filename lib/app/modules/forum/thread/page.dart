import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import 'controller.dart';
import 'widgets/posts_list/widget.dart';
import 'widgets/send_post_bottom_sheet/widget.dart';

class ThreadPage extends GetWidget<ThreadController> {
  const ThreadPage({super.key});

  Widget _buildCommentButton(BuildContext context) {
    return controller.locked
        ? Container(
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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(
                    FontAwesomeIcons.lock,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  AutoSizeText(
                    L10n.of(context).thread_locked,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () {
              Get.bottomSheet(SendPostBottomSheet(
                threadId: controller.threadId,
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
                margin: MediaQuery.of(context).padding.copyWith(top: 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
          );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
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
            L10n.of(context).thread,
          ),
        ),
        floatingActionButton: controller.showToTopButton
            ? Padding(
                padding: const EdgeInsets.only(bottom: 75),
                child: FloatingActionButton(
                  onPressed: controller.jumpToTop,
                  child: const FaIcon(FontAwesomeIcons.arrowUp),
                ),
              )
            : null,
        body: Column(
          children: [
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: PostList(
                  title: controller.title,
                  starterUserName: controller.starterUserName,
                  channelName: controller.channelName,
                  threadId: controller.threadId,
                  scrollController: controller.scrollController,
                ),
              ),
            ),
            _buildCommentButton(context),
          ],
        ),
      ),
    );
  }
}
