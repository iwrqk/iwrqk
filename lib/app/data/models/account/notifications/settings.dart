class NotificationsSettings {
  bool mention;
  bool reply;
  bool comment;

  NotificationsSettings({
    required this.mention,
    required this.reply,
    required this.comment,
  });

  factory NotificationsSettings.fromJson(Map<String, dynamic> json) =>
      NotificationsSettings(
        mention: json["mention"],
        reply: json["reply"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "mention": mention,
        "reply": reply,
        "comment": comment,
      };
}
