class NotificationsCountsModel {
  int messages;
  int notifications;
  int friendRequests;

  NotificationsCountsModel({
    required this.messages,
    required this.notifications,
    required this.friendRequests,
  });

  int get total => messages + notifications + friendRequests;

  factory NotificationsCountsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsCountsModel(
      messages: json['messages'],
      notifications: json['notifications'],
      friendRequests: json['friendRequests'],
    );
  }

  Map<String, dynamic> toJson() => {
        "messages": messages,
        "notifications": notifications,
        "friendRequests": friendRequests,
      };
}
