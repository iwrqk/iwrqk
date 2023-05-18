import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../../../../l10n.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../global_widgets/sliver_refresh/widget.dart';
import '../../controller.dart';
import '../download_media_preview.dart';
import 'controller.dart';

class DownloadsMediaPreviewList extends StatefulWidget {
  final MediaType filterType;
  final String tag;

  const DownloadsMediaPreviewList(
      {super.key, required this.filterType, required this.tag});

  @override
  State<DownloadsMediaPreviewList> createState() =>
      _DownloadsMediaPreviewListState();
}

class _DownloadsMediaPreviewListState extends State<DownloadsMediaPreviewList>
    with AutomaticKeepAliveClientMixin {
  final DownloadsController _parentController = Get.find();
  late DownloadsMediaPreviewListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller =
        Get.find<DownloadsMediaPreviewListController>(tag: widget.tag);
    _controller.initConfig(widget.filterType);
    _parentController.childrenControllers[widget.tag] = _controller;
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
            (context, index) {
              reachBottomCallback(index);

              final item = _controller.data[index];

              Widget child = Dismissible(
                key: Key(item.offlineMeida.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _controller.deleteVideoTask(
                    index,
                    DownloadTask.fromJsonMap(item.task).taskId,
                  );
                },
                background: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        L10n.of(context).delete,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                child: SizedBox(
                    height: 100,
                    child: DownloadMediaPreview(
                      taskData: item,
                    )),
              );

              return FrameSeparateWidget(
                index: index,
                placeHolder: Container(
                  height: 100,
                  color: Theme.of(context).canvasColor,
                ),
                child: child,
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
