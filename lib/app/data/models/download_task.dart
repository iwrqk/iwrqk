import 'package:background_downloader/background_downloader.dart';

import 'offline/download_task_media.dart';

class MediaDownloadTask {
  DateTime createTime;
  Map<String, dynamic> task;
  DownloadTaskMediaModel offlineMedia;

  DownloadTask get downloadTask => DownloadTask.fromJsonMap(task);

  MediaDownloadTask({
    required this.createTime,
    required this.offlineMedia,
    required this.task,
  });
}

class VideoDownloadTask extends MediaDownloadTask {
  int expireTime;
  String resolutionName;

  VideoDownloadTask(
      {required this.expireTime,
      required DateTime createTime,
      required DownloadTaskMediaModel offlineMedia,
      required Map<String, dynamic> task,
      required this.resolutionName})
      : super(createTime: createTime, offlineMedia: offlineMedia, task: task);

  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime.millisecondsSinceEpoch,
      'expireTime': expireTime,
      'resolutionName': resolutionName,
      'offlineMedia': offlineMedia.toJson(),
      'task': task,
    };
  }

  factory VideoDownloadTask.fromJson(Map<String, dynamic> json) {
    return VideoDownloadTask(
      expireTime: json['expireTime'],
      createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
      resolutionName: json['resolutionName'],
      offlineMedia: DownloadTaskMediaModel.fromJson(json['offlineMedia']),
      task: json['task'],
    );
  }
}

class ImageDownloadTask extends MediaDownloadTask {
  ImageDownloadTask({
    required DateTime createTime,
    required DownloadTaskMediaModel offlineMedia,
    required Map<String, dynamic> task,
  }) : super(createTime: createTime, offlineMedia: offlineMedia, task: task);

  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime.millisecondsSinceEpoch,
      'offlineMedia': offlineMedia.toJson(),
      'task': task,
    };
  }

  factory ImageDownloadTask.fromJson(Map<String, dynamic> json) {
    return ImageDownloadTask(
      createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
      offlineMedia: DownloadTaskMediaModel.fromJson(json['offlineMedia']),
      task: json['taskId'],
    );
  }
}
