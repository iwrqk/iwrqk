/*
  This code contains modifications to the original [chewie] library,
  which is licensed under the MIT license. The modifications are also subject
  to the terms of the MIT license. For more information, please see the LICENSE
  file included with the original library.
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../global_widgets/iwr_progress_indicator.dart';
import 'center_play_button.dart';
import 'iwr_video_player.dart';
import 'video_progress_bar.dart';

enum QuickGestures {
  none,
  accelerate,
  volumeUp,
  volumeDown,
  fastForward,
  fastRewind
}

class IwrVideoControl extends StatefulWidget {
  const IwrVideoControl({super.key});

  @override
  _IwrVideoControlState createState() => _IwrVideoControlState();
}

class _IwrVideoControlState extends State<IwrVideoControl> {
  VideoPlayerController get videoPlayerController =>
      iwrVideoController.videoPlayerController!;

  IwrVideoController get iwrVideoController => _iwrVideoController!;
  IwrVideoController? _iwrVideoController;

  late PlayerNotifier notifier;
  late VideoPlayerValue _latestValue;
  Timer? _hideTimer;
  Timer? _initTimer;
  Timer? _showAfterExpandCollapseTimer;
  Timer? _bufferingDisplayTimer;
  bool _dragging = false;
  bool _displayTapped = false;
  bool _displayBufferingIndicator = false;

  QuickGestures _quickGestures = QuickGestures.none;

  double _gesturesDragTotalDelta = 0;

  final barHeight = 30.0;

  @override
  void initState() {
    super.initState();
    notifier = Provider.of<PlayerNotifier>(context, listen: false);
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    videoPlayerController.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final oldController = _iwrVideoController;
    _iwrVideoController = IwrVideoController.of(context);

    if (oldController != _iwrVideoController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  Future<void> _renewPlayer() async {
    _dispose();
    if (iwrVideoController.valueBeforeRenewing != null) {
      await videoPlayerController
          .seekTo(iwrVideoController.valueBeforeRenewing!.position);
      await videoPlayerController.setPlaybackSpeed(iwrVideoController
          .availablePlaybackSpeedMap.values
          .toList()[iwrVideoController.currentSpeedIndex]);
      if (iwrVideoController.valueBeforeRenewing!.isPlaying) {
        await videoPlayerController.play();
      }
    }
    await _initialize();
  }

  Future<void> _initialize() async {
    videoPlayerController.addListener(_updateState);

    _updateState();

    if (videoPlayerController.value.isPlaying) {
      _startHideTimer();
    }

    _initTimer = Timer(const Duration(milliseconds: 200), () {
      if (!mounted) return;

      setState(() {
        notifier.hideStuff = false;
      });
    });
  }

  void _updateState() {
    if (!mounted) return;

    _displayBufferingIndicator = videoPlayerController.value.isBuffering;

    setState(() {
      _latestValue = videoPlayerController.value;
    });
  }

  String _formatDuration(Duration duration) {
    List<String> parts = duration.toString().split(".");
    return parts.first;
  }

  void _startHideTimer() {
    final hideControlsTimer = Duration(seconds: 3);
    _hideTimer = Timer(hideControlsTimer, () {
      setState(() {
        notifier.hideStuff = true;
      });
    });
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      notifier.hideStuff = false;
      _displayTapped = true;
    });
  }

  void _playPause() {
    final isFinished = _latestValue.position >= _latestValue.duration;

    setState(() {
      if (videoPlayerController.value.isPlaying) {
        notifier.hideStuff = false;
        _hideTimer?.cancel();
        videoPlayerController.pause();
      } else {
        _cancelAndRestartTimer();

        if (!videoPlayerController.value.isInitialized) {
          videoPlayerController.initialize().then((_) {
            videoPlayerController.play();
          });
        } else {
          if (isFinished) {
            videoPlayerController.seekTo(Duration.zero);
          }
          videoPlayerController.play();
        }
      }
    });
  }

  void _onExpandCollapse(BuildContext context) {
    setState(() {
      notifier.hideStuff = true;

      iwrVideoController.toggleFullScreen();

      _showAfterExpandCollapseTimer =
          Timer(const Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _pushPlaybackSpeedSelectionMune(BuildContext context) {
    setState(() {
      notifier.hideStuff = true;
    });

    double videoWidth = videoPlayerController.value.size.width;
    double videoHeight = videoPlayerController.value.size.height;

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

  void _pushResolutionsSelectionMune(BuildContext context) {
    setState(() {
      notifier.hideStuff = true;
    });
    double videoWidth = videoPlayerController.value.size.width;
    double videoHeight = videoPlayerController.value.size.height;

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

  Widget _buildPopupSelectionMune(
      BuildContext context, Widget child, bool isLandscapeVideo) {
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
                    child: child)
              ],
            ),
          );
  }

  Widget _buildPlaybackSpeedSelectionMune(
      BuildContext context, bool isLandscapeVideo) {
    return _buildPopupSelectionMune(
      context,
      Container(
        alignment: Alignment.center,
        child: ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: iwrVideoController.availablePlaybackSpeedMap.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (index == iwrVideoController.currentSpeedIndex) return;
                  iwrVideoController.currentSpeedIndex = index;
                  videoPlayerController.setPlaybackSpeed(iwrVideoController
                      .availablePlaybackSpeedMap.values
                      .toList()[index]);
                  Navigator.of(context).pop();
                },
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      iwrVideoController.availablePlaybackSpeedMap.keys
                          .toList()[index],
                      style: TextStyle(
                          color: index == iwrVideoController.currentSpeedIndex
                              ? Theme.of(context).primaryColor
                              : Colors.white,
                          fontSize: 17.5),
                    )),
              );
            }),
      ),
      isLandscapeVideo,
    );
  }

  Widget _buildResolutionsSelectionMune(
      BuildContext context, bool isLandscapeVideo) {
    return _buildPopupSelectionMune(
      context,
      Container(
        alignment: Alignment.center,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: iwrVideoController.availableResolutions.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  if (index == iwrVideoController.currentResolutionIndex) {
                    return;
                  }
                  iwrVideoController.currentResolutionIndex = index;
                  iwrVideoController.valueBeforeRenewing =
                      videoPlayerController.value;
                  iwrVideoController.pauseVideo();
                  iwrVideoController.renew(iwrVideoController
                      .availableResolutions[index].src.viewUrl);

                  Navigator.of(context).pop();
                },
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      iwrVideoController.availableResolutions[index].name,
                      style: TextStyle(
                          color:
                              index == iwrVideoController.currentResolutionIndex
                                  ? Theme.of(context).primaryColor
                                  : Colors.white,
                          fontSize: 17.5),
                    )));
          },
        ),
      ),
      isLandscapeVideo,
    );
  }

  Widget _buildHitArea(BuildContext context) {
    final bool isFinished = _latestValue.position >= _latestValue.duration;
    final bool showPlayButton = !_dragging && !notifier.hideStuff;

    return _quickGestures != QuickGestures.none
        ? Center(
            child: _buildQuickGesturesSignal(),
          )
        : GestureDetector(
            onTap: () {
              if (_latestValue.isPlaying) {
                if (_displayTapped) {
                  setState(() {
                    notifier.hideStuff = true;
                  });
                } else {
                  _cancelAndRestartTimer();
                }
              } else {
                _playPause();

                setState(() {
                  notifier.hideStuff = true;
                });
              }
            },
            child: CenterPlayButton(
              backgroundColor: Colors.black54,
              iconColor: Colors.white,
              isFinished: isFinished,
              isPlaying: videoPlayerController.value.isPlaying,
              show: showPlayButton,
              onPressed: _playPause,
            ));
  }

  Widget _buildQuickGesturesWidget(Widget child) {
    if (!_whetherBuildControls()) {
      return child;
    }
    return GestureDetector(
        onLongPressStart: (details) {
          if (!videoPlayerController.value.isPlaying) return;
          setState(() {
            _dragging = true;
            _quickGestures = QuickGestures.accelerate;
            videoPlayerController.setPlaybackSpeed(3);
          });
        },
        onLongPressEnd: (details) {
          if (!videoPlayerController.value.isPlaying) return;
          setState(() {
            _dragging = false;
            _quickGestures = QuickGestures.none;
            videoPlayerController.setPlaybackSpeed(1);
          });
        },
        onVerticalDragUpdate: (details) {
          final double delta =
              -(details.primaryDelta ?? 0 / context.size!.height);
          if (delta.abs() < 0.1) return;
          setState(() {
            _gesturesDragTotalDelta += delta / 2.5;
            _quickGestures =
                delta >= 0 ? QuickGestures.volumeUp : QuickGestures.volumeDown;
          });
        },
        onVerticalDragEnd: (details) {
          setState(() {
            _dragging = false;
            _quickGestures = QuickGestures.none;

            videoPlayerController.setVolume(_getVolumeAfterAdjust());
            _gesturesDragTotalDelta = 0;
          });
        },
        onHorizontalDragUpdate: (details) {
          final double delta = details.primaryDelta ?? 0 / context.size!.width;
          if (delta.abs() < 0.1) return;
          setState(() {
            _gesturesDragTotalDelta +=
                videoPlayerController.value.duration.inMilliseconds *
                    delta ~/
                    5000;
            _quickGestures = delta >= 0
                ? QuickGestures.fastForward
                : QuickGestures.fastRewind;
          });
        },
        onHorizontalDragEnd: (details) {
          setState(() {
            int destination = _getPositionAfterAdjust()!;
            _dragging = false;
            _quickGestures = QuickGestures.none;
            if (destination < 0) {
              destination = 0;
            } else if (destination >
                videoPlayerController.value.duration.inMilliseconds) {
              destination = videoPlayerController.value.duration.inMilliseconds;
            }
            videoPlayerController.seekTo(Duration(milliseconds: destination));
            _gesturesDragTotalDelta = 0;
          });
        },
        child: child);
  }

  Widget? _buildQuickGesturesSignal() {
    switch (_quickGestures) {
      case QuickGestures.accelerate:
        return Container(
          padding: iwrVideoController.isFullScreen
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
          padding: iwrVideoController.isFullScreen
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
          padding: iwrVideoController.isFullScreen
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
          padding: iwrVideoController.isFullScreen
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
                width: iwrVideoController.isFullScreen ? 150 : 100,
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
          padding: iwrVideoController.isFullScreen
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
                width: iwrVideoController.isFullScreen ? 150 : 100,
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

  int? _getPositionAfterAdjust() {
    if (_quickGestures == QuickGestures.fastForward ||
        _quickGestures == QuickGestures.fastRewind) {
      int finalValue = videoPlayerController.value.position.inMilliseconds +
          _gesturesDragTotalDelta.toInt();
      if (finalValue < 0) {
        finalValue = 0;
      } else if (finalValue >
          videoPlayerController.value.duration.inMilliseconds) {
        finalValue = videoPlayerController.value.position.inMilliseconds;
      }
      return finalValue;
    }
    return null;
  }

  double _getVolumeAfterAdjust() {
    double finalValue =
        videoPlayerController.value.volume + _gesturesDragTotalDelta / 100;
    if (finalValue < 0) {
      finalValue = 0;
    } else if (finalValue > 1) {
      finalValue = 1;
    }
    return finalValue;
  }

  Widget _buildPosition() {
    final positionAfterAdjust = _getPositionAfterAdjust();
    final duration = _latestValue.duration;
    var position = _latestValue.position;
    if (positionAfterAdjust != null) {
      position = Duration(milliseconds: positionAfterAdjust);
    }

    return RichText(
      text: TextSpan(
        text: '${_formatDuration(position)} ',
        children: <InlineSpan>[
          TextSpan(
            text: '/ ${_formatDuration(duration)}',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white.withOpacity(.75),
              fontWeight: FontWeight.normal,
            ),
          )
        ],
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPlaybackSpeedButton(BuildContext context) {
    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        alignment: Alignment.center,
        height: barHeight + (iwrVideoController.isFullScreen ? 10 : 0),
        padding: EdgeInsets.only(left: 16, right: 8),
        child: MaterialButton(
          onPressed: () {
            _pushPlaybackSpeedSelectionMune(context);
          },
          padding: EdgeInsets.zero,
          minWidth: 0,
          child: Text(
            iwrVideoController.availablePlaybackSpeedMap.keys
                .toList()[iwrVideoController.currentSpeedIndex],
            style: TextStyle(color: Colors.white, fontSize: 17.5),
          ),
        ),
      ),
    );
  }

  Widget _buildResolutionsButton(BuildContext context) {
    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        alignment: Alignment.center,
        height: barHeight + (iwrVideoController.isFullScreen ? 10 : 0),
        padding: EdgeInsets.only(left: 8, right: 8),
        child: MaterialButton(
          onPressed: () {
            _pushResolutionsSelectionMune(context);
          },
          padding: EdgeInsets.zero,
          minWidth: 0,
          child: Text(
            iwrVideoController
                .availableResolutions[iwrVideoController.currentResolutionIndex]
                .name,
            style: TextStyle(color: Colors.white, fontSize: 17.5),
          ),
        ),
      ),
    );
  }

  Widget _buildExitButton(BuildContext context) {
    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        alignment: Alignment.center,
        height: barHeight + (iwrVideoController.isFullScreen ? 10 : 0),
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: MaterialButton(
          onPressed: () {
            if (iwrVideoController.isFullScreen) {
              _onExpandCollapse(context);
            }
          },
          padding: EdgeInsets.zero,
          minWidth: 0,
          child: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandButton(BuildContext context) {
    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        alignment: Alignment.center,
        height: barHeight + (iwrVideoController.isFullScreen ? 10 : 0),
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: MaterialButton(
          onPressed: () {
            _onExpandCollapse(context);
          },
          padding: EdgeInsets.zero,
          minWidth: 0,
          child: FaIcon(
            iwrVideoController.isFullScreen
                ? FontAwesomeIcons.compress
                : FontAwesomeIcons.expand,
            color: Colors.white,
            size: 25,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Expanded(
        child: VideoProgressBar(
      videoPlayerController,
      previewPositionAfterAdjust: _getPositionAfterAdjust(),
      barHeight: 5,
      handleHeight: 4,
      drawShadow: true,
      onDragEnd: () {
        setState(() {
          _dragging = false;
        });

        _startHideTimer();
      },
      onDragStart: () {
        setState(() {
          _dragging = true;
        });

        _hideTimer?.cancel();
      },
    ));
  }

  AnimatedOpacity _buildTopBar(
    BuildContext context,
  ) {
    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: barHeight + (iwrVideoController.isFullScreen ? 15 : 5),
        padding: EdgeInsets.fromLTRB(
          5,
          iwrVideoController.isFullScreen ? 10 : 5,
          5,
          5,
        ),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.black45,
          Colors.black26,
          Colors.black12,
          Colors.transparent
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          minimum: EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_buildExitButton(context)],
          ),
        ),
      ),
    );
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
  ) {
    return AnimatedOpacity(
      opacity: notifier.hideStuff ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        height: barHeight + (iwrVideoController.isFullScreen ? 15 : 5),
        padding: EdgeInsets.fromLTRB(
          5,
          5,
          5,
          iwrVideoController.isFullScreen ? 10 : 5,
        ),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.transparent,
          Colors.black12,
          Colors.black26,
          Colors.black45
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: SafeArea(
          bottom: iwrVideoController.isFullScreen,
          minimum: EdgeInsets.zero,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height:
                      barHeight + (iwrVideoController.isFullScreen ? 10 : 0),
                  child: IconButton(
                    iconSize: 30,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    icon: _latestValue.position >= _latestValue.duration
                        ? FaIcon(
                            FontAwesomeIcons.arrowRotateLeft,
                            color: Colors.white,
                            size: 25,
                          )
                        : AnimatedPlayPause(
                            color: Colors.white,
                            playing: videoPlayerController.value.isPlaying,
                          ),
                    onPressed: _playPause,
                  )),
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
              if (iwrVideoController.isFullScreen)
                _buildPlaybackSpeedButton(context),
              if (iwrVideoController.isFullScreen)
                _buildResolutionsButton(context),
              if (!iwrVideoController.isFullScreen) _buildExpandButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
        color: Colors.black.withAlpha(128),
        child: Stack(children: [
          if (iwrVideoController.isFullScreen)
            GestureDetector(
                onTap: () {
                  _onExpandCollapse(context);
                },
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    color: Colors.white,
                    size: 30,
                  ),
                )),
          Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        _latestValue = VideoPlayerValue.uninitialized();
                        iwrVideoController.valueBeforeRenewing =
                            videoPlayerController.value;
                        iwrVideoController.renew(iwrVideoController
                            .availableResolutions[
                                iwrVideoController.currentResolutionIndex]
                            .src
                            .viewUrl);
                      },
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.arrowRotateLeft,
                          color: Theme.of(context).primaryColor,
                          size: 42,
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  )
                ],
              ))
        ]));
  }

  bool _whetherBuildControls() {
    if (!iwrVideoController.renewing &&
            iwrVideoController.videoPlayerController!.value.isInitialized ||
        iwrVideoController.errorMessage != null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bool showErrorWidget = false;
    bool showIndicatorWidget = true;

    if (iwrVideoController.renewed) {
      _renewPlayer();
      iwrVideoController.renewed = false;
    }

    if (_latestValue.hasError) {
      iwrVideoController.errorMessage =
          videoPlayerController.value.errorDescription ??
              _latestValue.errorDescription ??
              "Unknown error.";
      showErrorWidget = true;
      showIndicatorWidget = false;
    } else if (iwrVideoController.errorMessage != null) {
      showErrorWidget = true;
      showIndicatorWidget = false;
    }

    if (iwrVideoController.errorMessage == null &&
        !iwrVideoController.renewing &&
        iwrVideoController.videoPlayerController != null) {
      if (iwrVideoController.videoPlayerController!.value.isInitialized) {
        showIndicatorWidget = false;
      }
    }

    return MouseRegion(
      onHover: (_) {
        _cancelAndRestartTimer();
      },
      child: _buildQuickGesturesWidget(GestureDetector(
        onTap: () => _cancelAndRestartTimer(),
        child: AbsorbPointer(
          absorbing: notifier.hideStuff,
          child: Stack(
            children: showErrorWidget || !_whetherBuildControls()
                ? [
                    if (iwrVideoController.isFullScreen) _buildTopBar(context),
                    if (showErrorWidget)
                      _buildErrorWidget(iwrVideoController.errorMessage!),
                    if (showIndicatorWidget)
                      Center(
                        child: IwrProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                  ]
                : [
                    if (_displayBufferingIndicator)
                      const Center(
                        child: IwrProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    else
                      _buildHitArea(context),
                    if (iwrVideoController.isFullScreen) _buildTopBar(context),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildBottomBar(context),
                      ],
                    ),
                  ],
          ),
        ),
      )),
    );
  }
}
