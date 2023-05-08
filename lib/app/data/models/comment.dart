import 'user.dart';

class CommentModel {
  String id;
  String body;
  int numReplies;
  String createdAt;
  String updatedAt;
  UserModel user;

  // LOCAL
  List<CommentModel> children = [];

  CommentModel({
    required this.id,
    required this.body,
    required this.numReplies,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      body: json['body'],
      numReplies: json['numReplies'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: UserModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'numReplies': numReplies,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'user': user.toJson(),
    };
  }
}
