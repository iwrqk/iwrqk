import '../user.dart';
import 'message.dart';

class ConversationModel {
  String id;
  String title;
  List<UserModel> participants;
  MessageModel lastMessage;
  int numMessages;
  String createdAt;
  String updatedAt;
  bool unread;

  ConversationModel({
    required this.id,
    required this.title,
    required this.participants,
    required this.lastMessage,
    required this.numMessages,
    required this.createdAt,
    required this.updatedAt,
    required this.unread,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id'],
      title: json['title'],
      participants: (json['participants'] as List)
          .map((i) => UserModel.fromJson(i))
          .toList(),
      lastMessage: MessageModel.fromJson(json['lastMessage']),
      numMessages: json['numMessages'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      unread: json['unread'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'participants': participants.map((i) => i.toJson()).toList(),
      'lastMessage': lastMessage.toJson(),
      'numMessages': numMessages,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'unread': unread,
    };
  }
}
