import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/log_util.dart';
import '../../utils/path_util.dart';
import '../models/download_task.dart';
import '../models/offline/download_task_media.dart';
import '../providers/storage_provider.dart';

class IwrDownloadTaskStatus {
  DownloadTaskStatus status;
  int progress;

  IwrDownloadTaskStatus({required this.status, required this.progress});
}

class DownloadService extends GetxService {
  final int maxDownloadingCount = 5;

  final RxMap<String, Rx<IwrDownloadTaskStatus>> _downloadTasksStatus =
      <String, Rx<IwrDownloadTaskStatus>>{}.obs;

  RxMap<String, Rx<IwrDownloadTaskStatus>> get downloadTasksStatus =>
      _downloadTasksStatus;

  List<DownloadTask> currentTasks = [];

  // Stream for download completion
  RxInt currentDownloading = 0.obs;

  final ReceivePort _port = ReceivePort();
  static const String _portName = 'downloader_send_port';

  @override
  void onInit() {
    super.onInit();

    resetAllowMediaScan();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _getTasksStatusFromRecords();
  }

  @override
  void onClose() {
    _unbindBackgroundIsolate();
    super.onClose();
  }

  void resetAllowMediaScan() {
    allowMediaScan(
      StorageProvider.config
          .get(StorageKey.allowMediaScan, defaultValue: false),
    );
  }

  void _bindBackgroundIsolate() {
    final isSuccess =
        IsolateNameServer.registerPortWithName(_port.sendPort, _portName);

    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }

    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = DownloadTaskStatus.fromInt(data[1]);
      int progress = data[2];

      _downloadTasksStatus[id]!.value = IwrDownloadTaskStatus(
        status: status,
        progress: progress,
      );

      if (status == DownloadTaskStatus.enqueued) {
        currentDownloading++;
      } else if (status == DownloadTaskStatus.complete ||
          status == DownloadTaskStatus.failed ||
          status == DownloadTaskStatus.canceled) {
        currentDownloading--;
      }

      _downloadTasksStatus.refresh();
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(_portName);
  }

  Future<void> allowMediaScan(bool allow) async {
    final downloadPath = downloadDirectory;

    if (downloadPath == null) {
      return;
    }

    final File noMediaFile = File(join(downloadPath, '.nomedia'));

    if (allow && await noMediaFile.exists()) {
      noMediaFile.delete(recursive: true);
    } else if (!allow && !await noMediaFile.exists()) {
      noMediaFile.create(recursive: true);
    }
  }

  String? get downloadDirectory {
    final String? savedDir = StorageProvider.config
        .get(StorageKey.downloadDirectory, defaultValue: null);

    if (savedDir != null) {
      return savedDir;
    }

    return join(PathUtil.getVisibleDir().path, 'downloads');
  }

  // User has chosen a directory that is not in the SAF
  bool get downloadPathInSAF =>
      downloadDirectory != join(PathUtil.getVisibleDir().path, 'downloads');

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName(_portName);
    send?.send([id, status, progress]);
  }

  void _getTasksStatusFromRecords() async {
    var records = await FlutterDownloader.loadTasks() ?? [];

    if (records.isNotEmpty) {
      for (var record in records) {
        _downloadTasksStatus.addAll({
          record.taskId: IwrDownloadTaskStatus(
            status: record.status,
            progress: record.progress,
          ).obs
        });
      }
    }

    _downloadTasksStatus.refresh();
  }

  Future<bool> checkPermission([bool checkExternalStorage = false]) async {
    if (GetPlatform.isMacOS) return true;

    if (GetPlatform.isAndroid) {
      if (checkExternalStorage) {
        try {
          await Permission.manageExternalStorage.request();
          LogUtil.info(await Permission.manageExternalStorage.status);
          if (!await Permission.manageExternalStorage.isGranted) {
            return false;
          }
        } on Exception catch (e) {
          LogUtil.error('Request manageExternalStorage permission failed!', e);
          return false;
        }
      }

      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt > 32) return true;
    }

    try {
      await Permission.storage.request().isGranted;
      LogUtil.info(await Permission.storage.status);
      return await Permission.storage.isGranted;
    } on Exception catch (e) {
      LogUtil.error('Request storage permission failed!', e);
      return false;
    }
  }

  bool checkPermissionForPath(String path) {
    try {
      File file = File(join(path, '.iwrqktest'));
      file.createSync(recursive: true);
      file.deleteSync();
    } on FileSystemException catch (e) {
      LogUtil.error('${'invalidPath'.tr}:$path', e);
      return false;
    }

    return true;
  }

  Future<String?> addDownloadTask({
    required String downloadUrl,
    required String fileName,
    required String subDirectory,
  }) async {
    bool isStorage = await checkPermission(downloadPathInSAF);
    if (!isStorage) {
      SmartDialog.showToast(t.message.download.no_provide_storage_permission);
      return null;
    }
    var records = await FlutterDownloader.loadTasks() ?? [];
    if (records.isNotEmpty) {
      bool hasExisted = records.any((var record) =>
          basename(record.savedDir) == subDirectory &&
          record.filename == fileName);
      if (hasExisted) {
        SmartDialog.showToast(t.message.download.task_already_exists);
        return null;
      }
    }

    String? directory = downloadDirectory;

    if (directory == null) {
      SmartDialog.showToast(t.message.download.no_provide_storage_permission);
      return null;
    }

    String path = join(directory, subDirectory);

    if (!Directory(path).existsSync()) {
      Directory(path).createSync(recursive: true);
    }

    return await FlutterDownloader.enqueue(
      url: downloadUrl,
      fileName: fileName,
      savedDir: path,
      showNotification: false,
      openFileFromNotification: false,
    );
  }

  Future<VideoDownloadTask?> createVideoDownloadTask({
    required String url,
    required String resolutionName,
    required DownloadTaskMediaModel offlineMedia,
  }) async {
    String? downloadTaskId;

    DateTime now = DateTime.now();
    Uri uri = Uri.parse(url);
    int expireTime = int.parse(uri.queryParameters['expires']!);
    String fileName = uri.queryParameters['filename']!;

    await addDownloadTask(
      downloadUrl: url,
      fileName: resolutionName + extension(fileName),
      subDirectory: offlineMedia.title,
    ).then((value) {
      downloadTaskId = value;
    });

    if (downloadTaskId != null) {
      VideoDownloadTask task = VideoDownloadTask(
        taskId: downloadTaskId!,
        createTime: now,
        expireTime: expireTime,
        resolutionName: resolutionName,
        offlineMedia: offlineMedia,
      );
      return task;
    } else {
      return null;
    }
  }

  Future<bool> addVideoDownloadTask({
    required String url,
    required String resolutionName,
    required DownloadTaskMediaModel offlineMedia,
  }) async {
    var task = await createVideoDownloadTask(
      url: url,
      resolutionName: resolutionName,
      offlineMedia: offlineMedia,
    );

    if (task != null) {
      _downloadTasksStatus.addAll({
        task.taskId: IwrDownloadTaskStatus(
          status: DownloadTaskStatus.enqueued,
          progress: 0,
        ).obs
      });

      StorageProvider.downloadVideoRecords.add(task);
      return true;
    } else {
      return false;
    }
  }

  Future<DownloadTask?> getTask(String taskId) async {
    return FlutterDownloader.loadTasksWithRawQuery(
            query: "SELECT * FROM task WHERE task_id = '$taskId'")
        .then((value) {
      List<DownloadTask> result = value ?? [];
      return result.isNotEmpty ? result.first : null;
    });
  }

  Future<int> get currentDownloadingCount async {
    return FlutterDownloader.loadTasksWithRawQuery(
            query:
                "SELECT * FROM task WHERE status = ${DownloadTaskStatus.running.index}")
        .then((value) {
      List<DownloadTask> result = value ?? [];
      return result.length;
    });
  }

  Future<String?> getTaskFilePath(String taskId) async {
    return getTask(taskId).then((value) {
      if (value == null) {
        return null;
      }
      return join(value.savedDir, value.filename!);
    });
  }

  Future<void> pauseTask(String taskId) {
    return FlutterDownloader.pause(taskId: taskId);
  }

  void refreshTask(String taskId, String newTaskId) {
    _downloadTasksStatus.addAll({
      newTaskId: IwrDownloadTaskStatus(
        status: DownloadTaskStatus.enqueued,
        progress: 0,
      ).obs
    });

    _downloadTasksStatus.remove(taskId);
    _downloadTasksStatus.refresh();
  }

  Future<String?> resumeTask(String taskId) async {
    String? newTaskId = await FlutterDownloader.resume(taskId: taskId);
    if (newTaskId != null) {
      refreshTask(taskId, newTaskId);

      VideoDownloadTask task = StorageProvider.downloadVideoRecords
          .get()
          .firstWhere((element) => element.taskId == taskId);

      VideoDownloadTask newTask = VideoDownloadTask(
        taskId: newTaskId,
        createTime: task.createTime,
        expireTime: task.expireTime,
        resolutionName: task.resolutionName,
        offlineMedia: task.offlineMedia,
      );

      StorageProvider.downloadVideoRecords.updateWhere(
        (element) => element.taskId == taskId,
        newTask,
      );

      return newTaskId;
    }
    return null;
  }

  Future<String?> retryTask(String taskId) async {
    String? newTaskId = await FlutterDownloader.retry(taskId: taskId);
    if (newTaskId != null) {
      refreshTask(taskId, newTaskId);

      VideoDownloadTask task = StorageProvider.downloadVideoRecords
          .get()
          .firstWhere((element) => element.taskId == taskId);

      VideoDownloadTask newTask = VideoDownloadTask(
        taskId: newTaskId,
        createTime: task.createTime,
        expireTime: task.expireTime,
        resolutionName: task.resolutionName,
        offlineMedia: task.offlineMedia,
      );

      StorageProvider.downloadVideoRecords.updateWhere(
        (element) => element.taskId == taskId,
        newTask,
      );

      return newTaskId;
    }
    return null;
  }

  Future<void> cancelTask(String taskId) {
    return FlutterDownloader.cancel(taskId: taskId);
  }

  Future<void> deleteTaskRecord(String taskId) async {
    await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: false);
  }
}
