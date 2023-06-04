import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../core/utils/display_util.dart';
import '../enums/result.dart';
import '../enums/types.dart';
import '../models/account/conversations/conversation.dart';
import '../models/account/notifications/counts.dart';
import '../models/account/notifications/settings.dart';
import '../models/playlist/light_playlist.dart';
import '../models/user.dart';
import '../providers/api_provider.dart';
import 'account_service.dart';

class UserService extends GetxService {
  final AccountService accountService = Get.find();

  UserModel? user;

  NotificationsSettings? notificationsSettings;

  NotificationsCountsModel? notificationsCounts;

  Future<bool> init() async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return Future.value(flag);
    }
    return getUser().then((value) {
      if (!value) {
        flag = false;
        return Future.value(flag);
      }
      return getNotificationsCounts().then((value) {
        if (!value) {
          flag = false;
          return Future.value(flag);
        }
        return Future.value(true);
      });
    });
  }

  Future<bool> getUser() {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return Future.value(flag);
    }
    return ApiProvider.getAppUser().then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        user = value.data!.user;
        notificationsSettings = value.data!.notifications;
        flag = true;
      }
      return flag;
    });
  }

  Future<bool> getNotificationsCounts() {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return Future.value(flag);
    }
    return ApiProvider.getNotificationsCounts().then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        notificationsCounts = value.data;
        flag = true;
      }
      return flag;
    });
  }

  Future<ApiResult<GroupResult<ConversationModel>>> getConversations(
      int pageNum) {
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      return Future.value(ApiResult(
          data: null, message: DisplayUtil.messageNeedLogin, success: false));
    }
    return ApiProvider.getConversations(user!.id, pageNum);
  }

  Future<bool> followUser(String userId) async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    await ApiProvider.followUser(userId: userId).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<bool> unfollowUploader(String userId) async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    await ApiProvider.unfollowUser(userId: userId).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<ApiResult<FriendRelationType>> getFriendRelation(String userId) async {
    bool flag = false;
    FriendRelationType? relation;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return ApiResult(data: null, success: flag);
    }
    await ApiProvider.getFriendRelation(userId: userId).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
        relation = value.data;
      }
    });
    return ApiResult(data: relation, success: flag);
  }

  Future<bool> sendFriendRequest(String userId) async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    await ApiProvider.sendFriendRequest(userId: userId).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<bool> acceptFriendRequest(String userId) async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    await ApiProvider.acceptFriendRequest(userId: userId).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<bool> rejectFriendRequest(String userId) async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    await ApiProvider.rejectFriendRequest(userId: userId).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<bool> unfriend(String userId) async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    await ApiProvider.unfriend(userId: userId).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<bool> favoriteMedia(String id) async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    await ApiProvider.favoriteMedia(id: id).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<bool> unfavoriteMedia(String id) async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    await ApiProvider.unfavoriteMedia(id: id).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<ApiResult<List<LightPlaylistModel>>> getLightPlaylists(
      String videoId) async {
    bool flag = false;
    List<LightPlaylistModel>? result;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return ApiResult(data: null, success: flag);
    }
    await ApiProvider.getLightPlaylists(videoId: videoId).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
        result = value.data;
      }
    });
    return ApiResult(data: result, success: flag);
  }

  Future<bool> createPlaylist(String title) async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    await ApiProvider.createPlaylist(title: title).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<bool> addToPlaylist(String videoId, List<String> playlistIds) async {
    bool flag = true;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    for (String playlistId in playlistIds) {
      await ApiProvider.addToPlaylist(videoId: videoId, playlistId: playlistId)
          .then((value) {
        if (!value.success) {
          showToast(value.message!);
          flag = false;
        } else {
          flag &= true;
        }
      });
    }
    return flag;
  }

  Future<bool> removeFromPlaylist(
      String videoId, List<String> playlistIds) async {
    bool flag = true;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    for (String playlistId in playlistIds) {
      await ApiProvider.removeFromPlaylist(
              videoId: videoId, playlistId: playlistId)
          .then((value) {
        if (!value.success) {
          showToast(value.message!);
          flag = false;
        } else {
          flag &= true;
        }
      });
    }
    return flag;
  }

  Future<bool> sendComment({
    required CommentsSourceType sourceType,
    required String sourceId,
    required String content,
    String? parentId,
  }) async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    await ApiProvider.sendComment(
      sourceType: sourceType,
      sourceId: sourceId,
      content: content,
      parentId: parentId,
    ).then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }

  Future<bool> deleteComment(String sourceType, String commentId) async {
    bool flag = false;
    if (!accountService.isLogin) {
      showToast(DisplayUtil.messageNeedLogin);
      flag = false;
      return flag;
    }
    await ApiProvider.deleteComment(sourceType: sourceType, id: commentId)
        .then((value) {
      if (!value.success) {
        showToast(value.message!);
        flag = false;
      } else {
        flag = true;
      }
    });
    return flag;
  }
}
