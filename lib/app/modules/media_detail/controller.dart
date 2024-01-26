import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../data/enums/types.dart';
import '../../data/models/media/media.dart';
import '../../data/models/media/video.dart';
import '../../data/models/offline/history_media.dart';
import '../../data/models/offline/offline_media.dart';
import '../../data/models/resolution.dart';
import '../../data/models/user.dart';
import '../../data/providers/storage_provider.dart';
import '../../data/services/config_service.dart';
import '../../data/services/user_service.dart';
import 'repository.dart';

class MediaDetailController extends GetxController
    with GetTickerProviderStateMixin {
  final MediaDetailRepository repository = MediaDetailRepository();

  ScrollController scrollController = ScrollController();

  final UserService _userService = Get.find();
  final ConfigService configService = Get.find();

  late MediaType mediaType;
  late String id;

  List<ResolutionModel> resolutions = [];

  bool _refectchVideoCancelToken = false;

  final RxBool _isLoading = true.obs;
  final RxBool _isFectchingResolution = false.obs;
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

  @override
  void onInit() {
    super.onInit();

    dynamic arguments = Get.arguments;

    mediaType = arguments["mediaType"];
    id = arguments["id"];

    loadData();
  }

  @override
  void onClose() {
    _refectchVideoCancelToken = true;
    closePlayer();
    super.onClose();
  }

  void closePlayer() {
    // if (GetPlatform.isAndroid) {
    //   _androidService.unsetPlayer();
    // }
    // iwrPlayerController?.close();
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

  void _initPlayer() {
    // Map<String, String> resolutionsMap = {};
    // for (var resolution in resolutions) {
    //   resolutionsMap.addAll({resolution.name: resolution.src.viewUrl});
    // }

    // String tag = "${media.id}_${DateTime.now().millisecondsSinceEpoch}";

    // if (!_refectchVideoCancelToken) {
    //   Get.put(
    //     IwrPlayerController(
    //       tag: tag,
    //       id: media.id,
    //       resolutions: resolutionsMap,
    //       title: media.title,
    //       author: media.user.name,
    //       thumbnail: media.hasCover() ? media.getCoverUrl() : null,
    //       setting: configService.playerSetting,
    //       onPlayerSettingSaved: (setting) {
    //         configService.playerSetting = setting;
    //       },
    //     ),
    //     tag: tag,
    //   );

    //   iwrPlayerController = Get.find<IwrPlayerController>(tag: tag);

    //   if (GetPlatform.isAndroid) {
    //     _androidService.currentPlayer = iwrPlayerController;
    //   }

    //   iwrPlayerController!.onPlayStop = (playing) {
    //     if (playing) {
    //       scrollController.animateTo(
    //         0,
    //         duration: const Duration(milliseconds: 300),
    //         curve: Curves.ease,
    //       );
    //       _hideAppbarFactor.value = 1;
    //       lockingScroll = true;
    //     } else {
    //       lockingScroll = false;
    //     }
    //   };
    // }

    // if (_refectchVideoCancelToken) {
    //   closePlayer();
    // }
  }

  void pauseVideo() {
    // iwrPlayerController?.pause();
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
          _initPlayer();
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
