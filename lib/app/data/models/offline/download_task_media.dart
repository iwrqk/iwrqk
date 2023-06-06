import '../../enums/types.dart';
import '../user.dart';
import 'offline_media.dart';

class DownloadTaskMediaModel extends OfflineMediaModel {
  int size;

  DownloadTaskMediaModel({
    required MediaType type,
    required String title,
    required String id,
    String? coverUrl,
    int? galleryLength,
    required UserModel uploader,
    int? duration,
    required String ratingType,
    required this.size,
  }) : super(
          type: type,
          title: title,
          id: id,
          coverUrl: coverUrl,
          galleryLength: galleryLength,
          uploader: uploader,
          duration: duration,
          ratingType: ratingType,
        );

  factory DownloadTaskMediaModel.fromOfflineMediaModel(
      OfflineMediaModel mediaData, int size) {
    return DownloadTaskMediaModel(
      type: mediaData.type,
      title: mediaData.title,
      id: mediaData.id,
      coverUrl: mediaData.coverUrl,
      galleryLength: mediaData.galleryLength,
      uploader: mediaData.uploader,
      duration: mediaData.duration,
      ratingType: mediaData.ratingType,
      size: size,
    );
  }

  factory DownloadTaskMediaModel.fromJson(Map<String, dynamic> json) {
    return DownloadTaskMediaModel(
      type: json['type'] == 'image' ? MediaType.image : MediaType.video,
      title: json['title'],
      id: json['id'],
      coverUrl: json['coverUrl'],
      galleryLength: json['galleryLength'],
      uploader: UserModel.fromJson(json['uploader']),
      duration: json['duration'],
      ratingType: json['ratingType'],
      size: json['size'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map['size'] = size;
    return map;
  }
}
