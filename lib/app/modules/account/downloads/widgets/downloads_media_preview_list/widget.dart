import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';
import 'package:open_file/open_file.dart';

import '../../../../../../l10n.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../data/models/download_task.dart';
import '../../../../../global_widgets/placeholders/media_flat_preview.dart';
import '../../../../../global_widgets/sliver_refresh/widget.dart';
import '../../controller.dart';
import '../download_media_preview.dart';
import 'controller.dart';

class DownloadsMediaPreviewList extends StatefulWidget {
  final MediaType filterType;
  final String tag;
  final bool isPlaylist;
  final String? currentMediaId;
  final Function(MediaDownloadTask data)? onChangeVideo;

  const DownloadsMediaPreviewList({
    super.key,
    required this.filterType,
    required this.tag,
    this.isPlaylist = false,
    this.currentMediaId,
    this.onChangeVideo,
  });

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

              late Widget child;

              if (widget.isPlaylist) {
                child = Container(
                  height: 100,
                  color: widget.currentMediaId == item.offlineMedia.id
                      ? Theme.of(context).primaryColor.withOpacity(0.1)
                      : null,
                  child: DownloadMediaPreview(
                    taskData: item,
                    customOnTap: widget.currentMediaId == item.offlineMedia.id
                        ? null
                        : widget.onChangeVideo,
                  ),
                );
              } else {
                child = Dismissible(
                  key: Key(item.offlineMedia.id),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    _controller.deleteVideoTask(
                      index,
                      DownloadTask.fromJsonMap(item.task).taskId,
                    );
                  },
                  confirmDismiss: (direction) async {
                    if (direction != DismissDirection.endToStart) {
                      OpenFile.open(await item.downloadTask.filePath(),
                          type: item.offlineMedia.type == MediaType.video
                              ? 'video/mp4'
                              : 'image/png',
                          uti: item.offlineMedia.type == MediaType.video
                              ? 'public.mpeg-4'
                              : 'public.png');
                      return false;
                    }
                    return true;
                  },
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          L10n.of(context).delete,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  background: Container(
                    color: Colors.blue,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          L10n.of(context).export,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    height: 100,
                    child: DownloadMediaPreview(
                      taskData: item,
                    ),
                  ),
                );
              }

              return FrameSeparateWidget(
                index: index,
                placeHolder: const SizedBox(
                  height: 100,
                  child: MediaFlatPreviewPlaceholder(),
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
