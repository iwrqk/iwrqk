import '../tag.dart';
import '../user.dart';

abstract class MediaModel {
  String id;
  String? slug;
  String title;
  String? body;
  String? status;
  String rating;
  bool? unlisted;
  bool liked;
  int numLikes;
  int numViews;
  int numComments;
  String? customThumbnail;
  UserModel user;
  List<TagModel> tags;
  String createdAt;
  String updatedAt;

  MediaModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.body,
    required this.status,
    required this.rating,
    required this.unlisted,
    required this.liked,
    required this.numLikes,
    required this.numViews,
    required this.numComments,
    required this.customThumbnail,
    required this.user,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'title': title,
      'body': body,
      'status': status,
      'rating': rating,
      'unlisted': unlisted,
      'liked': liked,
      'numLikes': numLikes,
      'numViews': numViews,
      'numComments': numComments,
      'customThumbnail': customThumbnail,
      'user': user.toJson(),
      'tags': List.from(tags.map((tag) => tag.toJson())),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  bool hasCover();
  String getCoverUrl();
}
