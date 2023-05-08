import 'offline/download_task_media.dart';

class MediaDownloadTask {
  DateTime createTime;
  Map<String, dynamic> task;
  DownloadTaskMediaModel offlineMeida;

  MediaDownloadTask({
    required this.createTime,
    required this.offlineMeida,
    required this.task,
  });
}

class VideoDownloadTask extends MediaDownloadTask {
  int expireTime;
  String resolutionName;

  VideoDownloadTask(
      {required this.expireTime,
      required DateTime createTime,
      required DownloadTaskMediaModel offlineMeida,
      required Map<String, dynamic> task,
      required this.resolutionName})
      : super(createTime: createTime, offlineMeida: offlineMeida, task: task);

  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime.millisecondsSinceEpoch,
      'expireTime': expireTime,
      'resolutionName': resolutionName,
      'offlineMeida': offlineMeida.toJson(),
      'task': task,
    };
  }

  factory VideoDownloadTask.fromJson(Map<String, dynamic> json) {
    return VideoDownloadTask(
      expireTime: json['expireTime'],
      createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
      resolutionName: json['resolutionName'],
      offlineMeida: DownloadTaskMediaModel.fromJson(json['offlineMeida']),
      task: json['task'],
    );
  }
}

class ImageDownloadTask extends MediaDownloadTask {
  ImageDownloadTask({
    required DateTime createTime,
    required DownloadTaskMediaModel offlineMeida,
    required Map<String, dynamic> task,
  }) : super(createTime: createTime, offlineMeida: offlineMeida, task: task);

  Map<String, dynamic> toJson() {
    return {
      'createTime': createTime.millisecondsSinceEpoch,
      'offlineMeida': offlineMeida.toJson(),
      'task': task,
    };
  }

  factory ImageDownloadTask.fromJson(Map<String, dynamic> json) {
    return ImageDownloadTask(
      createTime: DateTime.fromMillisecondsSinceEpoch(json['createTime']),
      offlineMeida: DownloadTaskMediaModel.fromJson(json['offlineMeida']),
      task: json['taskId'],
    );
  }
}
