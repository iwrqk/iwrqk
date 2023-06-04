import '../user.dart';

class FriendRequestModel {
  String id;
  UserModel user;
  UserModel target;
  String createdAt;

  FriendRequestModel({
    required this.id,
    required this.user,
    required this.target,
    required this.createdAt,
  });

  factory FriendRequestModel.fromJson(Map<String, dynamic> json) =>
      FriendRequestModel(
        id: json["id"],
        user: UserModel.fromJson(json["user"]),
        target: UserModel.fromJson(json["target"]),
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        "target": target.toJson(),
        "createdAt": createdAt,
      };
}
