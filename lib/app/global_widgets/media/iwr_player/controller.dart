import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/account/settings/player_setting.dart';
import '../../../data/services/config_service.dart';
import 'widgets/iwr_player_controls.dart';

enum QuickGestures {
  none,
  accelerate,
  volumeUp,
  volumeDown,
  fastForward,
  fastRewind
}

class IwrPlayerController extends GetxController {
  ConfigService configService = Get.find();
  
  late BetterPlayerController betterPlayerController;
  int _qualityIndexToSave = 0;
  int _volumeToSave = 100;
  final Function(PlayerSetting setting)? _onPlayerSettingSaved;
  final Map<String, String> resolutions;
  final Map<String, double> availablePlaybackSpeeds = {
    '0.5x': 0.5,
    '0.75x': 0.75,
    '1.0x': 1,
    '1.25x': 1.25,
    '1.5x': 1.5,
    '2.0x': 2
  };

  final String title;

  final RxBool _isFullScreen = false.obs;
  bool get isFullScreen => _isFullScreen.value;
  set isFullScreen(bool value) => _isFullScreen.value = value;

  final RxInt _currentPlaybackSpeedIndex = 2.obs;
  int get currentPlaybackSpeedIndex => _currentPlaybackSpeedIndex.value;
  set currentPlaybackSpeedIndex(int value) =>
      _currentPlaybackSpeedIndex.value = value;

  final RxInt _currentResolutionIndex = 0.obs;
  int get currentResolutionIndex => _currentResolutionIndex.value;
  set currentResolutionIndex(int value) =>
      _currentResolutionIndex.value = value;

  final RxBool _dragging = false.obs;
  bool get dragging => _dragging.value;
  set dragging(bool value) => _dragging.value = value;

  final Rx<QuickGestures> _quickGesture = QuickGestures.none.obs;
  QuickGestures get quickGesture => _quickGesture.value;
  set quickGesture(QuickGestures value) => _quickGesture.value = value;

  final RxInt _positionAfterAdjust = (-1).obs;
  int get positionAfterAdjust => _positionAfterAdjust.value;
  set positionAfterAdjust(int value) => _positionAfterAdjust.value = value;

  final RxDouble _gesturesDragTotalDelta = 0.0.obs;
  double get gesturesDragTotalDelta => _gesturesDragTotalDelta.value;
  set gesturesDragTotalDelta(double value) =>
      _gesturesDragTotalDelta.value = value;

  IwrPlayerController({
    required this.resolutions,
    required String id,
    required this.title,
    required String author,
    BetterPlayerDataSourceType type = BetterPlayerDataSourceType.network,
    double initAspectRatio = 16 / 9,
    String? thumbnail,
    PlayerSetting? setting,
    dynamic Function(PlayerSetting)? onPlayerSettingSaved,
  }) : _onPlayerSettingSaved = onPlayerSettingSaved {
    int resolutionIndex = 0;
    int volume = 100;

    if (setting != null) {
      int index = setting.qualityIndex;
      resolutionIndex = min(index, resolutions.length);
      _qualityIndexToSave = index;

      volume = setting.volume;
      _volumeToSave = volume;
    }

    _currentResolutionIndex.value = resolutionIndex;

    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
      type,
      resolutions.values.elementAt(resolutionIndex),
      notificationConfiguration: BetterPlayerNotificationConfiguration(
        showNotification: configService.notificationPlayer,
        title: title,
        author: author,
        imageUrl: thumbnail,
      ),
    );

    betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        aspectRatio: initAspectRatio,
        fit: BoxFit.contain,
        handleLifecycle: false,
        autoDispose: false,
        expandToFill: false,
        autoDetectFullscreenDeviceOrientation: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          playerTheme: BetterPlayerTheme.custom,
          customControlsBuilder: (controller, onPlayerVisibilityChanged) {
            return IwrPlayerControls(
              id: id,
              controlsConfiguration:
                  controller.betterPlayerConfiguration.controlsConfiguration,
            );
          },
        ),
      ),
      betterPlayerDataSource: betterPlayerDataSource,
    );

    betterPlayerController.setVolume(volume / 100);

    betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.openFullscreen) {
        isFullScreen = true;
      } else if (event.betterPlayerEventType ==
          BetterPlayerEventType.hideFullscreen) {
        isFullScreen = false;
      }
    });
  }

  void changeResolution(int index) {
    String? key = resolutions.keys.elementAt(index);
    betterPlayerController.setResolution(resolutions[key]!);
    currentResolutionIndex = index;

    if (index == resolutions.length - 1) {
      // source
      _qualityIndexToSave = 2;
    } else {
      _qualityIndexToSave = index;
    }
  }

  void changePlaybackSpeed(int index) {
    String? key = availablePlaybackSpeeds.keys.elementAt(index);
    betterPlayerController.setSpeed(availablePlaybackSpeeds[key]!);
    currentPlaybackSpeedIndex = index;
  }

  void pause() {
    betterPlayerController.pause();
  }

  void seekTo(Duration moment) {
    betterPlayerController.seekTo(moment);
  }

  void setPlaybackSpeed(double speed) {
    betterPlayerController.setSpeed(speed);
  }

  void setVolume(double volume) {
    betterPlayerController.setVolume(volume);
    _volumeToSave = (volume * 100).round();
  }

  void toggleFullScreen() {
    if (isFullScreen) {
      betterPlayerController.exitFullScreen();
    } else {
      betterPlayerController.enterFullScreen();
    }
  }

  @override
  void onClose() {
    super.onClose();
    _onPlayerSettingSaved?.call(PlayerSetting(
      qualityIndex: _qualityIndexToSave,
      volume: _volumeToSave,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    betterPlayerController.dispose();
  }
}
