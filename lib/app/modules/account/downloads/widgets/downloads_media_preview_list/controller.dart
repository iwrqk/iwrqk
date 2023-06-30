import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:get/get.dart';

import '../../../../../data/enums/result.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../data/models/download_task.dart';
import '../../../../../data/providers/storage_provider.dart';
import '../../../../../data/services/download_service.dart';
import '../../../../../global_widgets/sliver_refresh/controller.dart';
import 'repository.dart';

class DownloadsMediaPreviewListController
    extends SliverRefreshController<MediaDownloadTask> {
  final DownloadMediaPreviewListRepository repository =
      DownloadMediaPreviewListRepository();

  final DownloadService _downloadService = Get.find();

  late MediaType _filterType;

  void initConfig(MediaType filterType) {
    _filterType = filterType;
  }

  @override
  Future<GroupResult<MediaDownloadTask>> getNewData(int currentPage) async {
    return repository.getDownloadRecords(currentPage, _filterType);
  }

  Future<void> deleteTaskRecord(String taskId) async {
    await _downloadService.deleteTaskRecord(taskId);
  }

  Future<void> deleteVideoTask(int index, String taskId) async {
    MediaDownloadTask taskData = data[index];
    DownloadTask downloadTask = taskData.downloadTask;
    await StorageProvider.deleteDownloadVideoRecord(index);
    await deleteTaskRecord(taskId);

    File downloadFile = File(await downloadTask.filePath());
    if (await downloadFile.exists()) {
      await downloadFile.delete();
    }
    Directory downloadDir = downloadFile.parent;
    if (await downloadDir.exists()) {
      await downloadDir.delete();
    }

    data.removeAt(index);
  }
}
