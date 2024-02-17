import '../../enums/types.dart';
import '../media/image.dart';
import '../media/media.dart';
import '../media/video.dart';
import '../user.dart';
import 'history_media.dart';

class OfflineMediaModel {
  late MediaType type;
  late String title;
  late String id;
  String? coverUrl;
  int? galleryLength;
  late UserModel uploader;
  int? duration;
  late String ratingType;

  OfflineMediaModel({
    required this.type,
    required this.title,
    required this.id,
    this.coverUrl,
    this.galleryLength,
    required this.uploader,
    this.duration,
    required this.ratingType,
  });

  Map<String, dynamic> toJson() => {
        'type': type.toString().split('.').last,
        'title': title,
        'id': id,
        'coverUrl': coverUrl,
        'galleryLength': galleryLength,
        'uploader': uploader.toJson(),
        'duration': duration,
        'ratingType': ratingType,
      };

  factory OfflineMediaModel.fromJson(Map<String, dynamic> json) {
    return OfflineMediaModel(
      type: MediaType.values
          .firstWhere((e) => e.toString().split('.').last == json['type']),
      title: json['title'],
      id: json['id'],
      coverUrl: json['coverUrl'],
      galleryLength: json['galleryLength'],
      uploader: UserModel.fromJson(json['uploader']),
      duration: json['duration'],
      ratingType: json['ratingType'],
    );
  }

  factory OfflineMediaModel.fromMediaModel(MediaModel model) {
    MediaType type;
    int? duration;
    int? galleryLength;

    if ((model is VideoModel)) {
      type = MediaType.video;
      duration = model.file?.duration;
    } else {
      type = MediaType.image;
      galleryLength = (model as ImageModel).numImages;
    }

    return OfflineMediaModel(
      type: type,
      title: model.title,
      id: model.id,
      coverUrl: model.getCoverUrl(),
      galleryLength: galleryLength,
      uploader: model.user,
      duration: duration,
      ratingType: model.rating,
    );
  }

  factory OfflineMediaModel.fromHistoryMediaPreviewData(
      HistoryMediaModel model) {
    return OfflineMediaModel(
      type: model.type,
      title: model.title,
      id: model.id,
      coverUrl: model.coverUrl,
      galleryLength: model.galleryLength,
      uploader: model.uploader,
      duration: model.duration,
      ratingType: model.ratingType,
    );
  }

  bool contains(String query) {
    return title.toLowerCase().contains(query.toLowerCase()) ||
        uploader.name.toLowerCase().contains(query.toLowerCase());
  }
}
