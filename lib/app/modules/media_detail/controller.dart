import 'dart:math';

import 'package:floating/floating.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';

import '../../components/plugin/pl_player/index.dart';
import '../../data/enums/types.dart';
import '../../data/models/download_task.dart';
import '../../data/models/media/media.dart';
import '../../data/models/media/video.dart';
import '../../data/models/offline/history_media.dart';
import '../../data/models/offline/offline_media.dart';
import '../../data/models/resolution.dart';
import '../../data/models/user.dart';
import '../../data/providers/storage_provider.dart';
import '../../data/services/config_service.dart';
import '../../data/services/download_service.dart';
import '../../data/services/plugin/pl_player/service_locator.dart';
import '../../data/services/user_service.dart';
import '../account/downloads/widgets/downloads_media_preview_list/controller.dart';
import 'repository.dart';
import 'widgets/header_control.dart';

class MediaDetailController extends GetxController
    with GetTickerProviderStateMixin {
  final MediaDetailRepository repository = MediaDetailRepository();

  ScrollController scrollController = ScrollController();

  final UserService _userService = Get.find();
  final ConfigService configService = Get.find();
  final DownloadService _downloadService = Get.find();

  bool isOffline = false;
  late MediaType mediaType;
  late MediaDownloadTask taskData;
  late String id;

  List<ResolutionModel> resolutions = [];
  int resolutionIndex = 0;

  final RxBool _isLoading = true.obs;
  final RxBool _isFectchingResolution = false.obs;
  final RxBool _isLoadingPlayer = false.obs;
  final RxBool _isFectchingRecommendation = true.obs;

  bool tempFavorite = false;

  final RxBool _isFavorite = false.obs;
  final RxBool _isProcessingFavorite = false.obs;

  bool get isFavorite => _isFavorite.value;
  bool get isProcessingFavorite => _isProcessingFavorite.value;

  late MediaModel media;
  late UserModel user;

  late List<MediaModel> moreFromUser;

  late List<MediaModel> moreLikeThis;

  bool get isLoading => _isLoading.value;
  bool get isFectchingResolution => _isFectchingResolution.value;
  bool get isLoadingPlayer => _isLoadingPlayer.value;
  bool get isFectchingRecommendation => _isFectchingRecommendation.value;

  OfflineMediaModel get offlineMedia => OfflineMediaModel.fromMediaModel(media);

  final RxBool _fetchFailed = false.obs;

  final RxString _errorMessage = "".obs;

  final RxString _errorMessageRecommendation = "".obs;

  final RxString _translatedContent = "".obs;

  bool get fetchFailed => _fetchFailed.value;

  String get errorMessage => _errorMessage.value;

  String get errorMessageRecommendation => _errorMessageRecommendation.value;

  String get translatedContent => _translatedContent.value;

  set errorMessage(String errorMessage) {
    _errorMessage.value = errorMessage;
  }

  set errorMessageRecommendation(String errorMessage) {
    _errorMessageRecommendation.value = errorMessage;
  }

  set isLoading(bool value) {
    _isLoading.value = value;
  }

  set isFectchingRecommendation(bool value) {
    _isFectchingRecommendation.value = value;
  }

  GStorageConfig setting = StorageProvider.config;

  Rational aspectRatio = const Rational(16, 9);

  late String offlinePlaylistTag;

  String? currentOfflineVideoUrl;
  String? currentOfflineTaskId;

  /// PL player
  PlPlayerController plPlayerController = PlPlayerController.getInstance();
  Duration defaultST = Duration.zero;
  // 亮度
  double? brightness;
  // 硬解
  RxBool enableHA = true.obs;
  // 是否开始自动播放
  RxBool autoPlay = true.obs;
  Floating? floating;

  late PreferredSizeWidget headerControl;

  @override
  void onInit() async {
    super.onInit();

    mediaType = Get.arguments["mediaType"];
    isOffline = Get.parameters["isOffline"]?.isNotEmpty ?? false;

    if (mediaType == MediaType.video) {
      autoPlay.value =
          setting.get(PLPlayerConfigKey.enableAutoPlay, defaultValue: true);
      enableHA.value =
          setting.get(PLPlayerConfigKey.enableHA, defaultValue: true);

      if (GetPlatform.isAndroid) {
        floating = Floating();
      }

      headerControl = HeaderControl(
        controller: plPlayerController,
        videoDetailCtr: this,
        floating: floating,
      );
    }

    if (isOffline) {
      taskData = Get.arguments["taskData"];
      id = taskData.offlineMedia.id;
      if (taskData.offlineMedia.type == MediaType.video) {
        offlinePlaylistTag = "download_playlist_${taskData.offlineMedia.id}";

        Get.lazyPut(() => DownloadsMediaPreviewListController(),
            tag: offlinePlaylistTag);

        getOfflineMedia(taskData.taskId);
      } else {
        _isLoading.value = false;
      }
    } else {
      id = Get.parameters["id"]!;
      loadData();
    }
  }

  void getOfflineMedia(String taskId) {
    currentOfflineTaskId = taskId;
    defaultST = Duration.zero;
    _downloadService.getTaskFilePath(taskId).then((value) {
      _isLoading.value = false;
      currentOfflineVideoUrl = value;
      playerInit(video: value);
    });
  }

  Future<void> loadData() async {
    await repository.getMedia(id, mediaType).then((value) {
      if (value.success) {
        media = value.data! as MediaModel;
        _isLoading.value = false;
        _isFavorite.value = media.liked;
        tempFavorite = media.liked;

        StorageProvider.historyList.add(HistoryMediaModel.fromMediaData(media));

        refectchRecommendation();
      } else {
        if (value.message! == "errors.privateVideo") {
          user = value.data! as UserModel;
          _errorMessage.value = value.message!;
        } else {
          _errorMessage.value = value.message!;
        }
      }
    });

    if (_errorMessage.value.isNotEmpty) {
      return;
    }

    if (media is VideoModel) {
      if ((media as VideoModel).embedUrl == null) {
        refectchVideo();
      }
    }
  }

  /// 更新画质、音质
  /// TODO 继续进度播放
  updatePlayer({
    video,
  }) {
    defaultST = plPlayerController.position.value;
    plPlayerController.removeListeners();
    plPlayerController.isBuffering.value = false;
    plPlayerController.buffered.value = Duration.zero;

    playerInit(video: video);
  }

  Future playerInit({
    video,
    audio,
    seekToTime,
    bool autoplay = true,
  }) async {
    _isLoadingPlayer.value = true;

    /// 设置/恢复 屏幕亮度
    if (brightness != null) {
      ScreenBrightness().setScreenBrightness(brightness!);
    } else {
      ScreenBrightness().resetScreenBrightness();
    }

    await plPlayerController.setDataSource(
      DataSource(
        videoSource: video ?? resolutions[resolutionIndex].src.viewUrl,
        type: DataSourceType.network,
      ),
      // 硬解
      enableHA: enableHA.value,
      seekTo: seekToTime ?? defaultST,
      autoplay: autoplay,
      onVideoLoad: () {
        if (isOffline) {
          videoPlayerServiceHandler.onVideoChange({
            "id": taskData.offlineMedia.id,
            "title": taskData.offlineMedia.title,
            "artist": taskData.offlineMedia.uploader.name,
            "duration": plPlayerController.duration.value.inSeconds,
            if (taskData.offlineMedia.coverUrl != null)
              "cover": taskData.offlineMedia.coverUrl,
          });
        } else {
          videoPlayerServiceHandler.onVideoChange({
            "id": media.id,
            "title": media.title,
            "artist": media.user.name,
            "duration": plPlayerController.duration.value.inSeconds,
            if (media.hasCover()) "cover": media.getCoverUrl(),
          });
        }
      },
    );

    /// 开启自动全屏时，在player初始化完成后立即传入headerControl
    plPlayerController.headerControl = headerControl;

    plPlayerController.width.listen((value) {
      if (value > 0 && plPlayerController.height.value > 0) {
        aspectRatio = Rational(value, plPlayerController.height.value);
      }
    });

    plPlayerController.height.listen((value) {
      if (value > 0 && plPlayerController.width.value > 0) {
        aspectRatio = Rational(plPlayerController.width.value, value);
      }
    });

    _isLoadingPlayer.value = false;
  }

  Future<void> refectchVideo() async {
    _isFectchingResolution.value = true;
    _fetchFailed.value = false;

    VideoModel video = media as VideoModel;

    await repository
        .getVideoResolutions(video.fileUrl!, video.getXVerison())
        .then((value) {
      if (value.success) {
        if (value.data!.isNotEmpty) {
          resolutions = value.data!;
          resolutionIndex = min(
              setting.get(PLPlayerConfigKey.qualityIndexSaved,
                  defaultValue: 99),
              resolutions.length - 1);
          playerInit();
          return;
        }
      }
      _fetchFailed.value = true;
    });

    _isFectchingResolution.value = false;
  }

  Future<void> refectchRecommendation() async {
    _isFectchingRecommendation.value = true;

    var result = await repository.getMoreFromUser(
      userId: media.user.id,
      mediaId: media.id,
      type: mediaType,
    );

    if (result.success) {
      moreFromUser = result.data!;
    } else {
      errorMessageRecommendation = result.message!;
      _isFectchingRecommendation.value = false;
      return;
    }

    result =
        await repository.getMoreLikeThis(mediaId: media.id, type: mediaType);

    if (result.success) {
      moreLikeThis = result.data!;
    } else {
      errorMessageRecommendation = result.message!;
      _isFectchingRecommendation.value = false;
      return;
    }

    _isFectchingRecommendation.value = false;
  }

  void favroiteMedia() {
    _isProcessingFavorite.value = true;

    _userService.favoriteMedia(media.id).then((value) {
      _isProcessingFavorite.value = false;
      if (value) {
        tempFavorite = true;
        _isFavorite.value = true;
      }
    });
  }

  void unfavoriteMedia() {
    _isProcessingFavorite.value = true;

    _userService.unfavoriteMedia(media.id).then((value) {
      _isProcessingFavorite.value = false;
      if (value) {
        tempFavorite = false;
        _isFavorite.value = false;
      }
    });
  }

  void getTranslatedContent() async {
    if (translatedContent.isNotEmpty || media.body == null) {
      return;
    }
    // TranslateProvider.google(
    //   text: media.body!,
    // ).then((value) {
    //   if (value.success) {
    //     _translatedContent.value = value.data!;
    //   } else {
    //     showToast(value.message!);
    //   }
    // });
  }
}
