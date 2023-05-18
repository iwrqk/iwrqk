import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:better_player/src/controls/better_player_material_progress_bar.dart';
import 'package:better_player/src/core/better_player_controller.dart';
import 'package:better_player/src/core/better_player_utils.dart';
import 'package:better_player/src/video_player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../../../global_widgets/iwr_progress_indicator.dart';
import 'video_progress_bar.dart';
import '../controller.dart';

class IwrPlayerControls extends StatefulWidget {
  final BetterPlayerControlsConfiguration controlsConfiguration;
  final String id;

  const IwrPlayerControls({
    super.key,
    required this.controlsConfiguration,
    required this.id,
  });

  @override
  _IwrPlayerControlsState createState() => _IwrPlayerControlsState();
}

class _IwrPlayerControlsState
    extends BetterPlayerControlsState<IwrPlayerControls> {
  late IwrPlayerController _state;
  VideoPlayerValue? _latestValue;
  bool _hideStuff = true;
  Timer? _hideTimer;
  Timer? _initTimer;
  Timer? _showAfterExpandCollapseTimer;
  bool _displayTapped = false;
  bool _wasLoading = false;
  VideoPlayerController? _controller;
  BetterPlayerController? _betterPlayerController;
  StreamSubscription? _controlsVisibilityStreamSubscription;

  @override
  BetterPlayerController? get betterPlayerController => _betterPlayerController;

  BetterPlayerControlsConfiguration get _controlsConfiguration =>
      widget.controlsConfiguration;

  @override
  BetterPlayerControlsConfiguration get betterPlayerControlsConfiguration =>
      _controlsConfiguration;

  @override
  VideoPlayerValue? get latestValue => _latestValue;

  double get barHeight => _state.isFullScreen
      ? _controlsConfiguration.controlBarHeight + 10
      : _controlsConfiguration.controlBarHeight;

  @override
  void initState() {
    super.initState();
    _state = Get.find<IwrPlayerController>(tag: widget.id);
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    _controller?.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
    _controlsVisibilityStreamSubscription?.cancel();
  }

  @override
  void didChangeDependencies() {
    final _oldController = _betterPlayerController;
    _betterPlayerController = BetterPlayerController.of(context);
    _controller = _betterPlayerController!.videoPlayerController;
    _latestValue = _controller!.value;

    if (_oldController != _betterPlayerController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  void _startHideTimer() {
    if (_betterPlayerController!.controlsAlwaysVisible) {
      return;
    }
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  @override
  void cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
      _displayTapped = true;
    });
  }

  Future<void> _initialize() async {
    _controller!.addListener(_updateState);

    _updateState();

    if ((_controller!.value.isPlaying) ||
        _betterPlayerController!.betterPlayerConfiguration.autoPlay) {
      _startHideTimer();
    }

    if (_controlsConfiguration.showControlsOnInitialize) {
      _initTimer = Timer(const Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }

    _controlsVisibilityStreamSubscription =
        _betterPlayerController!.controlsVisibilityStream.listen((state) {
      setState(() {
        _hideStuff = !state;
      });
      if (!_hideStuff) {
        cancelAndRestartTimer();
      }
    });
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      _state.toggleFullScreen();
      _showAfterExpandCollapseTimer =
          Timer(_controlsConfiguration.controlsHideTime, () {
        setState(() {
          cancelAndRestartTimer();
        });
      });
    });
  }

  void _updateState() {
    if (mounted) {
      if (!_hideStuff ||
          isVideoFinished(_controller!.value) ||
          _wasLoading ||
          isLoading(_controller!.value)) {
        setState(() {
          _latestValue = _controller!.value;
          if (isVideoFinished(_latestValue)) {
            _hideStuff = false;
          }
        });
      }
    }
  }

  Widget _buildErrorWidget() {
    final errorBuilder =
        _betterPlayerController!.betterPlayerConfiguration.errorBuilder;
    if (errorBuilder != null) {
      return errorBuilder(
          context,
          _betterPlayerController!
              .videoPlayerController!.value.errorDescription);
    } else {
      final textStyle = TextStyle(color: _controlsConfiguration.textColor);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.triangleExclamation,
              color: _controlsConfiguration.iconsColor,
              size: 42,
            ),
            const SizedBox(height: 8),
            Text(
              _betterPlayerController!.translations.generalDefaultError,
              style: textStyle,
            ),
            if (_controlsConfiguration.enableRetry)
              CupertinoButton(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.zero,
                onPressed: () {
                  _betterPlayerController!.retryDataSource();
                },
                child: Text(
                  _betterPlayerController!.translations.generalRetry,
                  style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              )
          ],
        ),
      );
    }
  }

  void _onPlayPause() {
    bool isFinished = false;

    if (_latestValue?.position != null && _latestValue?.duration != null) {
      isFinished = _latestValue!.position >= _latestValue!.duration!;
    }

    setState(() {
      if (_controller!.value.isPlaying) {
        _hideStuff = false;
        _hideTimer?.cancel();
        _betterPlayerController!.pause();
      } else {
        cancelAndRestartTimer();

        if (!_controller!.value.initialized) {
        } else {
          if (isFinished) {
            _betterPlayerController!.seekTo(const Duration());
          }
          _betterPlayerController!.play();
          _betterPlayerController!.cancelNextVideoTimer();
        }
      }
    });
  }

  Widget _buildProgressBar() {
    return Obx(() {
      int? positionAfterAdjust =
          _state.positionAfterAdjust == -1 ? null : _state.positionAfterAdjust;

      return Expanded(
        child: IwrVideoProgressBar(
          _controller,
          _betterPlayerController,
          previewPositionAfterAdjust: positionAfterAdjust,
          onDragStart: () {
            _hideTimer?.cancel();
          },
          onDragEnd: () {
            _startHideTimer();
          },
          colors: BetterPlayerProgressColors(
            playedColor: _controlsConfiguration.progressBarPlayedColor,
            handleColor: _controlsConfiguration.progressBarHandleColor,
            bufferedColor: _controlsConfiguration.progressBarBufferedColor,
            backgroundColor: _controlsConfiguration.progressBarBackgroundColor,
          ),
        ),
      );
    });
  }

  Widget _buildPosition() {
    return Obx(() {
      final duration = _latestValue != null && _latestValue!.duration != null
          ? _latestValue!.duration!
          : Duration.zero;

      int? positionAfterAdjust =
          _state.positionAfterAdjust == -1 ? null : _state.positionAfterAdjust;
      var position =
          _latestValue != null ? _latestValue!.position : Duration.zero;
      if (positionAfterAdjust != null) {
        position = Duration(milliseconds: positionAfterAdjust);
      }

      return Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Text(
          '${BetterPlayerUtils.formatDuration(position)} / ${BetterPlayerUtils.formatDuration(duration)}',
          style: TextStyle(
            fontSize: 14,
            color: _controlsConfiguration.textColor,
            decoration: TextDecoration.none,
          ),
        ),
      );
    });
  }

  Widget? _buildLoadingWidget() {
    if (_controlsConfiguration.loadingWidget != null) {
      return _controlsConfiguration.loadingWidget;
    }

    return IwrProgressIndicator(
      valueColor:
          AlwaysStoppedAnimation<Color>(_controlsConfiguration.loadingColor),
    );
  }

  Widget _buildHitArea() {
    if (!betterPlayerController!.controlsEnabled) {
      return const SizedBox();
    }
    return Obx(
      () => Expanded(
        child: _state.quickGesture != QuickGestures.none
            ? Center(
                child: _buildQuickGesturesSignal(),
              )
            : Container(
                color: Colors.transparent,
                child: Center(
                  child: AnimatedOpacity(
                    opacity: _hideStuff ? 0.0 : 1.0,
                    duration: _controlsConfiguration.controlsHideTime,
                    child: Stack(
                      fit: StackFit.expand,
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildTopBar() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: _controlsConfiguration.controlsHideTime,
      child: Container(
        height: barHeight,
        padding: EdgeInsets.fromLTRB(5, _state.isFullScreen ? 10 : 5, 5, 5),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black45,
              Colors.black26,
              Colors.black12,
              Colors.transparent
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          children: [if (_state.isFullScreen) _buildExitButton()],
        ),
      ),
    );
  }

  Widget _buildExitButton() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: _controlsConfiguration.controlsHideTime,
      child: Container(
        alignment: Alignment.center,
        height: barHeight,
        child: IconButton(
          iconSize: 30,
          onPressed: () {
            _onExpandCollapse();
          },
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandButton() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: _controlsConfiguration.controlsHideTime,
      child: Container(
        alignment: Alignment.center,
        height: barHeight,
        child: IconButton(
          iconSize: 30,
          onPressed: () {
            _onExpandCollapse();
          },
          icon: FaIcon(
            _state.isFullScreen
                ? FontAwesomeIcons.compress
                : FontAwesomeIcons.expand,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  Widget _buildPlaybackSpeedButton() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: _controlsConfiguration.controlsHideTime,
      child: Container(
        alignment: Alignment.center,
        height: barHeight,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: MaterialButton(
          onPressed: () {
            _pushPlaybackSpeedSelectionMune();
          },
          padding: EdgeInsets.zero,
          minWidth: 0,
          child: Text(
            _state.availablePlaybackSpeeds.keys
                .toList()[_state.currentPlaybackSpeedIndex],
            style: TextStyle(color: Colors.white, fontSize: 17.5),
          ),
        ),
      ),
    );
  }

  Widget _buildResolutionsButton() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: _controlsConfiguration.controlsHideTime,
      child: Container(
        alignment: Alignment.center,
        height: barHeight,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: MaterialButton(
          onPressed: () {
            _pushResolutionsSelectionMune();
          },
          padding: EdgeInsets.zero,
          minWidth: 0,
          child: Text(
            _state.resolutions.keys.toList()[_state.currentResolutionIndex],
            style: TextStyle(color: Colors.white, fontSize: 17.5),
          ),
        ),
      ),
    );
  }

  AnimatedOpacity _buildBottomBar() {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: _controlsConfiguration.controlsHideTime,
      child: Container(
        height: barHeight,
        padding: EdgeInsets.fromLTRB(5, 5, 5, _state.isFullScreen ? 10 : 5),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black12,
              Colors.black26,
              Colors.black45
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: barHeight,
              child: IconButton(
                iconSize: 30,
                padding: EdgeInsets.symmetric(horizontal: 8),
                icon: _controller!.value.isPlaying
                    ? FaIcon(
                        FontAwesomeIcons.pause,
                        color: Colors.white,
                        size: 25,
                      )
                    : FaIcon(
                        FontAwesomeIcons.play,
                        color: Colors.white,
                        size: 25,
                      ),
                onPressed: _onPlayPause,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildPosition(),
                  _buildProgressBar(),
                ],
              ),
            ),
            if (_state.isFullScreen) _buildPlaybackSpeedButton(),
            if (_state.isFullScreen) _buildResolutionsButton(),
            if (!_state.isFullScreen) _buildExpandButton(),
          ],
        ),
      ),
    );
  }

  void _pushPlaybackSpeedSelectionMune() {
    setState(() {
      _hideStuff = true;
    });

    if (_controller!.value.size == null) {
      return;
    }

    double videoWidth = _controller!.value.size!.width;
    double videoHeight = _controller!.value.size!.height;

    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) =>
          _buildPlaybackSpeedSelectionMune(context, videoWidth > videoHeight),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = videoWidth > videoHeight ? Offset(1, 0) : Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ));
  }

  Widget _buildPlaybackSpeedSelectionMune(
      BuildContext context, bool isLandscapeVideo) {
    return _buildPopupSelectionMune(
      context: context,
      child: Container(
        alignment: Alignment.center,
        child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: _state.availablePlaybackSpeeds.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (index == _state.currentPlaybackSpeedIndex) return;
                  _state.changePlaybackSpeed(index);
                  Navigator.of(context).pop();
                },
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      _state.availablePlaybackSpeeds.keys.toList()[index],
                      style: TextStyle(
                          color: index == _state.currentPlaybackSpeedIndex
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          fontSize: 17.5),
                    )),
              );
            }),
      ),
      isLandscapeVideo: isLandscapeVideo,
    );
  }

  void _pushResolutionsSelectionMune() {
    setState(() {
      _hideStuff = true;
    });

    if (_controller!.value.size == null) {
      return;
    }

    double videoWidth = _controller!.value.size!.width;
    double videoHeight = _controller!.value.size!.height;

    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) =>
          _buildResolutionsSelectionMune(context, videoWidth > videoHeight),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = videoWidth > videoHeight ? Offset(1, 0) : Offset(0, 1);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ));
  }

  Widget _buildResolutionsSelectionMune(
      BuildContext context, bool isLandscapeVideo) {
    return _buildPopupSelectionMune(
      context: context,
      child: Container(
        alignment: Alignment.center,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: _state.resolutions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (index == _state.currentResolutionIndex) {
                  return;
                }
                _state.changeResolution(index);
                Navigator.of(context).pop();
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _state.resolutions.keys.toList()[index],
                  style: TextStyle(
                      color: index == _state.currentResolutionIndex
                          ? Theme.of(context).primaryColor
                          : Colors.white,
                      fontSize: 17.5),
                ),
              ),
            );
          },
        ),
      ),
      isLandscapeVideo: isLandscapeVideo,
    );
  }

  Widget _buildPopupSelectionMune({
    required BuildContext context,
    required Widget child,
    required bool isLandscapeVideo,
  }) {
    return isLandscapeVideo
        ? Material(
            type: MaterialType.transparency,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(onTap: () {
                    Navigator.of(context).pop();
                  }),
                ),
                Container(
                    height: double.infinity,
                    width: MediaQuery.of(context).size.width / 4,
                    color: Colors.black.withOpacity(0.75),
                    child: child)
              ],
            ),
          )
        : Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(onTap: () {
                    Navigator.of(context).pop();
                  }),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.75),
                  child: child,
                )
              ],
            ),
          );
  }

  Widget _buildQuickGesturesWidget(Widget child) {
    return GestureDetector(
      onLongPressStart: (details) {
        if (!_controller!.value.isPlaying) return;
        _state.dragging = true;
        _state.quickGesture = QuickGestures.accelerate;
        _state.setPlaybackSpeed(2);
      },
      onLongPressEnd: (details) {
        if (!_controller!.value.isPlaying) return;
        _state.dragging = false;
        _state.quickGesture = QuickGestures.none;
        _state.setPlaybackSpeed(1);
      },
      onVerticalDragUpdate: (details) {
        final double delta =
            -(details.primaryDelta ?? 0 / context.size!.height);
        if (delta.abs() < 0.1) return;
        _state.gesturesDragTotalDelta += delta / 2.5;
        _state.quickGesture =
            delta >= 0 ? QuickGestures.volumeUp : QuickGestures.volumeDown;
      },
      onVerticalDragEnd: (details) {
        _state.dragging = false;
        _state.quickGesture = QuickGestures.none;

        _state.setVolume(_getVolumeAfterAdjust());
        _state.gesturesDragTotalDelta = 0;
      },
      onHorizontalDragUpdate: (details) {
        final double delta = details.primaryDelta ?? 0 / context.size!.width;
        if (delta.abs() < 0.1) return;
        _state.gesturesDragTotalDelta +=
            _controller!.value.duration!.inMilliseconds * delta ~/ 5000;
        _state.quickGesture =
            delta >= 0 ? QuickGestures.fastForward : QuickGestures.fastRewind;
        _updatePositionAfterAdjust();
      },
      onHorizontalDragEnd: (details) {
        int destination = _state.positionAfterAdjust;
        _state.dragging = false;
        _state.quickGesture = QuickGestures.none;
        if (destination > _controller!.value.duration!.inMilliseconds) {
          destination = _controller!.value.duration!.inMilliseconds;
        }
        _state.gesturesDragTotalDelta = 0;
        _state.seekTo(Duration(milliseconds: destination));
        _updatePositionAfterAdjust();
      },
      child: child,
    );
  }

  Widget? _buildQuickGesturesSignal() {
    switch (_state.quickGesture) {
      case QuickGestures.accelerate:
        return Container(
          padding: _state.isFullScreen
              ? EdgeInsets.symmetric(vertical: 10, horizontal: 30)
              : EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.black.withAlpha(128),
              borderRadius: BorderRadius.circular(5)),
          child: Icon(
            FontAwesomeIcons.forward,
            color: Colors.white,
            size: 20,
          ),
        );
      case QuickGestures.fastForward:
        return Container(
          padding: _state.isFullScreen
              ? EdgeInsets.symmetric(vertical: 10, horizontal: 30)
              : EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.black.withAlpha(128),
              borderRadius: BorderRadius.circular(5)),
          child: Icon(
            FontAwesomeIcons.forward,
            color: Colors.white,
            size: 20,
          ),
        );
      case QuickGestures.fastRewind:
        return Container(
          padding: _state.isFullScreen
              ? EdgeInsets.symmetric(vertical: 10, horizontal: 30)
              : EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
              color: Colors.black.withAlpha(128),
              borderRadius: BorderRadius.circular(5)),
          child: Icon(
            FontAwesomeIcons.backward,
            color: Colors.white,
            size: 20,
          ),
        );
      case QuickGestures.volumeUp:
        return Container(
          padding: _state.isFullScreen
              ? EdgeInsets.symmetric(vertical: 10, horizontal: 30)
              : EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(128),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSpeakerIcon(),
              Container(
                width: _state.isFullScreen ? 150 : 100,
                margin: EdgeInsets.only(left: 10),
                child: LinearProgressIndicator(
                  value: _getVolumeAfterAdjust(),
                  backgroundColor: Colors.white.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        );
      case QuickGestures.volumeDown:
        return Container(
          padding: _state.isFullScreen
              ? EdgeInsets.symmetric(vertical: 10, horizontal: 30)
              : EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(128),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildSpeakerIcon(),
              Container(
                width: _state.isFullScreen ? 150 : 100,
                margin: EdgeInsets.only(left: 10),
                child: LinearProgressIndicator(
                  value: _getVolumeAfterAdjust(),
                  backgroundColor: Colors.white.withOpacity(0.5),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        );
      default:
        return null;
    }
  }

  Widget _buildSpeakerIcon() {
    return SizedBox(
        width: 25,
        height: 25,
        child: FaIcon(
          _getVolumeAfterAdjust() > 0
              ? _getVolumeAfterAdjust() > 0.5
                  ? FontAwesomeIcons.volumeHigh
                  : FontAwesomeIcons.volumeLow
              : FontAwesomeIcons.volumeXmark,
          color: Colors.white,
          size: 20,
        ));
  }

  void _updatePositionAfterAdjust() {
    if (_state.quickGesture == QuickGestures.fastForward ||
        _state.quickGesture == QuickGestures.fastRewind) {
      int finalValue = _controller!.value.position.inMilliseconds +
          _state.gesturesDragTotalDelta.toInt();
      if (finalValue < 0) {
        finalValue = 0;
      } else if (finalValue > _controller!.value.duration!.inMilliseconds) {
        finalValue = _controller!.value.position.inMilliseconds;
      }
      _state.positionAfterAdjust = finalValue;
      return;
    }
    _state.positionAfterAdjust = -1;
  }

  double _getVolumeAfterAdjust() {
    double finalValue =
        _controller!.value.volume + _state.gesturesDragTotalDelta / 100;
    if (finalValue < 0) {
      finalValue = 0;
    } else if (finalValue > 1) {
      finalValue = 1;
    }
    return finalValue;
  }

  @override
  Widget build(BuildContext context) {
    _wasLoading = isLoading(_latestValue);
    if (_latestValue?.hasError == true) {
      return Container(
        color: Colors.black,
        child: _buildErrorWidget(),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedOpacity(
          opacity: _hideStuff ? 0 : 1,
          duration: widget.controlsConfiguration.controlsHideTime,
        ),
        _buildQuickGesturesWidget(
          GestureDetector(
            onTap: () {
              _hideStuff
                  ? cancelAndRestartTimer()
                  : setState(() {
                      _hideStuff = true;
                    });
            },
            onDoubleTap: () {
              cancelAndRestartTimer();
              _onPlayPause();
            },
            child: AbsorbPointer(
              absorbing: _hideStuff,
              child: Column(
                children: [
                  _buildTopBar(),
                  if (_wasLoading)
                    Expanded(child: Center(child: _buildLoadingWidget()))
                  else
                    _buildHitArea(),
                  _buildBottomBar(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
