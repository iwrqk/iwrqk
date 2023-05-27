import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../data/enums/types.dart';
import '../../../data/models/settings/users_sort_setting.dart';
import '../../sliver_refresh/widget.dart';
import '../user_preview.dart';
import 'controller.dart';

class UsersPreviewList extends StatefulWidget {
  final UsersSourceType sourceType;
  final UsersSortSetting sortSetting;
  final String tag;

  UsersPreviewList({
    required this.sourceType,
    required this.sortSetting,
    required this.tag,
  }) : super(key: PageStorageKey<String>(tag));

  @override
  State<StatefulWidget> createState() => _UsersPreviewListState();
}

class _UsersPreviewListState extends State<UsersPreviewList>
    with AutomaticKeepAliveClientMixin {
  late UsersPreviewListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<UsersPreviewListController>(tag: widget.tag);
    _controller.initConfig(widget.sortSetting, widget.sourceType);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoScrollbar(
      controller: _scrollController,
      child: SliverRefresh(
        controller: _controller,
        scrollController: _scrollController,
        builder: (data, reachBottomCallback) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                reachBottomCallback(index);

                return FrameSeparateWidget(
                  index: index,
                  placeHolder: const SizedBox(height: 100),
                  child: Container(
                    color: Theme.of(context).canvasColor,
                    height: 100,
                    child: UserPreview(
                      user: data[index],
                    ),
                  ),
                );
              },
              childCount: data.length,
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
