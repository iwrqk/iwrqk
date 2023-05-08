import '../../core/const/iwara.dart';
import 'file.dart';
import 'user.dart';

class ProfileModel {
  String body;
  FileModel? header;
  UserModel? user;
  String? seenAt;
  String createdAt;
  String updatedAt;

  ProfileModel({
    required this.body,
    this.header,
    required this.user,
    this.seenAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String get bannerUrl {
    if (header == null) return IwaraConst.defaultBannerUrl;

    return IwaraConst.bannerUrl
        .replaceFirst("{id}", header!.id)
        .replaceFirst("{name}", header!.name!);
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      body: json['body'] ?? "",
      header:
          json['header'] != null ? FileModel.fromJson(json['header']) : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      seenAt: json['seenAt'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'body': body,
      'header': header?.toJson(),
      'user': user?.toJson(),
      'seenAt': seenAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
