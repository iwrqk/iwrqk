import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../data/enums/types.dart';
import '../../../data/models/account/settings/filter_setting.dart';
import '../../../data/models/account/settings/media_sort_setting.dart';
import '../../placeholders/media_preview.dart';
import '../../sliver_refresh/widget.dart';
import 'controller.dart';
import '../media_preview.dart';

class MediaPreviewGrid extends StatefulWidget {
  final MediaSourceType sourceType;
  final MediaSortSettingModel sortSetting;
  final FilterSettingModel? filterSetting;
  final String? uploaderName;
  final String tag;
  final ScrollController? scrollController;
  final bool applyFilter;

  MediaPreviewGrid({
    required this.sourceType,
    required this.sortSetting,
    this.uploaderName,
    this.filterSetting,
    required this.tag,
    this.scrollController,
    this.applyFilter = false,
  }) : super(key: PageStorageKey<String>(tag));

  @override
  State<MediaPreviewGrid> createState() => _MediaPreviewGridState();
}

class _MediaPreviewGridState extends State<MediaPreviewGrid>
    with AutomaticKeepAliveClientMixin {
  late MediaPreviewGridController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MediaPreviewGridController>(tag: widget.tag);
    _controller.initConfig(
        widget.sortSetting, widget.sourceType, widget.applyFilter);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool requireLogin = false;

    if (widget.sourceType == MediaSourceType.subscribedVideos ||
        widget.sourceType == MediaSourceType.subscribedImages) {
      requireLogin = true;
    }

    return SliverRefresh(
      requireLogin: requireLogin,
      controller: _controller,
      scrollController: widget.scrollController,
      builder: (data, reachBottomCallback) {
        return Obx(() {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  reachBottomCallback(index);

                  return FrameSeparateWidget(
                    index: index,
                    placeHolder: const MediaPreviewPlaceholder(),
                    child: MediaPreview(
                      media: data[index],
                    ),
                  );
                },
                childCount: data.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio:
                    _controller.configService.gridChildAspectRatio,
                crossAxisCount: _controller.configService.crossAxisCount,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            ),
          );
        });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
