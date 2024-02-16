import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../components/iwr_refresh/widget.dart';
import '../../../../../data/models/download_task.dart';
import '../../controller.dart';
import '../download_media_preview.dart';
import '../download_task_dialog.dart';
import 'controller.dart';

class DownloadsMediaPreviewList extends StatefulWidget {
  final bool showCompleted;
  final String tag;
  final bool isPlaylist;
  final String? initialMediaId;
  final Function(MediaDownloadTask data)? onChangeVideo;

  const DownloadsMediaPreviewList({
    super.key,
    this.showCompleted = false,
    required this.tag,
    this.isPlaylist = false,
    this.initialMediaId,
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

  RxString currentMediaId = "".obs;

  @override
  void initState() {
    super.initState();
    currentMediaId.value = widget.initialMediaId ?? "";
    _controller =
        Get.find<DownloadsMediaPreviewListController>(tag: widget.tag);
    _parentController.childrenControllers[widget.tag] = _controller;

    _controller.downloadService.currentDownloading.listen((event) {
      Get.engine.addPostFrameCallback((_) {
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return IwrRefresh(
      controller: _controller,
      scrollController: _scrollController,
      builder: (data, scrollController) {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            Obx(
              () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _controller.data[index];

                    return Obx(() {
                      final DownloadTaskStatus status = _controller
                              .downloadService
                              .downloadTasksStatus[item.taskId]
                              ?.value
                              .status ??
                          DownloadTaskStatus.undefined;

                      if (status != DownloadTaskStatus.complete &&
                          widget.showCompleted) {
                        return const SizedBox.shrink();
                      } else if (status == DownloadTaskStatus.complete &&
                          !widget.showCompleted) {
                        return const SizedBox.shrink();
                      }

                      if (widget.isPlaylist) {
                        return Obx(
                          () => DownloadMediaPreview(
                            onTap: () {
                              if (widget.onChangeVideo != null) {
                                widget.onChangeVideo!(item);
                                currentMediaId.value = item.offlineMedia.id;
                              }
                            },
                            taskData: item,
                            isPlaying:
                                currentMediaId.value == item.offlineMedia.id,
                            isPlaylist: true,
                          ),
                        );
                      }

                      void gotoPlayer() {
                        Get.toNamed(
                          "/mediaDetail?id=${item.offlineMedia.id}&isOffline=true",
                          arguments: {
                            "mediaType": item.offlineMedia.type,
                            "taskData": item,
                          },
                        );
                      }

                      void gotoDetail() {
                        Get.toNamed(
                          "/mediaDetail?id=${item.offlineMedia.id}",
                          arguments: {
                            "mediaType": item.offlineMedia.type,
                          },
                        );
                      }

                      void popupDialog() {
                        Get.dialog(DownloadTaskDialog(
                          taskData: item,
                          onPaused: (taskId) {
                            _controller.downloadService.pauseTask(taskId);
                          },
                          onResumed: (taskId) {
                            return _controller.downloadService
                                .resumeTask(taskId)
                                .then((newTaskId) {
                              if (newTaskId != null) {
                                _controller.onResumed(index, newTaskId);
                                return newTaskId;
                              }
                              return null;
                            });
                          },
                          onRetry: (taskId) async {
                            await _controller.retryTask(
                              index,
                              item.taskId,
                            );
                          },
                          onDeleted: (taskId) async {
                            await _controller.deleteVideoTask(
                              index,
                              item.taskId,
                            );
                          },
                          onOpen: (taskId) async {
                            OpenFile.open(
                                (await _controller.downloadService
                                    .getTaskFilePath(item.taskId))!,
                                type: 'video/mp4',
                                uti: 'public.mpeg-4');
                          },
                          onShare: (taskId) async {
                            Share.shareXFiles([
                              XFile(
                                  (await _controller.downloadService
                                      .getTaskFilePath(item.taskId))!,
                                  mimeType: 'video/mp4')
                            ]);
                          },
                          gotoPlayer: gotoPlayer,
                          gotoDetail: gotoDetail,
                        ));
                      }

                      return DownloadMediaPreview(
                        onTap: popupDialog,
                        gotoDetail: gotoDetail,
                        taskData: item,
                      );
                    });
                  },
                  childCount: data.length,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
