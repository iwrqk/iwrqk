import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums/types.dart';
import '../media_grid_tab/page.dart';
import 'controller.dart';

class SubscriptionTabPage extends GetView<SubscriptionTabController> {
  final String tabTag;

  const SubscriptionTabPage({
    Key? key,
    required this.tabTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.init(tabTag);
    return MediaGridTabPage(
      tag: controller.tag,
      showFilter: false,
      tabNameList: controller.tabNameList,
      tabTagList: controller.tabTagList,
      customSourceTypeList: const [
        MediaSourceType.subscribedVideos,
        MediaSourceType.subscribedImages
      ],
      tabAlignment: TabAlignment.center,
    );
  }
}
