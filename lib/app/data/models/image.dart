import '../../const/iwara.dart';
import 'file.dart';

class ImageModel extends FileModel {
  bool? animatedPreview;
  String? mime;

  ImageModel({
    required String id,
    this.animatedPreview,
    this.mime,
    String? path,
    String? name,
    int? duration,
    int? numThumbnails,
    String? createdAt,
    String? updatedAt,
  }) : super(
          id: id,
          path: path,
          name: name,
          duration: duration,
          numThumbnails: numThumbnails,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      animatedPreview: json['animatedPreview'],
      mime: json['mime'],
      path: json['path'],
      name: json['name'],
      duration: json['duration'],
      numThumbnails: json['numThumbnails'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  String getOriginalUrl() {
    return IwaraConst.originalFileUrl
        .replaceFirst("{id}", id)
        .replaceFirst("{name}", name!);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'animatedPreview': animatedPreview,
      'mime': mime,
      'path': path,
      'name': name,
      'duration': duration,
      'numThumbnails': numThumbnails,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }
}
