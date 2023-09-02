import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

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
    return SizeCacheWidget(
      child: SliverRefresh(
        controller: _controller,
        scrollController: _scrollController,
        builder: (data, reachBottomCallback) {
          return Obx(
            () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  reachBottomCallback(index);

                  final item = _controller.data[index];

                  late Widget child;

                  return Obx(() {
                    final DownloadTaskStatus status = _controller
                            .downloadService
                            .downloadTasksStatus[item.taskId]
                            ?.value
                            .status ??
                        DownloadTaskStatus.undefined;

                    if (widget.isPlaylist ||
                        status == DownloadTaskStatus.enqueued ||
                        status == DownloadTaskStatus.running ||
                        status == DownloadTaskStatus.paused) {
                      child = Container(
                        height: 100,
                        color: widget.currentMediaId == item.offlineMedia.id
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : null,
                        child: DownloadMediaPreview(
                          taskData: item,
                          onResumed: (newTaskId) {
                            _controller.onResumed(index, newTaskId);
                          },
                          customOnTap:
                              widget.currentMediaId == item.offlineMedia.id
                                  ? null
                                  : widget.onChangeVideo,
                        ),
                      );
                    } else {
                      child = Slidable(
                        key: Key(item.offlineMedia.id),
                        startActionPane: status != DownloadTaskStatus.complete
                            ? null
                            : ActionPane(
                                motion: const DrawerMotion(),
                                extentRatio: 0.5,
                                children: [
                                  SlidableAction(
                                    flex: 1,
                                    onPressed: (context) async {
                                      OpenFile.open(
                                          (await _controller.downloadService
                                              .getTaskFilePath(item.taskId))!,
                                          type: item.offlineMedia.type ==
                                                  MediaType.video
                                              ? 'video/mp4'
                                              : 'image/png',
                                          uti: item.offlineMedia.type ==
                                                  MediaType.video
                                              ? 'public.mpeg-4'
                                              : 'public.png');
                                    },
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    icon: FontAwesomeIcons.folderOpen,
                                    label: L10n.of(context).open,
                                  ),
                                  SlidableAction(
                                    flex: 1,
                                    onPressed: (context) async {
                                      Share.shareXFiles([
                                        XFile(
                                            (await _controller.downloadService
                                                .getTaskFilePath(item.taskId))!,
                                            mimeType: item.offlineMedia.type ==
                                                    MediaType.video
                                                ? 'video/mp4'
                                                : 'image/png')
                                      ]);
                                    },
                                    backgroundColor: Colors.lightBlue,
                                    foregroundColor: Colors.white,
                                    icon: FontAwesomeIcons.shareFromSquare,
                                    label: L10n.of(context).export,
                                  ),
                                ],
                              ),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: status == DownloadTaskStatus.complete
                              ? 0.25
                              : 0.5,
                          children: [
                            if (status == DownloadTaskStatus.failed ||
                                status == DownloadTaskStatus.canceled ||
                                status == DownloadTaskStatus.undefined)
                              SlidableAction(
                                flex: 1,
                                onPressed: (context) async {
                                  await _controller.retryTask(
                                    index,
                                    item.taskId,
                                  );
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: FontAwesomeIcons.arrowRotateLeft,
                                label: L10n.of(context).retry,
                              ),
                            SlidableAction(
                              flex: 1,
                              onPressed: (context) async {
                                await _controller.deleteVideoTask(
                                  index,
                                  item.taskId,
                                );
                              },
                              backgroundColor: Colors.red.shade700,
                              foregroundColor: Colors.white,
                              icon: FontAwesomeIcons.trashCan,
                              label: L10n.of(context).delete,
                            ),
                          ],
                        ),
                        child: SizedBox(
                          height: 100,
                          child: DownloadMediaPreview(
                            taskData: item,
                            onResumed: (newTaskId) {
                              _controller.onResumed(index, newTaskId);
                            },
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
                  });
                },
                childCount: data.length,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
