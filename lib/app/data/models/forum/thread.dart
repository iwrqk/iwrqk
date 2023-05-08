import '../user.dart';
import 'post.dart';

class ThreadModel {
  final String id;
  final String createdAt;
  final String title;
  final UserModel user;
  final int numPosts;
  final int numViews;
  final bool locked;
  PostModel? lastPost;

  ThreadModel({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.user,
    required this.numPosts,
    required this.numViews,
    required this.locked,
  });

  factory ThreadModel.fromJson(Map<String, dynamic> json) {
    return ThreadModel(
      id: json['id'],
      createdAt: json['createdAt'],
      title: json['title'],
      user: UserModel.fromJson(json['user']),
      numPosts: json['numPosts'],
      numViews: json['numViews'],
      locked: json['locked'],
    );
  }
}
