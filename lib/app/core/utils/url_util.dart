import 'package:get/get.dart';

import '../../data/enums/types.dart';
import '../../routes/pages.dart';

class UrlUtil {
  static void jumpTo(String url) {
    // iwara.tv/profile/{userid}/xxx
    RegExp profile = RegExp(r"/profile/([^/]+)");
    if (profile.hasMatch(url)) {
      String username = profile.firstMatch(url)!.group(1)!.split("/").last;
      Get.toNamed(
        AppRoutes.profile,
        arguments: username,
        preventDuplicates: true,
      );
      return;
    }
    // iwara.tv/video/{videoid}/xxx
    RegExp video = RegExp(r"/video/([^/]+)");
    if (video.hasMatch(url)) {
      String videoid = video.firstMatch(url)!.group(1)!.split("/").last;
      Get.toNamed(
        AppRoutes.mediaDetail,
        arguments: {"mediaType": MediaType.video, "id": videoid},
        preventDuplicates: true,
      );
      return;
    }
    // iwara.tv/image/{imageid}/xxx
    RegExp image = RegExp(r"/image/([^/]+)");
    if (image.hasMatch(url)) {
      String imageid = image.firstMatch(url)!.group(1)!.split("/").last;
      Get.toNamed(
        AppRoutes.mediaDetail,
        arguments: {"mediaType": MediaType.image, "id": imageid},
        preventDuplicates: true,
      );
      return;
    }
    // iwara.tv/playlist/{playlistid}
    RegExp playlist = RegExp(r"/playlist/([^/]+)");
    if (playlist.hasMatch(url)) {
      String playlistid = playlist.firstMatch(url)!.group(1)!.split("/").last;
      Get.toNamed(
        AppRoutes.playlistDetail,
        arguments: playlistid,
        preventDuplicates: true,
      );
      return;
    }
  }
}
