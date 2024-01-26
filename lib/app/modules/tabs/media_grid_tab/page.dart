import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/media_preview/media_preview_grid/widget.dart';
import '../../../data/enums/types.dart';
import '../../../data/models/account/settings/media_sort_setting.dart';
import 'controller.dart';
import 'widgets/filter_page/widget.dart';

class MediaGridTabPage extends StatefulWidget {
  final String tag;
  final bool showFilter;
  final List<String> tabNameList;
  final List<String> tabTagList;
  final List<OrderType>? orderTypeList;
  final MediaSourceType? sourceType;
  final List<MediaSourceType>? customSourceTypeList;
  final TabAlignment tabAlignment;

  const MediaGridTabPage({
    Key? key,
    this.showFilter = true,
    required this.tag,
    required this.tabNameList,
    required this.tabTagList,
    this.orderTypeList,
    this.sourceType,
    this.customSourceTypeList,
    this.tabAlignment = TabAlignment.start,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MediaGridTabPageState();
}

class _MediaGridTabPageState extends State<MediaGridTabPage>
    with AutomaticKeepAliveClientMixin {
  late MediaGridTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<MediaGridTabController>(tag: widget.tag);
    _controller.init(tagList: widget.tabTagList);
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).padding.copyWith(bottom: 0),
      alignment: Alignment.centerLeft,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Material(
                child: TabBar(
                  tabAlignment: widget.tabAlignment,
                  isScrollable: true,
                  controller: _controller.tabController,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.label,
                  splashBorderRadius: BorderRadius.circular(8),
                  tabs: widget.tabNameList
                      .map((e) => Tab(
                            text: e,
                          ))
                      .toList(),
                ),
              ),
            ),
            Visibility(
              visible: widget.showFilter,
              child: FilterPage(
                targetTag: widget.tag,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _buildTabBar(context),
        Expanded(
          child: SafeArea(
            top: false,
            bottom: false,
            child: TabBarView(
              controller: _controller.tabController,
              children: List.generate(
                widget.tabTagList.length,
                (index) => MediaPreviewGrid(
                  sourceType: widget.sourceType == null
                      ? widget.customSourceTypeList![index]
                      : widget.sourceType!,
                  sortSetting: MediaSortSettingModel(
                      orderType: widget.orderTypeList == null
                          ? null
                          : widget.orderTypeList![index]),
                  tag: widget.tabTagList[index],
                  scrollController: _controller.scrollControllers[index],
                  applyFilter: true,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
