import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/media_preview/media_preview_grid/widget.dart';
import '../../../components/network_image.dart';
import '../../../data/models/account/settings/media_sort_setting.dart';
import 'controller.dart';

class UploadedMediaPage extends GetView<UploadedMediaController> {
  const UploadedMediaPage({Key? key}) : super(key: key);

  Widget _buildTabBar(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).padding.copyWith(bottom: 0, top: 4),
      alignment: Alignment.centerLeft,
      child: TabBar(
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        splashBorderRadius: BorderRadius.circular(8),
        tabs: controller.tabNameList
            .map((e) => Tab(
                  text: e,
                ))
            .toList(),
      ),
    );
  }

  Widget _buildTitle() {
    return ListTile(
      leading: ClipOval(
        child: NetworkImg(
          imageUrl: controller.user.avatarUrl,
          width: 40,
          height: 40,
        ),
      ),
      title: Text(
        controller.user.name,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: _buildTitle(),
        titleSpacing: 0,
      ),
      body: DefaultTabController(
        length: controller.tabNameList.length,
        child: Column(
          children: [
            _buildTabBar(context),
            Expanded(
              child: TabBarView(
                children: List.generate(
                  controller.tabNameList.length,
                  (index) => MediaPreviewGrid(
                    tag: controller.tabTagList[index],
                    sourceType: controller.sourceType,
                    sortSetting: MediaSortSettingModel(
                      orderType: controller.orderTypeList[index],
                      userId: controller.user.id,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
