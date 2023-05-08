/*
  This code contains modifications to the original [chewie] library,
  which is licensed under the MIT license. The modifications are also subject
  to the terms of the MIT license. For more information, please see the LICENSE
  file included with the original library.
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../../../data/models/resolution.dart';
import 'iwr_video_controls.dart';

class IwrVideoPlayer extends StatefulWidget {
  IwrVideoPlayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  late IwrVideoController controller;

  @override
  IwrVideoPlayerState createState() {
    return IwrVideoPlayerState();
  }
}

class IwrVideoPlayerState extends State<IwrVideoPlayer> {
  bool _isFullScreen = false;

  bool get isControllerFullScreen => widget.controller.isFullScreen;
  late PlayerNotifier notifier;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listener);
    notifier = PlayerNotifier.init();
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(IwrVideoPlayer oldWidget) {
    if (oldWidget.controller != widget.controller) {
      widget.controller.addListener(listener);
    }
    super.didUpdateWidget(oldWidget);
    if (_isFullScreen != isControllerFullScreen) {
      widget.controller.isFullScreen = _isFullScreen;
    }
  }

  Future<void> listener() async {
    if (widget.controller.disableListener) {
      widget.controller.disableListener = false;
      return;
    }
    if (isControllerFullScreen && !_isFullScreen) {
      _isFullScreen = isControllerFullScreen;
      await _pushFullScreenWidget(context);
    } else if (_isFullScreen) {
      Navigator.of(context, rootNavigator: true).pop();
      _isFullScreen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IwrVideoControllerProvider(
      controller: widget.controller,
      child: ChangeNotifierProvider<PlayerNotifier>.value(
        value: notifier,
        builder: (context, w) => IwrVideoPlayerWithControls(),
      ),
    );
  }

  Widget _fullScreenRoutePageBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final controllerProvider = IwrVideoControllerProvider(
      controller: widget.controller,
      child: ChangeNotifierProvider<PlayerNotifier>.value(
        value: notifier,
        builder: (context, w) => IwrVideoPlayerWithControls(),
      ),
    );
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: controllerProvider,
          ),
        );
      },
    );
  }

  Future<dynamic> _pushFullScreenWidget(BuildContext context) async {
    final TransitionRoute<void> route = PageRouteBuilder<void>(
      pageBuilder: _fullScreenRoutePageBuilder,
    );

    onEnterFullScreen();

    Wakelock.enable();

    await Navigator.of(context, rootNavigator: true).push(route);

    _isFullScreen = false;
    widget.controller.exitFullScreen();

    Wakelock.disable();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  void onEnterFullScreen() {
    final videoWidth =
        widget.controller.videoPlayerController!.value.size.width;
    final videoHeight =
        widget.controller.videoPlayerController!.value.size.height;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

    final isLandscapeVideo = videoWidth > videoHeight;
    final isPortraitVideo = videoWidth < videoHeight;

    if (isLandscapeVideo) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else if (isPortraitVideo) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    }
  }
}

class IwrVideoPlayerWithControls extends StatefulWidget {
  IwrVideoPlayerWithControls({
    Key? key,
  }) : super(key: key);

  @override
  IwrVideoPlayerWithControlsState createState() {
    return IwrVideoPlayerWithControlsState();
  }
}

class IwrVideoPlayerWithControlsState
    extends State<IwrVideoPlayerWithControls> {
  late IwrVideoController iwrVideoController;

  void listener() async {
    if (!mounted) return;

    setState(() {});
  }

  @override
  void dispose() {
    iwrVideoController.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    iwrVideoController = IwrVideoController.of(context);
    iwrVideoController.addListener(listener);

    Widget videoWidget = Container();

    if (iwrVideoController.errorMessage == null &&
        !iwrVideoController.renewing &&
        iwrVideoController.videoPlayerController != null) {
      if (iwrVideoController.videoPlayerController!.value.isInitialized) {
        videoWidget = AspectRatio(
            aspectRatio:
                iwrVideoController.videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(iwrVideoController.videoPlayerController!));
      }
    }

    return Container(
      color: Colors.black,
      child: Stack(children: [
        Center(child: videoWidget),
        if (iwrVideoController.videoPlayerController != null) IwrVideoControl(),
      ]),
    );
  }
}

class PlayerNotifier extends ChangeNotifier {
  PlayerNotifier._(
    bool hideStuff,
  ) : _hideStuff = hideStuff;

  bool _hideStuff;

  bool get hideStuff => _hideStuff;

  set hideStuff(bool value) {
    _hideStuff = value;
    notifyListeners();
  }

  // ignore: prefer_constructors_over_static_methods
  static PlayerNotifier init() {
    return PlayerNotifier._(
      true,
    );
  }
}

class IwrVideoController extends ChangeNotifier {
  final List<ResolutionModel> availableResolutions;

  final int initResolutionindex;

  VideoPlayerController? videoPlayerController;

  VoidCallback callbackAfterInit;

  String? errorMessage;

  bool disableListener = false;

  final Map<String, double> availablePlaybackSpeedMap = {
    '0.5x': 0.5,
    '0.75x': 0.75,
    '1.0x': 1,
    '1.25x': 1.25,
    '1.5x': 1.5,
    '2.0x': 2
  };

  VideoPlayerValue? _valueBeforeRenewing;

  VideoPlayerValue? get valueBeforeRenewing => _valueBeforeRenewing;

  set valueBeforeRenewing(value) => _valueBeforeRenewing = value;

  int _currentSpeedIndex = 2;

  int get currentSpeedIndex => _currentSpeedIndex;

  set currentSpeedIndex(value) => _currentSpeedIndex = value;

  int _currentResolutionIndex = 0;

  int get currentResolutionIndex => _currentResolutionIndex;

  set currentResolutionIndex(value) => _currentResolutionIndex = value;

  bool _isFullScreen = false;

  bool get isFullScreen => _isFullScreen;

  set isFullScreen(value) => _isFullScreen = value;

  bool _renewing = false;

  bool get renewing => _renewing;

  set renewing(value) => _renewing = value;

  bool _renewed = false;

  bool get renewed => _renewed;

  set renewed(value) => _renewed = value;

  bool _isDisposed = false;

  IwrVideoController(
      {required this.availableResolutions,
      required this.initResolutionindex,
      required this.callbackAfterInit}) {
    initize();
  }

  @override
  void dispose() {
    _isDisposed = true;
    videoPlayerController?.dispose();
    super.dispose();
  }

  void pauseVideo() {
    if (videoPlayerController != null) {
      if (videoPlayerController!.value.isInitialized ||
          videoPlayerController!.value.isPlaying) {
        videoPlayerController!.pause();
      }
    }
  }

  Future<void> initize() async {
    if (availableResolutions.isEmpty) return;
    currentResolutionIndex = initResolutionindex;
    try {
      videoPlayerController = VideoPlayerController.network(
        availableResolutions[initResolutionindex].src.viewUrl,
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
      );
      await videoPlayerController!.initialize();
    } catch (e) {
      errorMessage = "$e";
    }
    if (!_isDisposed) notifyListeners();
    callbackAfterInit.call();
  }

  static IwrVideoController of(BuildContext context) {
    final iwrVideoPlayerControllerProvider = context
        .dependOnInheritedWidgetOfExactType<IwrVideoControllerProvider>()!;

    return iwrVideoPlayerControllerProvider.controller;
  }

  Future<void> renew(String videoUrl) async {
    if (errorMessage != null) {
      errorMessage = null;
    }
    _renewing = true;
    disableListener = true;

    if (!_isDisposed) notifyListeners();
    try {
      videoPlayerController?.dispose();
      videoPlayerController = VideoPlayerController.network(
        videoUrl,
        videoPlayerOptions: VideoPlayerOptions(allowBackgroundPlayback: true),
      );
      await videoPlayerController!.initialize();
      callbackAfterInit.call();
    } catch (e) {
      errorMessage = "$e";
      callbackAfterInit.call();
    }
    _renewing = false;
    _renewed = true;
    disableListener = true;

    if (!_isDisposed) notifyListeners();
  }

  void changeResolution(index) {
    if (_isDisposed) return;
    currentResolutionIndex = index;
    notifyListeners();
  }

  void enterFullScreen() {
    if (_isDisposed) return;
    _isFullScreen = true;
    notifyListeners();
  }

  void exitFullScreen() {
    if (_isDisposed) return;
    _isFullScreen = false;
    notifyListeners();
  }

  void toggleFullScreen() {
    if (_isDisposed) return;
    _isFullScreen = !_isFullScreen;
    notifyListeners();
  }
}

class IwrVideoControllerProvider extends InheritedWidget {
  const IwrVideoControllerProvider({
    Key? key,
    required this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  final IwrVideoController controller;

  @override
  bool updateShouldNotify(IwrVideoControllerProvider oldWidget) => true;
}
