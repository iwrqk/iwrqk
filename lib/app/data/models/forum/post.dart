import '../user.dart';

class PostModel {
  final String id;
  final String body;
  final int replyNum;
  final UserModel user;
  final String createAt;
  final String updateAt;

  PostModel({
    required this.id,
    required this.body,
    required this.replyNum,
    required this.user,
    required this.createAt,
    required this.updateAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      body: json['body'],
      replyNum: json['replyNum'],
      user: UserModel.fromJson(json['user']),
      createAt: json['createdAt'],
      updateAt: json['updatedAt'],
    );
  }
}
