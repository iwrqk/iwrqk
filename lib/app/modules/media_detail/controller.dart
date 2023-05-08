import 'package:flutter/animation.dart';
import 'package:get/get.dart';

import '../../data/enums/types.dart';
import '../../data/models/media/media.dart';
import '../../data/models/media/video.dart';
import '../../data/models/offline/offline_meida.dart';
import '../../data/models/resolution.dart';
import '../../data/services/config_service.dart';
import '../../data/services/user_service.dart';
import 'repository.dart';
import 'widgets/iwr_player/iwr_video_player.dart';

class MediaDetailController extends GetxController
    with GetTickerProviderStateMixin {
  final MediaDetailRepository repository = MediaDetailRepository();

  final UserService _userService = Get.find();
  final ConfigService configService = Get.find();

  late MediaType mediaType;
  late String id;
  late OfflineMediaModel offlineMedia;

  List<ResolutionModel> resolutions = [];

  IwrVideoController? _iwrVideoController;

  late Rx<AnimationController> _animationController;
  final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);
  late Animation<double> _iconTurn;
  late Animation<double> _heightFactor;

  final RxBool _isLoading = true.obs;
  final RxBool _isFectchingResolution = false.obs;
  final RxBool _isFectchingRecommendation = true.obs;
  final RxBool _detailExpanded = false.obs;

  final RxBool _isFavorite = false.obs;
  final RxBool _isProcessingFavorite = false.obs;

  bool get isFavorite => _isFavorite.value;
  bool get isProcessingFavorite => _isProcessingFavorite.value;

  late MediaModel media;

  late List<MediaModel> moreFromUser;

  late List<MediaModel> moreLikeThis;

  IwrVideoController? get iwrVideoController => _iwrVideoController;

  AnimationController get animationController => _animationController.value;
  Animation<double> get iconTurn => _iconTurn;
  Animation<double> get heightFactor => _heightFactor;

  bool get isLoading => _isLoading.value;
  bool get isFectchingResolution => _isFectchingResolution.value;
  bool get isFectchingRecommendation => _isFectchingRecommendation.value;
  bool get detailExpanded => _detailExpanded.value;

  set detailExpanded(bool value) {
    _detailExpanded.value = value;
  }

  final RxBool _fetchFailed = false.obs;

  final RxString _errorMessage = "".obs;

  final RxString _errorMessageRecommendation = "".obs;

  bool get fetchFailed => _fetchFailed.value;

  String get errorMessage => _errorMessage.value;

  String get errorMessageRecommendation => _errorMessageRecommendation.value;

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
    offlineMedia = arguments["offlineMedia"];

    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    ).obs;

    _iconTurn =
        _animationController.value.drive(_halfTween.chain(_easeInTween));

    _heightFactor = _animationController.value.drive(_easeInTween);

    loadData();
  }

  @override
  void onClose() {
    _animationController.value.dispose();
    super.onClose();
  }

  Future<void> loadData() async {
    await repository.getMeida(id, mediaType).then((value) {
      if (value.success) {
        media = value.data!;
        _isLoading.value = false;
        _isFavorite.value = value.data!.liked;

        refectchRecommendation();
      } else {
        if (value.message! == "errors.privateVideo") {
          media = value.data!;
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
        refectchVideos();
      }
    }
  }

  void _initializePlayerController() {
    _iwrVideoController = IwrVideoController(
      availableResolutions: resolutions,
      initResolutionindex: resolutions.length - 1,
      callbackAfterInit: () {},
    );
  }

  void pauseVideo() {
    _iwrVideoController?.pauseVideo();
  }

  Future<void> refectchVideos() async {
    _isFectchingResolution.value = true;
    _fetchFailed.value = true;

    VideoModel video = media as VideoModel;

    await repository
        .getVideoResolutions(video.fileUrl!, video.getXVerison())
        .then((value) {
      if (value.success) {
        if (value.data!.isNotEmpty) {
          resolutions = value.data!;
          _fetchFailed.value = false;
          _initializePlayerController();
        }
      }
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
      _fetchFailed.value = true;
      return;
    }

    result =
        await repository.getMoreLikeThis(mediaId: media.id, type: mediaType);

    if (result.success) {
      moreLikeThis = result.data!;
    } else {
      errorMessageRecommendation = result.message!;
      _isFectchingRecommendation.value = false;
      _fetchFailed.value = true;
      return;
    }

    _isFectchingRecommendation.value = false;
  }

  void favroiteMedia() {
    _isProcessingFavorite.value = true;

    _userService.favoriteMedia(media.id).then((value) {
      _isProcessingFavorite.value = false;
      if (value) {
        _isFavorite.value = true;
      }
    });
  }

  void unfavoriteMedia() {
    _isProcessingFavorite.value = true;

    _userService.unfavoriteMedia(media.id).then((value) {
      _isProcessingFavorite.value = false;
      if (value) {
        _isFavorite.value = false;
      }
    });
  }
}
