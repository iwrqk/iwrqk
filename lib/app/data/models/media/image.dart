import '../../../core/const/iwara.dart';
import '../file.dart';
import '../tag.dart';
import '../user.dart';
import 'media.dart';

class ImageModel extends MediaModel {
  FileModel? thumbnail;
  List<FileModel> files;
  int numImages;

  ImageModel({
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
    required this.files,
    required this.numImages,
  });

  List<String> get galleryFileUrls {
    return files
        .map((e) => IwaraConst.galleryFileUrl
          .replaceFirst("{id}", e.id)
          .replaceFirst("{name}", e.name!))
        .toList();
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
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
      thumbnail: json['thumbnail'] != null
          ? FileModel.fromJson(json['thumbnail'])
          : null,
      files: List.from(json['files'].map((file) => FileModel.fromJson(file))),
      numImages: json['numImages'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json.addAll({
      'thumbnail': thumbnail?.toJson(),
      'files': files.map((file) => file.toJson()).toList(),
      'numImages': numImages,
    });
    return json;
  }

  @override
  bool hasCover() {
    bool flag = false;
    if (thumbnail != null) {
      if (thumbnail!.numThumbnails != 0) {
        flag = true;
      }
    }
    return flag;
  }

  @override
  String getCoverUrl() {
    return IwaraConst.imageCoverUrl
      .replaceFirst("{id}", thumbnail!.id)
      .replaceFirst("{name}", thumbnail!.name!);
  }
}
