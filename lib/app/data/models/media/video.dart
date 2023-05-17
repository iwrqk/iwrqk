import '../../../core/const/iwara.dart';
import '../../../core/utils/crypto_util.dart';
import '../file.dart';
import '../tag.dart';
import '../user.dart';
import 'media.dart';

class VideoModel extends MediaModel {
  int thumbnail;
  bool private;
  String? embedUrl;
  FileModel? file;
  String? fileUrl;

  VideoModel({
    required super.id,
    required super.slug,
    required super.title,
    required super.body,
    required super.status,
    required super.rating,
    required super.unlisted,
    required super.liked,
    required super.numLikes,
    required super.numViews,
    required super.numComments,
    required super.customThumbnail,
    required super.user,
    required super.tags,
    required super.createdAt,
    required super.updatedAt,
    required this.thumbnail,
    required this.private,
    required this.embedUrl,
    required this.file,
    required this.fileUrl,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      slug: json['slug'],
      title: json['title'],
      body: json['body'],
      status: json['status'],
      rating: json['rating'],
      unlisted: json['unlisted'],
      liked: json['liked'],
      numLikes: json['numLikes'],
      numViews: json['numViews'],
      numComments: json['numComments'],
      customThumbnail: json['customThumbnail'],
      user: UserModel.fromJson(json['user']),
      tags: List.from(json['tags'].map((tag) => TagModel.fromJson(tag))),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      thumbnail: json['thumbnail'],
      private: json['private'],
      embedUrl: json['embedUrl'],
      file: json['file'] != null ? FileModel.fromJson(json['file']) : null,
      fileUrl: json['fileUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json.addAll({
      'thumbnail': thumbnail,
      'private': private,
      'embedUrl': embedUrl,
      'file': file?.toJson(),
      'fileUrl': fileUrl,
    });
    return json;
  }

  @override
  bool hasCover() {
    bool flag = false;
    if (file != null) {
      flag = true;
    }
    return flag;
  }

  @override
  String getCoverUrl() {
    if (embedUrl == null) {
      return IwaraConst.videoCoverUrl.replaceFirst('{id}', file!.id);
    } else {
      if (embedUrl!.contains("youtu")) {
        RegExp regExp = RegExp(
            r"(?:youtube\.com\/.*[?&]v=|youtu\.be\/)([a-zA-Z0-9_-]{11})");
        var match = regExp.firstMatch(embedUrl!);
        if (match != null) {
          var videoIdWithPrefix = match.group(0)!;
          var youtubeId =
              videoIdWithPrefix.split("/").last.replaceAll("watch?v=", "");
          return IwaraConst.videoCoverUrl.replaceFirst('{id}', youtubeId);
        }
      }
    }

    return "";
  }

  String getXVerison() {
    var vid =
        RegExp(r'file/(\w+-\w+-\w+-\w+-\w+)\?').firstMatch(fileUrl!)?.group(1);
    var expires = RegExp(r'expires=(\d+)').firstMatch(fileUrl!)?.group(1);

    return CryptoUtil.getHash('${vid}_${expires}_${IwaraConst.salt}');
  }
}
