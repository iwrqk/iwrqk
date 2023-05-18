import 'package:iwrqk/app/core/const/iwara.dart';

import '../../../core/utils/log_util.dart';
import '../../enums/result.dart';
import '../../enums/types.dart';
import '../../models/app_user.dart';
import '../../models/comment.dart';
import '../../models/forum/channel.dart';
import '../../models/forum/post.dart';
import '../../models/forum/thread.dart';
import '../../models/media/image.dart';
import '../../models/media/media.dart';
import '../../models/media/video.dart';
import '../../models/notifications/counts.dart';
import '../../models/playlist/light_playlist.dart';
import '../../models/playlist/playlist.dart';
import '../../models/profile.dart';
import '../../models/resolution.dart';
import '../../models/user.dart';
import 'network_provider.dart';

class ApiProvider {
  static NetworkProvider networkProvider = NetworkProvider();

  static Future<ApiResult<String>> login(String email, String password) async {
    String? message;
    String? token;
    await networkProvider.post("/user/login", data: {
      "email": email,
      "password": password,
    }).then((value) {
      if (value.data["message"] != null) {
        message = value.data["message"];
      } else {
        token = value.data["token"];
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });
    return ApiResult(data: token, success: message == null, message: message);
  }

  static Future<ApiResult<void>> register(
      String captchaId, String email, String attemptedValue) async {
    late String message;
    bool success = false;
    await networkProvider.post("/user/register",
        data: {"email": email},
        headers: {"x-captcha": "$captchaId:$attemptedValue"}).then((value) {
      message = value.data["message"];
      success = (value.data["errors"] as List).isEmpty;
      if (!success) {
        for (var error in value.data["errors"]) {
          if (error["field"] == "captcha") {
            message = error["message"];
          }
        }
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });
    return ApiResult(data: null, success: success, message: message);
  }

  static Future<ApiResult<String>> getAccessToken() async {
    String? message;
    String? accessToken;
    await networkProvider.post("/user/token").then((value) {
      if (value.data["message"] != null) {
        throw value.data["message"];
      } else {
        accessToken = value.data["accessToken"];
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });
    return ApiResult(
        data: accessToken, success: message == null, message: message);
  }

  static Future<ApiResult<AppUserModel>> getAppUser() async {
    String? message;
    AppUserModel? appUser;
    await networkProvider.get("/user").then((value) {
      if (value.data["message"] != null) {
        message = value.data["message"];
      } else {
        appUser = AppUserModel.fromJson(value.data);
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(data: appUser, success: message == null, message: message);
  }

  static Future<ApiResult<NotificationsCountsModel>>
      getNotificationsCounts() async {
    String? message;
    NotificationsCountsModel? notificationsCounts;
    await networkProvider.get("/user/counts").then((value) {
      if (value.data["message"] != null) {
        message = value.data["message"];
      } else {
        notificationsCounts = NotificationsCountsModel.fromJson(value.data);
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
        data: notificationsCounts, success: message == null, message: message);
  }

  static Future<ApiResult<ProfileModel>> getProfile(String userName) async {
    String? message;
    ProfileModel? profile;
    await networkProvider.get("/profile/$userName").then((value) {
      if (value.data["message"] != null) {
        message = value.data["message"];
      } else {
        profile = ProfileModel.fromJson(value.data);
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });
    return ApiResult(data: profile, success: message == null, message: message);
  }

  static Future<ApiResult<int>> getUsersCount({required String path}) async {
    String? message;
    int? count;
    await networkProvider.get(path, queryParameters: {
      "limit": 1,
    }).then((value) {
      if (value.data["message"] != null) {
        message = value.data["message"];
      } else {
        count = value.data["count"];
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });
    return ApiResult(data: count, success: message == null, message: message);
  }

  static Future<ApiResult<GroupResult<CommentModel>>> getComments({
    required String id,
    required String type,
    required int pageNum,
    bool isPreview = false,
  }) async {
    String? message;
    int count = 0;
    List<CommentModel> comments = [];

    await networkProvider.get("/$type/$id/comments",
        queryParameters: {"page": pageNum}).then((value) async {
      if (value.data["message"] != null) {
        message = value.data["message"];
      } else {
        count = value.data["count"];
        for (var commentJson in value.data["results"]) {
          CommentModel comment = CommentModel.fromJson(commentJson);

          if (comment.numReplies > 0 && isPreview) {
            await networkProvider.get("/$type/$id/comments", queryParameters: {
              "parent": comment.id,
              "limit": 2
            }).then((value) {
              if (value.data["message"] != null) {
                throw value.data["message"];
              }
              for (var child in value.data["results"]) {
                comment.children.add(CommentModel.fromJson(child));
              }
            });
          }

          comments.add(comment);
        }
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: GroupResult(
        count: count,
        results: comments,
      ),
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<GroupResult<CommentModel>>> getReplies({
    required String parentId,
    required String sourceType,
    required String sourceId,
    required int pageNum,
  }) async {
    String? message;
    int count = 0;
    List<CommentModel> comments = [];

    await networkProvider.get("/$sourceType/$sourceId/comments",
        queryParameters: {"parent": parentId, "page": pageNum}).then((value) {
      if (value.data["message"] != null) {
        message = value.data["message"];
      } else {
        count = value.data["count"];
        comments = (value.data["results"] as List)
            .map((e) => CommentModel.fromJson(e))
            .toList();
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: GroupResult(
        count: count,
        results: comments,
      ),
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<VideoModel>> getVideo(String id) async {
    String? message;
    VideoModel? video;
    await networkProvider.get("/video/$id").then((value) {
      if (value.data["message"] != null) {
        message = value.data["message"];
      } else {
        video = VideoModel.fromJson(value.data);
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });
    return ApiResult(data: video, success: message == null, message: message);
  }

  static Future<ApiResult<ImageModel>> getImage(String id) async {
    String? message;
    ImageModel? image;
    await networkProvider.get("/image/$id").then((value) {
      if (value.data["message"] != null) {
        message = value.data["message"];
      } else {
        image = ImageModel.fromJson(value.data);
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });
    return ApiResult(data: image, success: message == null, message: message);
  }

  static Future<ApiResult<List<ResolutionModel>>> getVideoResolutions(
      String url, String xversion) async {
    String? message;
    List<ResolutionModel> resolutions = [];

    await networkProvider.getFullUrl(url, headers: {
      "x-version": xversion,
    }).then((value) {
      if (value.data is List) {
        resolutions =
            List.from(value.data.map((e) => ResolutionModel.fromJson(e)));
      } else {
        message = value.data["message"];
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    List<ResolutionModel> finalResolutions = [];

    for (ResolutionModel resolution in resolutions) {
      if (resolution.name != "preview") {
        finalResolutions.add(resolution);
      }
    }

    return ApiResult(
      data: finalResolutions,
      success: resolutions.isNotEmpty,
      message: message,
    );
  }

  static Future<ApiResult<GroupResult<MediaModel>>> getMedia({
    required String path,
    Map<String, dynamic>? queryParameters,
    required MediaType type,
  }) async {
    String? message;
    int count = 0;
    List<MediaModel> media = [];

    await networkProvider
        .get(path, queryParameters: queryParameters)
        .then((value) {
      message = value.data["message"];

      if (message != null) {
        if (message == "errors.notFound") {
          message = null;
          media = [];
          count = 0;
        }
      } else {
        count = value.data["count"];
        if (type == MediaType.video) {
          media = (value.data["results"] as List)
              .map((e) => VideoModel.fromJson(e))
              .toList();
        } else {
          media = (value.data["results"] as List)
              .map((e) => ImageModel.fromJson(e))
              .toList();
        }
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: GroupResult(
        count: count,
        results: media,
      ),
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<GroupResult<MediaModel>>> getFavoriteMedia({
    required MediaType type,
    required int currentPage,
  }) async {
    String? message;
    int count = 0;
    List<MediaModel> media = [];

    String path =
        type == MediaType.video ? "/favorites/videos" : "/favorites/images";

    await networkProvider
        .get(path, queryParameters: {"page": currentPage}).then((value) {
      message = value.data["message"];

      if (message != null) {
        if (message == "errors.notFound") {
          message = null;
          media = [];
          count = 0;
        }
      } else {
        count = value.data["count"];
        if (type == MediaType.video) {
          media = (value.data["results"] as List)
              .map((e) => VideoModel.fromJson(e["video"]))
              .toList();
        } else {
          media = (value.data["results"] as List)
              .map((e) => ImageModel.fromJson(e["image"]))
              .toList();
        }
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: GroupResult(
        count: count,
        results: media,
      ),
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<GroupResult<UserModel>>> getUsers({
    required String path,
    required Map<String, dynamic> queryParameters,
    required UsersSourceType type,
  }) async {
    String? message;
    int count = 0;
    List<UserModel> users = [];

    await networkProvider
        .get(path, queryParameters: queryParameters)
        .then((value) {
      message = value.data["message"];

      if (message != null) {
        if (message == "errors.notFound") {
          message = null;
          users = [];
          count = 0;
        }
      } else {
        count = value.data["count"];
        if (type == UsersSourceType.followers) {
          for (var item in value.data["results"]) {
            users.add(UserModel.fromJson(item["follower"]));
          }
        } else if (type == UsersSourceType.following) {
          for (var item in value.data["results"]) {
            users.add(UserModel.fromJson(item["user"]));
          }
        } else if (type == UsersSourceType.search) {
          for (var item in value.data["results"]) {
            users.add(UserModel.fromJson(item));
          }
        }
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: GroupResult(
        count: count,
        results: users,
      ),
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<List<ChannelModel>>> getForumChannels() async {
    String? message;
    List<ChannelModel> channels = [];

    await networkProvider.get("/forum").then((value) {
      if (value.data is List) {
        channels = List.from(value.data.map((e) => ChannelModel.fromJson(e)));
      } else {
        message = value.data["message"];
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: channels,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<GroupResult<ThreadModel>>> getChannelThreads({
    required String channelName,
    required int pageNum,
  }) async {
    String? message;
    int count = 0;
    List<ThreadModel> threads = [];

    await networkProvider.get("/forum/$channelName",
        queryParameters: {"page": pageNum}).then((value) {
      message = value.data["message"];

      if (message != null) {
        if (message == "errors.notFound") {
          message = null;
          threads = [];
          count = 0;
        }
      } else {
        count = value.data["count"];
        threads = List.from(
          value.data["threads"].map(
            (e) => ThreadModel.fromJson(e),
          ),
        );
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: GroupResult(
        count: count,
        results: threads,
      ),
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<GroupResult<PostModel>>> getThreadPosts({
    required String channelName,
    required String threadId,
    required int pageNum,
  }) async {
    String? message;
    int count = 0;
    List<PostModel> posts = [];

    await networkProvider.get("/forum/$channelName/$threadId",
        queryParameters: {"page": pageNum}).then((value) {
      message = value.data["message"];

      if (message != null) {
        if (message == "errors.notFound") {
          message = null;
          posts = [];
          count = 0;
        }
      } else {
        count = value.data["count"];
        posts = List.from(
          value.data["results"].map(
            (e) => PostModel.fromJson(e),
          ),
        );
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: GroupResult(
        count: count,
        results: posts,
      ),
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<GroupResult<MediaModel>>> searchMedia({
    required String keyword,
    required MediaType type,
    required int pageNum,
  }) async {
    String? message;
    int count = 0;
    List<MediaModel> media = [];

    await networkProvider.get("/search", queryParameters: {
      "query": keyword,
      "page": pageNum,
      "type": type.value,
    }).then((value) {
      message = value.data["message"];

      if (message != null) {
        if (message == "errors.notFound") {
          message = null;
          media = [];
          count = 0;
        }
      } else {
        count = value.data["count"];
        if (type == MediaType.video) {
          media = (value.data["results"] as List)
              .map((e) => VideoModel.fromJson(e))
              .toList();
        } else {
          media = (value.data["results"] as List)
              .map((e) => ImageModel.fromJson(e))
              .toList();
        }
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: GroupResult(
        count: count,
        results: media,
      ),
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> followUser({
    required String userId,
  }) async {
    String? message;

    await networkProvider.post("/user/$userId/followers").then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> unfollowUser({
    required String userId,
  }) async {
    String? message;

    await networkProvider.delete("/user/$userId/followers").then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> sendFriendRequest({
    required String userId,
  }) async {
    String? message;

    await networkProvider.post("/user/$userId/friends").then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> acceptFriendRequest({
    required String userId,
  }) async {
    String? message;

    await networkProvider.post("/user/$userId/friends").then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> rejectFriendRequest({
    required String userId,
  }) =>
      unfriend(userId: userId);

  static Future<ApiResult<void>> unfriend({
    required String userId,
  }) async {
    String? message;

    await networkProvider.delete("/user/$userId/friends").then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<FriendRelationType>> getFriendRelation({
    required String userId,
  }) async {
    String? message;
    FriendRelationType relationType = FriendRelationType.none;

    await networkProvider.get("/user/$userId/friends").then((value) {
      message = value.data["message"];

      if (message == null) {
        switch (value.data["status"]) {
          case "none":
            relationType = FriendRelationType.none;
            break;
          case "pending":
            relationType = FriendRelationType.pending;
            break;
          case "friends":
            relationType = FriendRelationType.friended;
            break;
        }
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: relationType,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<GroupResult<UserModel>>> getFriendRequests({
    required String userId,
    required int pageNum,
  }) async {
    String? message;
    int count = 0;
    List<UserModel> users = [];

    await networkProvider
        .get("/user/$userId/friends/requests", queryParameters: {
      "page": pageNum,
    }).then((value) {
      message = value.data["message"];

      if (message == null) {
        count = value.data["count"];
        users = (value.data["results"] as List)
            .map((e) => UserModel.fromJson(e))
            .toList();
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: GroupResult(
        count: count,
        results: users,
      ),
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> favoriteMedia({
    required String id,
  }) async {
    String? message;

    await networkProvider.post("/video/$id/like").then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> unfavoriteMedia({
    required String id,
  }) async {
    String? message;

    await networkProvider.delete("/video/$id/like").then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> createPlaylist({
    required String title,
  }) async {
    String? message;

    await networkProvider.post("/playlist", data: {
      "title": title,
    }).then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<GroupResult<PlaylistModel>>> getPlaylists({
    required String userId,
    required int pageNum,
  }) async {
    String? message;
    int count = 0;
    List<PlaylistModel> playlists = [];

    await networkProvider.get("/playlists", queryParameters: {
      "user": userId,
      "page": pageNum,
    }).then((value) {
      message = value.data["message"];

      if (message == null) {
        count = value.data["count"];
        playlists = (value.data["results"] as List)
            .map((e) => PlaylistModel.fromJson(e))
            .toList();
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: GroupResult(
        count: count,
        results: playlists,
      ),
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<List<LightPlaylistModel>>> getLightPlaylists({
    required String videoId,
  }) async {
    String? message;
    List<LightPlaylistModel> playlists = [];

    await networkProvider.get("/light/playlists", queryParameters: {
      "id": videoId,
    }).then((value) {
      if (value.data is List) {
        playlists = (value.data as List)
            .map((e) => LightPlaylistModel.fromJson(e))
            .toList();
      } else {
        message = value.data["message"];
      }
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: playlists,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> addToPlaylist({
    required String videoId,
    required String playlistId,
  }) async {
    String? message;

    await networkProvider.post("/playlist/$playlistId/$videoId").then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> removeFromPlaylist({
    required String videoId,
    required String playlistId,
  }) async {
    String? message;

    await networkProvider
        .delete("/playlist/$playlistId/$videoId")
        .then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> sendComment({
    required CommentsSourceType sourceType,
    required String sourceId,
    required String content,
    String? parentId,
  }) async {
    String? message;

    await networkProvider
        .post("/${sourceType.value}/$sourceId/comments", data: {
      "body": content,
      if (parentId != null) "parent": parentId,
    }).then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<void>> deleteComment({
    required String sourceType,
    required String id,
  }) async {
    String? message;

    await networkProvider.delete("/comment/$id").then((value) {
      message = value.data["message"];
    }).catchError((e, stackTrace) {
      LogUtil.logger.e("Error", e, stackTrace);
      message = e.toString();
    });

    return ApiResult(
      data: null,
      success: message == null,
      message: message,
    );
  }

  static Future<ApiResult<int?>> getFileSize(String url) async {
    try {
      int? size;
      await networkProvider
          .getFullUrl(url, headers: {"range": "bytes=0-1"}).then((value) {
        size = int.parse((value.headers.map["content-range"]![0])
            .split("/")
            .last
            .replaceAll(" ", ""));
      });
      return ApiResult(data: size, success: size != null);
    } catch (e) {
      return ApiResult(data: null, success: false, message: e.toString());
    }
  }
}
