import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';

import '../../../../../components/iwr_refresh/controller.dart';
import '../../../../../data/enums/result.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../data/models/download_task.dart';
import '../../../../../data/models/media/video.dart';
import '../../../../../data/providers/api_provider.dart';
import '../../../../../data/providers/storage_provider.dart';
import '../../../../../data/services/download_service.dart';
import 'repository.dart';

class DownloadsMediaPreviewListController
    extends IwrRefreshController<MediaDownloadTask> {
  final DownloadMediaPreviewListRepository repository =
      DownloadMediaPreviewListRepository();

  final DownloadService downloadService = Get.find();

  @override
  Future<GroupResult<MediaDownloadTask>> getNewData(int currentPage) async {
    return repository.getDownloadRecords(currentPage);
  }

  Future<void> deleteTaskRecord(String taskId) async {
    await downloadService.deleteTaskRecord(taskId);
  }

  Future<void> deleteVideoTask(int index, String taskId,
      [bool retrying = false]) async {
    String? path = await downloadService.getTaskFilePath(taskId);
    if (!retrying) {
      await StorageProvider.downloadVideoRecords.deleteByIndex(index);
    }
    await deleteTaskRecord(taskId);

    File downloadFile = File(path!);
    if (await downloadFile.exists()) {
      await downloadFile.delete();
    }
    Directory downloadDir = downloadFile.parent;
    if (await downloadDir.exists() && downloadDir.listSync().isEmpty) {
      await downloadDir.delete();
    }

    if (!retrying) data.removeAt(index);
  }

  void onResumed(int index, String newTaskId) {
    data[index].taskId = newTaskId;
  }

  Future<void> retryTask(int index, String taskId) async {
    String? newTaskId;

    MediaDownloadTask mediaTask = data[index];
    DownloadTask? task = await downloadService.getTask(mediaTask.taskId);
    if (task == null) {
      return;
    }

    if (mediaTask.offlineMedia.type == MediaType.video) {
      VideoDownloadTask videoTask = StorageProvider.downloadVideoRecords[index];

      if (videoTask.expireTime <
          DateTime.now().millisecondsSinceEpoch ~/ 1000) {
        VideoModel? video =
            await ApiProvider.getVideo(videoTask.offlineMedia.id).then((value) {
          if (value.success) {
            return value.data! as VideoModel;
          } else {
            return null;
          }
        });

        if (video == null) {
          return;
        }

        String? url = await ApiProvider.getVideoResolutions(
                video.fileUrl!, video.getXVerison())
            .then((value) {
          if (value.success) {
            if (value.data!.isNotEmpty) {
              return value.data!
                  .firstWhere(
                      (element) => element.name == videoTask.resolutionName)
                  .src
                  .downloadUrl;
            }
          }
          return null;
        });

        if (url == null) {
          return;
        }

        deleteVideoTask(index, taskId, true);

        VideoDownloadTask? newTask =
            await downloadService.createVideoDownloadTask(
          url: url,
          resolutionName: videoTask.resolutionName,
          offlineMedia: videoTask.offlineMedia,
        );

        if (newTask == null) {
          return;
        }

        downloadService.refreshTask(taskId, newTask.taskId);

        StorageProvider.downloadVideoRecords.updateWhere(
          (element) => element.taskId == taskId,
          newTask,
        );

        newTaskId = newTask.taskId;
      } else {
        newTaskId = await downloadService.retryTask(taskId);
      }
    }

    if (newTaskId != null) onResumed(index, newTaskId);
  }
}
