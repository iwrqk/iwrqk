import 'thread.dart';

class ChannelModel {
  String id;
  String group;
  bool locked;
  int numPosts;
  int numThreads;
  ThreadModel? lastThread;

  ChannelModel({
    required this.id,
    required this.group,
    required this.locked,
    required this.numPosts,
    required this.numThreads,
    required this.lastThread,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      group: json['group'],
      locked: json['locked'],
      numPosts: json['numPosts'],
      numThreads: json['numThreads'],
      lastThread: json['lastThread'] != null
          ? ThreadModel.fromJson(json['lastThread'])
          : null,
    );
  }
}
