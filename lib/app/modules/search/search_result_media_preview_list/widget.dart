import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../data/enums/types.dart';
import '../../../global_widgets/media_preview/media_flat_preview.dart';
import '../../../global_widgets/sliver_refresh/widget.dart';
import '../normal_search_result/controller.dart';
import 'controller.dart';

class SearchResultMediaPreviewList extends StatefulWidget {
  final MediaType type;
  final String tag;
  final String initKeyword;

  SearchResultMediaPreviewList({
    required this.type,
    required this.tag,
    required this.initKeyword,
  }) : super(key: PageStorageKey<String>(tag));

  @override
  State<SearchResultMediaPreviewList> createState() =>
      _SearchResultMediaPreviewListState();
}

class _SearchResultMediaPreviewListState
    extends State<SearchResultMediaPreviewList>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  late SearchResultMediaPreviewListController _controller;
  final NormalSearchResultController _parentController = Get.find();

  @override
  void initState() {
    super.initState();
    _controller =
        Get.find<SearchResultMediaPreviewListController>(tag: widget.tag);
    _parentController.childrenControllers[widget.tag] = _controller;
    _controller.initConfig(widget.type, widget.initKeyword);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverRefresh(
      controller: _controller,
      scrollController: _scrollController,
      builder: (data, reachBottomCallback) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              reachBottomCallback(index);

              return FrameSeparateWidget(
                index: index,
                placeHolder: Container(
                  height: 100,
                  color: Theme.of(context).canvasColor,
                ),
                child: SizedBox(
                  height: 100,
                  child: MediaFlatPreview(
                    media: data[index],
                  ),
                ),
              );
            },
            childCount: data.length,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
