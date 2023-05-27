import '../../enums/types.dart';
import '../media/image.dart';
import '../media/media.dart';
import '../media/video.dart';
import '../user.dart';
import 'offline_meida.dart';

class HistoryMediaModel extends OfflineMediaModel {
  late DateTime viewedDate;
  bool isPrivate;

  HistoryMediaModel({
    required MediaType type,
    required this.viewedDate,
    required String title,
    required String id,
    String? coverUrl,
    int? galleryLength,
    required UserModel uploader,
    int? duration,
    required String ratingType,
    this.isPrivate = false,
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

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();
    map['viewedDate'] = viewedDate.toIso8601String();
    map['isPrivate'] = isPrivate;
    return map;
  }

  factory HistoryMediaModel.fromMediaData(MediaModel model) {
    MediaType type;
    bool? private;
    int? duration;
    int? galleryLength;

    if ((model is VideoModel)) {
      type = MediaType.video;
      duration = model.file?.duration;
      private = model.private;
    } else {
      type = MediaType.image;
      galleryLength = (model as ImageModel).numImages;
    }

    return HistoryMediaModel(
      type: type,
      viewedDate: DateTime.now(),
      title: model.title,
      id: model.id,
      coverUrl: model.getCoverUrl(),
      galleryLength: galleryLength,
      uploader: model.user,
      duration: duration,
      ratingType: model.rating,
      isPrivate: private ?? false,
    );
  }

  factory HistoryMediaModel.fromJson(Map<String, dynamic> json) {
    return HistoryMediaModel(
      type: json['type'] == 'image' ? MediaType.image : MediaType.video,
      viewedDate: DateTime.parse(json['viewedDate']),
      title: json['title'],
      id: json['id'],
      coverUrl: json['coverUrl'],
      galleryLength: json['galleryLength'],
      uploader: UserModel.fromJson(json['uploader']),
      duration: json['duration'],
      ratingType: json['ratingType'],
    );
  }
}
