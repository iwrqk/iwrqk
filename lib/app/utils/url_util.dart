import 'package:get/get.dart';

import '../data/enums/types.dart';
import '../data/providers/api_provider.dart';
import '../routes/pages.dart';

class UrlUtil {
  static Future<bool> jumpTo(String url) async {
    // iwara.tv/profile/{userid}/xxx (new)
    RegExp profile = RegExp(r"/profile/([^/]+)");
    if (profile.hasMatch(url)) {
      String username = profile.firstMatch(url)!.group(1)!.split("/").last;
      Get.toNamed("/profile?userName=$username");
      return true;
    }
    // iwara.tv/users/{userid}/xxx (old)
    RegExp user = RegExp(r"/users/([^/]+)");
    if (user.hasMatch(url)) {
      String username =
          Uri.decodeComponent(user.firstMatch(url)!.group(1)!.split("/").last);
      return await ApiProvider.getMigrationUserName(oldUserName: username)
          .then((value) {
        if (value.success) {
          Get.toNamed("/profile?userName=${value.data}");
          return true;
        }
        return false;
      });
    }
    // iwara.tv/video/{videoid}/xxx (new)
    // iwara.tv/videos/{videoid}/xxx (old)
    RegExp video = RegExp(r"/videos?/([^/]+)");
    if (video.hasMatch(url)) {
      String videoid = video.firstMatch(url)!.group(1)!.split("/").last;
      Get.toNamed(
        "/mediaDetail?id=$videoid",
        arguments: {"mediaType": MediaType.video},
      );
      return true;
    }
    // iwara.tv/image/{imageid}/xxx (new)
    // iwara.tv/images/{imageid}/xxx (old)
    RegExp image = RegExp(r"/images?/([^/]+)");
    if (image.hasMatch(url)) {
      String imageid = image.firstMatch(url)!.group(1)!.split("/").last;
      Get.toNamed(
        "/mediaDetail?id=$imageid",
        arguments: {"mediaType": MediaType.image},
      );
      return true;
    }
    // iwara.tv/playlist/{playlistid} (new)
    // iwara.tv/playlists/{playlistid} (old)
    RegExp playlist = RegExp(r"/playlists?/([^/]+)");
    if (playlist.hasMatch(url)) {
      String playlistid = playlist.firstMatch(url)!.group(1)!.split("/").last;
      Get.toNamed(
        AppRoutes.playlistDetail,
        arguments: playlistid,
        preventDuplicates: true,
      );
      return true;
    }
    // iwara.tv/forum/{channelName}/{threadId} (new)
    RegExp thread = RegExp(r"/forum/([^/]+)/([^/]+)");
    if (thread.hasMatch(url)) {
      String channelName = thread.firstMatch(url)!.group(1)!.split("/").last;
      String threadId = thread.firstMatch(url)!.group(2)!.split("/").last;
      Get.toNamed("/thread?channelName=$channelName&threadId=$threadId");
      return true;
    }
    // iwara.tv/forums/{threadTitle} (old)
    RegExp threadTitle = RegExp(r"/forums?/([^/]+)");
    if (threadTitle.hasMatch(url)) {
      String oldThreadTitle = Uri.decodeComponent(
          threadTitle.firstMatch(url)!.group(1)!.split("/").last);
      return await ApiProvider.getMigrationThreadUrl(
              oldThreadTitle: oldThreadTitle)
          .then((value) {
        if (value.success) {
          String channelName = value.data!.split("/").elementAt(2);
          String threadId = value.data!.split("/").last;
          Get.toNamed("/thread?channelName=$channelName&threadId=$threadId");
          return true;
        }
        return false;
      });
    }
    return false;
  }
}
