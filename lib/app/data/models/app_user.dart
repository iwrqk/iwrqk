import 'notifications/settings.dart';
import 'profile.dart';
import 'tag.dart';
import 'user.dart';

class AppUserModel {
  UserModel user;
  List<TagModel> tagBlacklist;
  ProfileModel profile;
  NotificationsSettings notifications;

  AppUserModel({
    required this.user,
    required this.tagBlacklist,
    required this.profile,
    required this.notifications,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      user: UserModel.fromJson(json['user']),
      tagBlacklist: List<TagModel>.from(
          json['tagBlacklist'].map((x) => TagModel.fromJson(x))),
      profile: ProfileModel.fromJson(json['profile']),
      notifications: NotificationsSettings.fromJson(json['notifications']),
    );
  }

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "tagBlacklist": List<dynamic>.from(tagBlacklist.map((x) => x.toJson())),
        "profile": profile.toJson(),
        "notifications": notifications.toJson(),
      };
}
