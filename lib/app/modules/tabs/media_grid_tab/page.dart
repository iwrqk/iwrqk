import 'package:flutter/material.dart';
import 'package:keframe/keframe.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../data/enums/types.dart';
import '../../../data/models/account/settings/media_sort_setting.dart';
import '../../../global_widgets/media_preview/media_preview_grid/widget.dart';
import '../../../global_widgets/tab_indicator.dart';
import 'controller.dart';

class MediaGridTabPage extends StatefulWidget {
  final String tag;
  final bool showFilter;
  final List<String> tabNameList;
  final List<String> tabTagList;
  final List<OrderType>? orderTypeList;
  final MediaSourceType? sourceType;
  final List<MediaSourceType>? customSourceTypeList;

  const MediaGridTabPage({
    Key? key,
    this.showFilter = true,
    required this.tag,
    required this.tabNameList,
    required this.tabTagList,
    this.orderTypeList,
    this.sourceType,
    this.customSourceTypeList,
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
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      padding: MediaQuery.of(context).padding.copyWith(bottom: 0, top: 0),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: TabBar(
              isScrollable: true,
              physics: const BouncingScrollPhysics(),
              controller: _controller.tabController,
              indicator: TabIndicator(context),
              indicatorSize: TabBarIndicatorSize.label,
              tabs: widget.tabNameList
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList(),
              onTap: (value) {},
            ),
          ),
          Visibility(
            visible: widget.showFilter,
            child: IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.sliders,
                size: 20,
              ),
              color: Colors.grey,
              onPressed: () {
                _controller.popFilterDialog();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          _buildTabBar(context),
          Expanded(
            child: SafeArea(
              top: false,
              bottom: false,
              child: SizeCacheWidget(
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
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
