import '../../const/iwara.dart';
import 'image.dart';

class UserModel {
  String id;
  String name;
  String username;
  String status;
  String role;
  bool followedBy;
  bool following;
  bool friend;
  bool premium;
  String? seenAt;
  ImageModel? avatar;
  String createdAt;
  String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.status,
    required this.role,
    required this.followedBy,
    required this.following,
    required this.friend,
    required this.premium,
    this.seenAt,
    this.avatar,
    required this.createdAt,
    required this.updatedAt,
  });

  String get avatarUrl {
    if (avatar == null) return IwaraConst.defaultAvatarUrl;

    bool animated = avatar!.mime == "image/gif" ||
        avatar!.mime == "image/webp" ||
        avatar!.mime == "image/apng";

    if (animated) {
      return avatar!.getOriginalUrl();
    }

    return IwaraConst.avatarUrl
        .replaceFirst("{id}", avatar!.id)
        .replaceFirst("{name}", avatar!.name!);
  }

  String get avatarOriginalUrl {
    if (avatar == null) return IwaraConst.defaultAvatarUrl;

    return avatar!.getOriginalUrl();
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      status: json['status'],
      role: json['role'],
      followedBy: json['followedBy'],
      following: json['following'],
      friend: json['friend'],
      premium: json['premium'],
      seenAt: json['seenAt'],
      avatar:
          json['avatar'] != null ? ImageModel.fromJson(json['avatar']) : null,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'status': status,
      'role': role,
      'followedBy': followedBy,
      'following': following,
      'friend': friend,
      'premium': premium,
      'seenAt': seenAt,
      'avatar': avatar?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
