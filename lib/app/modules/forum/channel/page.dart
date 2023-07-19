import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0,
          ),
        ),
        centerTitle: true,
        title: Text(controller.channelDisplayName),
      ),
      floatingActionButton: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.showToTopButton)
              FloatingActionButton(
                heroTag: 'jumpToTopBtn',
                onPressed: controller.jumpToTop,
                child: const FaIcon(FontAwesomeIcons.arrowUp),
              ),
            const SizedBox(
              height: 15,
            ),
            if (controller.channelName != "announcements")
              FloatingActionButton(
                heroTag: 'createThreadBtn',
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                onPressed: () {
                  Get.toNamed(AppRoutes.createThread,
                      arguments: controller.channelName);
                },
                child: const FaIcon(
                  FontAwesomeIcons.plus,
                ),
              ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ThreadPreviewList(
          channelName: controller.channelName,
          scrollController: controller.scrollController,
        ),
      ),
    );
  }
}
