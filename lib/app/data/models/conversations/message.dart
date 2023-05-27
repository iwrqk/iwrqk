import '../user.dart';

class MessageModel {
  String id;
  String body;
  UserModel user;
  String conversation;
  String createdAt;
  String updatedAt;

  MessageModel({
    required this.id,
    required this.body,
    required this.user,
    required this.conversation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      body: json['body'],
      user: UserModel.fromJson(json['user']),
      conversation: json['conversation'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'user': user.toJson(),
      'conversation': conversation,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
