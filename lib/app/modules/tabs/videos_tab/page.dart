import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums/types.dart';
import '../media_grid_tab/page.dart';
import 'controller.dart';

class VideosTabPage extends GetView<VideosTabController> {
  final String tabTag;

  const VideosTabPage({
    Key? key,
    required this.tabTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.init(context, tabTag);
    return MediaGridTabPage(
      tag: controller.tag,
      tabNameList: controller.tabNameList,
      tabTagList: controller.tabTagList,
      sourceType: MediaSourceType.videos,
      orderTypeList: controller.orderTypeList,
    );
  }
}
