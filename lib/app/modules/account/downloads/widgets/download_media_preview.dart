import 'package:auto_size_text/auto_size_text.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../core/utils/display_util.dart';
import '../../../../data/enums/types.dart';
import '../../../../data/models/download_task.dart';
import '../../../../data/services/download_service.dart';
import '../../../../global_widgets/reloadable_image.dart';

class DownloadMediaPreview extends StatelessWidget {
  final MediaDownloadTask taskData;
  final DownloadService _downloadService = Get.find();

  DownloadMediaPreview({
    Key? key,
    required this.taskData,
  }) : super(key: key);

  Widget _buildRating() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (taskData.offlineMeida.ratingType == "ecchi")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5),
              color: Colors.red.withAlpha(175),
            ),
            height: 25,
            child: const Center(
                child: Text(
              "R-18",
              style: TextStyle(fontSize: 12.5, color: Colors.white),
            )),
          ),
      ],
    );
  }

  Widget _buildDurationGallery() {
    Duration? duration;

    if (taskData.offlineMeida.duration != null) {
      duration = Duration(seconds: taskData.offlineMeida.duration!);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (taskData is VideoDownloadTask)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5),
              color: Colors.black.withAlpha(175),
            ),
            height: 25,
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.film,
                  size: 12.5,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 2),
                  child: Text(
                    (taskData as VideoDownloadTask).resolutionName,
                    style: const TextStyle(fontSize: 12.5, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        if (duration != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5),
              color: Colors.black.withAlpha(175),
            ),
            height: 25,
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.play,
                  size: 12.5,
                  color: Colors.white,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 2),
                  child: Text(
                    "${duration.inMinutes}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 12.5, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        if (taskData.offlineMeida.galleryLength != null)
          if (taskData.offlineMeida.galleryLength! > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.black.withAlpha(175),
              ),
              height: 25,
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.solidImages,
                    size: 12.5,
                    color: Colors.white,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 2),
                    child: Text(
                      "${taskData.offlineMeida.galleryLength}",
                      style: const TextStyle(fontSize: 12.5, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildStateMessageWithProgress(String message, double progress) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: AutoSizeText(
            message,
            maxLines: 1,
            style: const TextStyle(
              fontSize: 12.5,
              color: Colors.grey,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        LinearProgressIndicator(
          value: progress,
        )
      ],
    );
  }

  Widget _buildCompleteWidget() {
    String totalSize =
        DisplayUtil.getDisplayFileSizeWithUnit(taskData.offlineMeida.size);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Row(
                  children: [
                    const SizedBox(
                      width: 20,
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.solidUser,
                          size: 15,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: const EdgeInsets.only(left: 2, right: 2),
                        child: Text(
                          taskData.offlineMeida.uploader.name,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(
              width: 20,
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.download,
                  size: 12.5,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 2),
                child: Text(
                  DisplayUtil.getDisplayDate(taskData.createTime),
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            AutoSizeText(
              totalSize,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12.5,
                color: Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildStateWidget() {
    return Obx(() {
      DownloadTask downloadTask = DownloadTask.fromJsonMap(taskData.task);
      String taskId = downloadTask.taskId;
      var taskStatus = _downloadService.downloadTasksStatus[taskId];
      if (taskStatus != null) {
        int downloadedSize =
            (taskData.offlineMeida.size * taskStatus.value.progress).toInt();
        int totalSize = taskData.offlineMeida.size;
        switch (taskStatus.value.status) {
          case TaskStatus.running:
            return GestureDetector(
              excludeFromSemantics: true,
              onTap: () {
                _downloadService.pauseTask(downloadTask).then((value) {
                  debugPrint(value.toString());
                });
              },
              child: _buildStateMessageWithProgress(
                "Downloading ${DisplayUtil.getDownloadFileSizeProgress(downloadedSize, totalSize)}",
                taskStatus.value.progress,
              ),
            );
          case TaskStatus.paused:
            return GestureDetector(
              excludeFromSemantics: true,
              onTap: () {
                _downloadService.resumeTask(downloadTask).then((value) {
                  debugPrint(value.toString());
                });
              },
              child: _buildStateMessageWithProgress(
                "Paused ${DisplayUtil.getDownloadFileSizeProgress(downloadedSize, totalSize)}",
                taskStatus.value.progress,
              ),
            );
          case TaskStatus.failed:
            return _buildStateMessageWithProgress(
              "Failed",
              0,
            );
          case TaskStatus.complete:
            return _buildCompleteWidget();
          default:
            return const SizedBox.shrink();
        }
      } else {
        return const AutoSizeText(
          "Unknow",
          maxLines: 1,
          style: TextStyle(
            fontSize: 12.5,
            color: Colors.red,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }
    });
  }

  List<Widget> _buildFullVerison(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: taskData.offlineMeida.coverUrl != null
                      ? ReloadableImage(
                          imageUrl: taskData.offlineMeida.coverUrl!,
                          aspectRatio: 16 / 9,
                          fit: BoxFit.cover,
                          isAdult: taskData.offlineMeida.ratingType ==
                              RatingType.ecchi.value,
                        )
                      : const AspectRatio(aspectRatio: 16 / 9),
                )),
            Positioned(left: 5, bottom: 5, child: _buildRating()),
            Positioned(
                right: 5, top: 5, bottom: 5, child: _buildDurationGallery()),
          ],
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                taskData.offlineMeida.title,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12.5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: _buildStateWidget(),
              )
            ],
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: _buildFullVerison(context),
        ),
      ),
      onTap: () {
        //
      },
    );
  }
}
