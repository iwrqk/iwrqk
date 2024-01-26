import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/network_image.dart';
import '../../../utils/display_util.dart';
import 'controller.dart';
import 'widgets/posts_list/widget.dart';
import 'widgets/send_post_bottom_sheet/widget.dart';

class ThreadPage extends GetWidget<ThreadController> {
  const ThreadPage({super.key});

  Widget _buildTitle() {
    return ListTile(
      leading: ClipOval(
        child: NetworkImg(
          imageUrl: controller.starterAvatarUrl,
          width: 30,
          height: 30,
        ),
      ),
      title: Text(
        controller.starteName,
        style: const TextStyle(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        DisplayUtil.getDisplayTime(DateTime.parse(controller.timestamp)),
        style: const TextStyle(fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Obx(
          () => AnimatedOpacity(
            opacity: controller.showTitle ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: _buildTitle(),
          ),
        ),
        titleSpacing: 0,
      ),
      floatingActionButton: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 2),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: controller.fabAnimationController,
          curve: Curves.easeInOut,
        )),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: FloatingActionButton(
            onPressed: controller.locked
                ? null
                : () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SendPostBottomSheet(
                          threadId: controller.threadId,
                        ),
                      ),
                    );
                  },
            child: controller.locked
                ? const Icon(Icons.lock)
                : const Icon(Icons.reply),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PostList(
              title: controller.title,
              starterUserName: controller.starterUserName,
              channelName: controller.channelName,
              threadId: controller.threadId,
              scrollController: controller.scrollController,
            ),
          ),
        ],
      ),
    );
  }
}
