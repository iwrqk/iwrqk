enum MediaType {
  video(value: "video"),
  image(value: "image");

  const MediaType({required this.value});
  final String value;

  static MediaType fromString(String value) {
    switch (value) {
      case "video":
        return MediaType.video;
      case "image":
        return MediaType.image;
      default:
        return MediaType.video;
    }
  }
}

enum MediaSourceType {
  thirdparty,
  videos,
  images,
  posts,
  uploaderVideos,
  uploaderImages,
  uploaderPosts,
  subscribedVideos,
  subscribedImages,
  subscribedPosts,
}

enum UsersSourceType { following, followers, search }

enum CommentsSourceType {
  video(value: "video"),
  image(value: "image"),
  profile(value: "profile"),
  videoReplies(value: "video"),
  imageReplies(value: "image"),
  profileReplies(value: "profile");

  const CommentsSourceType({required this.value});
  final String value;
}

enum FriendRelationType { unknown, none, friended, pending }

enum OrderType {
  date(value: "date"),
  trending(value: "trending"),
  popularity(value: "popularity"),
  views(value: "views"),
  likes(value: "likes");

  const OrderType({required this.value});
  final String value;
}

enum RatingType {
  all(value: "all"),
  general(value: "general"),
  ecchi(value: "ecchi");

  const RatingType({required this.value});
  final String value;

  static RatingType fromString(String value) {
    switch (value) {
      case "all":
        return RatingType.all;
      case "general":
        return RatingType.general;
      case "ecchi":
        return RatingType.ecchi;
      default:
        return RatingType.all;
    }
  }

  factory RatingType.fromInt(int index) {
    switch (index) {
      case 0:
        return RatingType.all;
      case 1:
        return RatingType.general;
      case 2:
        return RatingType.ecchi;
      default:
        return RatingType.all;
    }
  }
}

enum SearchSource { offical, oreno3d, erommdtube }
