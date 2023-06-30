import 'package:better_player/better_player.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../data/enums/types.dart';
import '../../../../data/models/download_task.dart';
import '../../../../data/models/offline/offline_media.dart';
import '../../../../data/services/config_service.dart';
import '../../../../global_widgets/media/iwr_player/controller.dart';
import '../../downloads/widgets/downloads_media_preview_list/controller.dart';

class DownloadedVideoDetailController extends GetxController
    with GetTickerProviderStateMixin {
  final String taskPreviewListTag =
      'downloaded_video_detail_tasks_preview_list';

  final ConfigService configService = Get.find();

  late MediaDownloadTask task;

  OfflineMediaModel get media => task.offlineMedia;

  IwrPlayerController? iwrPlayerController;

  final RxString _currentMediaId = ''.obs;
  String get currentMediaId => _currentMediaId.value;
  set currentMediaId(String value) => _currentMediaId.value = value;

  ScrollController scrollController = ScrollController();

  final RxDouble _hideAppbarFactor = 1.0.obs;
  double get hideAppbarFactor => _hideAppbarFactor.value;

  final RxBool _loading = true.obs;
  bool get loading => _loading.value;

  @override
  void onInit() {
    super.onInit();
    task = Get.arguments as MediaDownloadTask;

    _currentMediaId.value = media.id;

    Get.lazyPut(() => DownloadsMediaPreviewListController(),
        tag: taskPreviewListTag);

    scrollController.addListener(_onScroll);

    if (task.offlineMedia.type == MediaType.video) {
      _initPlayer();
    } else {
      _loading.value = false;
    }
  }

  void _onScroll() {
    double position = scrollController.position.pixels;
    double hideAppbarHit = scrollController.position.maxScrollExtent;
    double newValue = (hideAppbarHit - position) > 0
        ? (hideAppbarHit - position) / hideAppbarHit
        : 0;
    if (hideAppbarFactor - newValue >= 0.25 ||
        hideAppbarFactor - newValue <= -0.25 ||
        newValue == 0 ||
        newValue == 1) {
      _hideAppbarFactor.value = newValue;
    }
  }

  void _initPlayer() {
    task.downloadTask.filePath().then((value) {
      Get.put(
        IwrPlayerController(
          id: media.id,
          resolutions: {(task as VideoDownloadTask).resolutionName: value},
          type: BetterPlayerDataSourceType.file,
          title: media.title,
          author: media.uploader.name,
          thumbnail: media.coverUrl,
          setting: configService.playerSetting,
          onPlayerSettingSaved: (setting) {
            configService.playerSetting = setting;
          },
        ),
        tag: media.id,
      );

      iwrPlayerController = Get.find<IwrPlayerController>(tag: media.id);

      _loading.value = false;
    });
  }

  void changeVideoSource(MediaDownloadTask data) async {
    task = data;
    _currentMediaId.value = media.id;

    iwrPlayerController?.changeVideoSource(
      resolutions: {
        (data as VideoDownloadTask).resolutionName:
            await data.downloadTask.filePath()
      },
      author: data.offlineMedia.uploader.name,
      title: data.offlineMedia.title,
      type: BetterPlayerDataSourceType.file,
      thumbnail: data.offlineMedia.coverUrl,
    );
  }

  void pauseVideo() {
    iwrPlayerController?.pause();
  }
}
