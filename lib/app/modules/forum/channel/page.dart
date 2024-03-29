import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/pages.dart';
import 'controller.dart';
import 'widgets/thread_preview_list/page.dart';

class ChannelPage extends GetView<ChannelController> {
  const ChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.channelDisplayName),
      ),
      floatingActionButton: controller.channelName != "announcements"
          ? SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 2),
                end: const Offset(0, 0),
              ).animate(CurvedAnimation(
                parent: controller.fabAnimationController,
                curve: Curves.easeInOut,
              )),
              child: FloatingActionButton(
                foregroundColor: Theme.of(context).colorScheme.onSecondary,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  Get.toNamed(AppRoutes.createThread,
                      arguments: controller.channelName);
                },
                child: const Icon(Icons.reply),
              ),
            )
          : null,
      body: ThreadPreviewList(
        channelName: controller.channelName,
        scrollController: controller.scrollController,
      ),
    );
  }
}
