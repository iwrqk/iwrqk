import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums/types.dart';
import '../../../data/models/account/settings/filter_setting.dart';
import '../../../data/models/account/settings/media_search_setting.dart';
import '../../../data/models/account/settings/media_sort_setting.dart';
import '../../iwr_refresh/widget.dart';
import '../media_flat_preview.dart';
import 'controller.dart';
import '../media_preview.dart';

class MediaPreviewGrid extends StatefulWidget {
  final MediaSourceType sourceType;
  final MediaSortSettingModel? sortSetting;
  final FilterSettingModel? filterSetting;
  final String? uploaderName;
  final String tag;
  final ScrollController? scrollController;
  final MediaSearchSettingModel? searchSetting;
  final bool applyFilter;
  final bool isHorizontal;

  MediaPreviewGrid({
    required this.sourceType,
    this.sortSetting,
    this.uploaderName,
    this.filterSetting,
    required this.tag,
    this.scrollController,
    this.searchSetting,
    this.applyFilter = false,
    this.isHorizontal = false,
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
      sortSetting: widget.sortSetting,
      sourceType: widget.sourceType,
      searchSetting: widget.searchSetting,
      applyFilter: widget.applyFilter,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool requireLogin = false;

    if (widget.sourceType == MediaSourceType.subscribedVideos ||
        widget.sourceType == MediaSourceType.subscribedImages) {
      requireLogin = true;
    }

    return IwrRefresh(
      requireLogin: requireLogin,
      controller: _controller,
      scrollController: widget.scrollController,
      builder: (data, scrollController) {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            if (widget.isHorizontal)
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return MediaFlatPreview(media: data[index]);
                  },
                  childCount: data.length,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: Obx(
                  () => SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return MediaPreview(
                          media: data[index],
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
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
