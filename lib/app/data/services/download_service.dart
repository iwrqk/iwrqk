import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/utils/display_util.dart';
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

  final ReceivePort _port = ReceivePort();
  static const String _portName = 'downloader_send_port';

  @override
  void onInit() {
    super.onInit();

    _bindBackgroundIsolate();

    FlutterDownloader.registerCallback(downloadCallback);

    _getTasksStatusFromRecords();
  }

  @override
  void onClose() {
    _unbindBackgroundIsolate();
    super.onClose();
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

      _downloadTasksStatus.refresh();
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping(_portName);
  }

  Future<Directory?> get downloadDirectory async {
    if (GetPlatform.isAndroid) {
      return getExternalStorageDirectory();
    } else if (GetPlatform.isIOS) {
      return getApplicationDocumentsDirectory();
    } else {
      return getApplicationDocumentsDirectory();
    }
  }

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

  Future<bool> _checkPermission() async {
    if (GetPlatform.isAndroid) {
      AndroidDeviceInfo androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt < 12) {
        await Permission.storage.request();
        return await Permission.storage.isGranted;
      } else {
        return true;
      }
    } else if (GetPlatform.isIOS) {
      await Permission.storage.request();
      return await Permission.storage.isGranted;
    }
    return false;
  }

  Future<String?> addDownloadTask({
    required String downloadUrl,
    required String fileName,
    required String subDirectory,
  }) async {
    bool isStorage = await _checkPermission();
    if (!isStorage) {
      showToast(DisplayUtil.messageNoStoragePermission);
      return null;
    }
    var records = await FlutterDownloader.loadTasks() ?? [];
    if (records.isNotEmpty) {
      bool hasExisted =
          records.any((var record) => record.filename == fileName);
      if (hasExisted) {
        showToast(DisplayUtil.messageDownloadTaskAlreadyExist);
        return null;
      }
    }

    String directory = await downloadDirectory.then((value) => value!.path);

    String path = join(directory, "downloads", subDirectory);
    Directory(path).createSync(recursive: true);

    return await FlutterDownloader.enqueue(
      url: downloadUrl,
      fileName: fileName,
      savedDir: path,
      showNotification: false,
      openFileFromNotification: false,
    );
  }

  Future<bool> addVideoDownloadTask({
    required String url,
    required String resolutionName,
    required DownloadTaskMediaModel offlineMedia,
  }) async {
    String? downloadTaskId;

    DateTime now = DateTime.now();
    Uri uri = Uri.parse(url);
    int expireTime = int.parse(uri.queryParameters['expires']!);
    String fileName = uri.queryParameters['filename']!;

    if (!GetPlatform.isIOS) {
      fileName = fileName.split(".").first;
    }

    await addDownloadTask(
      downloadUrl: url,
      fileName: fileName,
      subDirectory: join("videos", offlineMedia.id),
    ).then((value) {
      downloadTaskId = value;
    });

    if (downloadTaskId != null) {
      var task = VideoDownloadTask(
        taskId: downloadTaskId!,
        createTime: now,
        expireTime: expireTime,
        resolutionName: resolutionName,
        offlineMedia: offlineMedia,
      );

      _downloadTasksStatus.addAll({
        downloadTaskId!: IwrDownloadTaskStatus(
          status: DownloadTaskStatus.enqueued,
          progress: 0,
        ).obs
      });

      StorageProvider.addDownloadVideoRecord(task);
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
                "SELECT * FROM task WHERE status = ${DownloadTaskStatus.running}")
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

  Future<void> resumeTask(String taskId) {
    return FlutterDownloader.pause(taskId: taskId);
  }

  Future<void> cancelTask(String taskId) {
    return FlutterDownloader.cancel(taskId: taskId);
  }

  Future<void> deleteTaskRecord(String taskId) async {
    await FlutterDownloader.remove(taskId: taskId, shouldDeleteContent: false);
  }
}
