import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import 'controller.dart';
import 'widgets/downloads_media_preview_list/widget.dart';

class DownloadsPage extends GetView<DownloadsController> {
  const DownloadsPage({super.key});

  Widget _buildTabBar(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).padding.copyWith(top: 0, bottom: 0),
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: controller.tabController,
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.center,
        splashBorderRadius: BorderRadius.circular(8),
        tabs: [
          Tab(
            text: t.download.finished,
          ),
          Tab(
            text: t.download.downloading,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.user.downloads,
        ),
      ),
      body: Column(
        children: [
          _buildTabBar(context),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                DownloadsMediaPreviewList(
                  showCompleted: true,
                  tag: controller.childrenControllerTags[0],
                ),
                DownloadsMediaPreviewList(
                  tag: controller.childrenControllerTags[1],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
