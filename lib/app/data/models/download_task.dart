import 'offline/download_task_media.dart';

class MediaDownloadTask {
  DateTime createTime;
  String taskId;
  DownloadTaskMediaModel offlineMedia;

  MediaDownloadTask({
    required this.createTime,
    required this.offlineMedia,
    required this.taskId,
  });

  String get hash => "${offlineMedia.id}_$createTime";
}

class VideoDownloadTask extends MediaDownloadTask {
  int expireTime;
  String resolutionName;

  VideoDownloadTask(
      {required this.expireTime,
      required DateTime createTime,
      required DownloadTaskMediaModel offlineMedia,
      required String taskId,
      required this.resolutionName})
      : super(
            createTime: createTime, offlineMedia: offlineMedia, taskId: taskId);

  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime.millisecondsSinceEpoch,
      'expireTime': expireTime,
      'resolutionName': resolutionName,
      'offlineMedia': offlineMedia.toJson(),
      'taskId': taskId,
    };
  }

  factory VideoDownloadTask.fromJson(Map<String, dynamic> json) {
    return VideoDownloadTask(
      expireTime: json['expireTime'],
      createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
      resolutionName: json['resolutionName'],
      offlineMedia: DownloadTaskMediaModel.fromJson(json['offlineMedia']),
      taskId: json['taskId'],
    );
  }

  @override
  String get hash => "${offlineMedia.id}_$resolutionName";
}

class ImageDownloadTask extends MediaDownloadTask {
  ImageDownloadTask(
      {required DateTime createTime,
      required DownloadTaskMediaModel offlineMedia,
      required String taskId})
      : super(
            createTime: createTime, offlineMedia: offlineMedia, taskId: taskId);

  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime.millisecondsSinceEpoch,
      'offlineMedia': offlineMedia.toJson(),
      'taskId': taskId,
    };
  }

  factory ImageDownloadTask.fromJson(Map<String, dynamic> json) {
    return ImageDownloadTask(
      createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
      offlineMedia: DownloadTaskMediaModel.fromJson(json['offlineMedia']),
      taskId: json['taskId'],
    );
  }
}
