import 'dart:async';
import 'dart:io';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:status_bar_control/status_bar_control.dart';

import '../../../data/providers/storage_provider.dart';
import '../../../data/services/plugin/pl_player/service_locator.dart';
import 'index.dart';

class PlPlayerController {
  Player? _videoPlayerController;
  VideoController? _videoController;

  GStorageConfig setting = StorageProvider.config;

  // 添加一个私有静态变量来保存实例
  static PlPlayerController? _instance;

  // 流事件  监听播放状态变化
  StreamSubscription? _playerEventSubs;

  /// [playerStatus] has a [status] observable
  final PlPlayerStatus playerStatus = PlPlayerStatus();

  ///
  final PlPlayerDataStatus dataStatus = PlPlayerDataStatus();

  // bool controlsEnabled = false;

  /// 响应数据
  /// 带有Seconds的变量只在秒数更新时更新，以避免频繁触发重绘
  // 播放位置
  final Rx<Duration> _position = Rx(Duration.zero);
  final RxInt positionSeconds = 0.obs;
  final Rx<Duration> _sliderPosition = Rx(Duration.zero);
  final RxInt sliderPositionSeconds = 0.obs;
  // 展示使用
  final Rx<Duration> _sliderTempPosition = Rx(Duration.zero);
  final Rx<Duration> _duration = Rx(Duration.zero);
  final RxInt durationSeconds = 0.obs;
  final Rx<Duration> _buffered = Rx(Duration.zero);
  final RxInt bufferedSeconds = 0.obs;

  final Rx<int> _playerCount = Rx(0);

  final Rx<double> _playbackSpeed = 1.0.obs;
  final Rx<double> _longPressSpeed = 2.0.obs;
  final Rx<double> _currentVolume = 1.0.obs;
  final Rx<double> _currentBrightness = 0.0.obs;

  final Rx<bool> _mute = false.obs;
  final Rx<bool> _showControls = false.obs;
  final Rx<bool> _showVolumeStatus = false.obs;
  final Rx<bool> _showBrightnessStatus = false.obs;
  final Rx<bool> _doubleSpeedStatus = false.obs;
  final Rx<bool> _controlsLock = false.obs;
  final Rx<bool> _isFullScreen = false.obs;

  final Rx<String> _direction = 'horizontal'.obs;

  Rx<bool> videoFitChanged = false.obs;
  final Rx<BoxFit> _videoFit = Rx(BoxFit.contain);
  final Rx<String> _videoFitDesc = Rx(t.player.aspect_ratio);

  ///
  // ignore: prefer_final_fields
  Rx<bool> _isSliderMoving = false.obs;
  PlaylistMode _looping = PlaylistMode.none;
  bool _autoPlay = false;
  final bool _listenersInitialized = false;

  Timer? _timer;
  Timer? _timerForSeek;
  Timer? _timerForVolume;
  Timer? _timerForShowingVolume;
  Timer? _timerForGettingVolume;
  Timer? timerForTrackingMouse;
  Timer? videoFitChangedTimer;

  // final Durations durations;

  List<Map<String, dynamic>> videoFitType = [
    {'attr': BoxFit.contain, 'desc': t.player.aspect_ratios.contain},
    {'attr': BoxFit.cover, 'desc': t.player.aspect_ratios.cover},
    {'attr': BoxFit.fill, 'desc': t.player.aspect_ratios.fill},
    {'attr': BoxFit.fitHeight, 'desc': t.player.aspect_ratios.fit_height},
    {'attr': BoxFit.fitWidth, 'desc': t.player.aspect_ratios.fit_width},
    {'attr': BoxFit.scaleDown, 'desc': t.player.aspect_ratios.scale_down},
  ];

  final RxInt width = 0.obs;
  final RxInt height = 0.obs;

  PreferredSizeWidget? headerControl;
  PreferredSizeWidget? bottomControl;
  Widget? danmuWidget;

  /// 数据加载监听
  Stream<DataStatus> get onDataStatusChanged => dataStatus.status.stream;

  /// 播放状态监听
  Stream<PlayerStatus> get onPlayerStatusChanged => playerStatus.status.stream;

  /// 视频时长
  Rx<Duration> get duration => _duration;
  Stream<Duration> get onDurationChanged => _duration.stream;

  /// 视频当前播放位置
  Rx<Duration> get position => _position;
  Stream<Duration> get onPositionChanged => _position.stream;

  /// 视频播放速度
  double get playbackSpeed => _playbackSpeed.value;

  // 长按倍速
  double get longPressSpeed => _longPressSpeed.value;

  /// 视频缓冲
  Rx<Duration> get buffered => _buffered;
  Stream<Duration> get onBufferedChanged => _buffered.stream;

  // 视频静音
  Rx<bool> get mute => _mute;
  Stream<bool> get onMuteChanged => _mute.stream;

  /// [videoPlayerController] instace of Player
  Player? get videoPlayerController => _videoPlayerController;

  /// [videoController] instace of Player
  VideoController? get videoController => _videoController;

  Rx<bool> get isSliderMoving => _isSliderMoving;

  /// 进度条位置及监听
  Rx<Duration> get sliderPosition => _sliderPosition;
  Stream<Duration> get onSliderPositionChanged => _sliderPosition.stream;

  Rx<Duration> get sliderTempPosition => _sliderTempPosition;
  // Stream<Duration> get onSliderPositionChanged => _sliderPosition.stream;

  /// 是否展示控制条及监听
  Rx<bool> get showControls => _showControls;
  Stream<bool> get onShowControlsChanged => _showControls.stream;

  /// 音量控制条展示/隐藏
  Rx<bool> get showVolumeStatus => _showVolumeStatus;
  Stream<bool> get onShowVolumeStatusChanged => _showVolumeStatus.stream;

  /// 亮度控制条展示/隐藏
  Rx<bool> get showBrightnessStatus => _showBrightnessStatus;
  Stream<bool> get onShowBrightnessStatusChanged =>
      _showBrightnessStatus.stream;

  /// 音量控制条
  Rx<double> get volume => _currentVolume;
  Stream<double> get onVolumeChanged => _currentVolume.stream;

  /// 亮度控制条
  Rx<double> get brightness => _currentBrightness;
  Stream<double> get onBrightnessChanged => _currentBrightness.stream;

  /// 是否循环
  PlaylistMode get looping => _looping;

  /// 是否自动播放
  bool get autoplay => _autoPlay;

  /// 视频比例
  Rx<BoxFit> get videoFit => _videoFit;
  Rx<String> get videoFitDEsc => _videoFitDesc;

  /// 是否长按倍速
  Rx<bool> get doubleSpeedStatus => _doubleSpeedStatus;

  Rx<bool> isBuffering = true.obs;

  /// 屏幕锁 为true时，关闭控制栏
  Rx<bool> get controlsLock => _controlsLock;

  /// 全屏状态
  Rx<bool> get isFullScreen => _isFullScreen;

  /// 全屏方向
  Rx<String> get direction => _direction;

  Rx<int> get playerCount => _playerCount;

  late List<double> speedsList;
  // 缓存
  double? defaultDuration;
  late bool enableAutoLongPressSpeed = false;

  void updateSliderPositionSecond() {
    int newSecond = _sliderPosition.value.inSeconds;
    if (sliderPositionSeconds.value != newSecond) {
      sliderPositionSeconds.value = newSecond;
    }
  }

  void updatePositionSecond() {
    int newSecond = _position.value.inSeconds;
    if (positionSeconds.value != newSecond) {
      positionSeconds.value = newSecond;
    }
  }

  void updateDurationSecond() {
    int newSecond = _duration.value.inSeconds;
    if (durationSeconds.value != newSecond) {
      durationSeconds.value = newSecond;
    }
  }

  void updateBufferedSecond() {
    int newSecond = _buffered.value.inSeconds;
    if (bufferedSeconds.value != newSecond) {
      bufferedSeconds.value = newSecond;
    }
  }

  // 添加一个私有构造函数
  PlPlayerController._() {
    _playbackSpeed.value =
        setting.get(PLPlayerConfigKey.playSpeedDefault, defaultValue: 1.0);
    enableAutoLongPressSpeed = setting
        .get(PLPlayerConfigKey.enableAutoLongPressSpeed, defaultValue: false);
    if (!enableAutoLongPressSpeed) {
      _longPressSpeed.value = setting
          .get(PLPlayerConfigKey.longPressSpeedDefault, defaultValue: 2.0);
    }
    // speedsList = List<double>.from(videoStorage
    //     .get(VideoBoxKey.customSpeedsList, defaultValue: <double>[]));
    speedsList = [];
    for (final PlaySpeed i in PlaySpeed.values) {
      speedsList.add(i.value);
    }

    // _playerEventSubs = onPlayerStatusChanged.listen((PlayerStatus status) {
    //   if (status == PlayerStatus.playing) {
    //     WakelockPlus.enable();
    //   } else {
    //     WakelockPlus.disable();
    //   }
    // });
  }

  // 获取实例 传参
  static PlPlayerController getInstance() {
    // 如果实例尚未创建，则创建一个新实例
    _instance ??= PlPlayerController._();
    _instance!._playerCount.value += 1;
    return _instance!;
  }

  // 初始化资源
  Future<void> setDataSource(
    DataSource dataSource, {
    bool autoplay = true,
    // 默认不循环
    PlaylistMode looping = PlaylistMode.none,
    // 初始化播放位置
    Duration seekTo = Duration.zero,
    // 初始化播放速度
    double speed = 1.0,
    // 硬件加速
    bool enableHA = true,
    // 是否首次加载
    bool isFirstTime = true,
    VoidCallback? onVideoLoad,
  }) async {
    try {
      loaded = false;
      _autoPlay = autoplay;
      _looping = looping;
      // 初始化视频倍速
      // _playbackSpeed.value = speed;
      // 初始化数据加载状态
      dataStatus.status.value = DataStatus.loading;

      if (_videoPlayerController != null &&
          _videoPlayerController!.state.playing) {
        await pause(notify: false);
      }

      if (_playerCount.value == 0) {
        return;
      }
      // 配置Player 音轨、字幕等等
      _videoPlayerController =
          await _createVideoController(dataSource, _looping, enableHA);
      // 等待视频加载完成
      loadingSubs = _videoPlayerController!.stream.duration.listen((event) {
        if (loaded) return;

        _duration.value = event;
        updateDurationSecond();

        onVideoLoad?.call();

        // 数据加载完成
        dataStatus.status.value = DataStatus.loaded;
        // listen the video player events
        if (!_listenersInitialized) {
          startListeners();
        }
        _initializePlayer(seekTo: seekTo, duration: _duration.value);
        bool autoEnterFullcreen =
            setting.get(PLPlayerConfigKey.enableAutoEnter, defaultValue: false);
        if (autoEnterFullcreen) {
          Future.delayed(const Duration(milliseconds: 100), () {
            triggerFullScreen();
          });
        }

        loaded = true;
      });
    } catch (err) {
      dataStatus.status.value = DataStatus.error;
      print('plPlayer err:  $err');
    }
  }

  // 配置播放器
  Future<Player> _createVideoController(
    DataSource dataSource,
    PlaylistMode looping,
    bool enableHA,
  ) async {
    // 每次配置时先移除监听
    removeListeners();
    isBuffering.value = false;
    buffered.value = Duration.zero;
    _position.value = Duration.zero;

    Player player = _videoPlayerController ??
        Player(
          configuration: const PlayerConfiguration(
            bufferSize: 5 * 1024 * 1024,
          ),
        );

    var pp = player.platform as NativePlayer;
    // 解除倍速限制
    await pp.setProperty("af", "scaletempo2=max-speed=8");
    //  音量不一致
    if (Platform.isAndroid) {
      await pp.setProperty("volume-max", "100");
      await pp.setProperty("ao", "audiotrack,opensles");
    }

    await player.setAudioTrack(
      AudioTrack.auto(),
    );

    // 音轨
    if (dataSource.audioSource != '' && dataSource.audioSource != null) {
      await pp.setProperty(
        'audio-files',
        GetPlatform.isWindows
            ? dataSource.audioSource!.replaceAll(';', '\\;')
            : dataSource.audioSource!.replaceAll(':', '\\:'),
      );
    } else {
      await pp.setProperty(
        'audio-files',
        '',
      );
    }

    // 字幕
    if (dataSource.subFiles != '' && dataSource.subFiles != null) {
      await pp.setProperty(
        'sub-files',
        GetPlatform.isWindows
            ? dataSource.subFiles!.replaceAll(';', '\\;')
            : dataSource.subFiles!.replaceAll(':', '\\:'),
      );
      await pp.setProperty("subs-with-matching-audio", "no");
      await pp.setProperty("sub-forced-only", "yes");
      await pp.setProperty("blend-subtitles", "video");
    }

    // Proxy
    if (StorageProvider.config[StorageKey.proxyEnable] ?? false) {
      String? proxyHost = StorageProvider.config[StorageKey.proxyHost];
      String? proxyPort = StorageProvider.config[StorageKey.proxyPort];

      if (proxyHost != null && proxyPort != null) {
        await pp.setProperty("http-proxy", "http://$proxyHost:$proxyPort");
      }
    }

    await pp.setProperty('demuxer-lavf-o', 'allowed_extensions=[ts,key]');

    _videoController = _videoController ??
        VideoController(
          player,
          configuration: VideoControllerConfiguration(
            enableHardwareAcceleration: enableHA,
            androidAttachSurfaceAfterVideoParameters: false,
          ),
        );

    player.setPlaylistMode(looping);

    if (dataSource.type == DataSourceType.asset) {
      final assetUrl = dataSource.videoSource!.startsWith("asset://")
          ? dataSource.videoSource!
          : "asset://${dataSource.videoSource!}";
      await player.open(
        Media(assetUrl, httpHeaders: dataSource.httpHeaders),
        play: false,
      );
    }
    await player.open(
      Media(dataSource.videoSource!, httpHeaders: dataSource.httpHeaders),
      play: false,
    );
    // 音轨
    // player.setAudioTrack(
    //   AudioTrack.uri(dataSource.audioSource!),
    // );

    return player;
  }

  // 开始播放
  Future _initializePlayer({
    Duration seekTo = Duration.zero,
    Duration? duration,
  }) async {
    // 设置倍速
    if (_playbackSpeed.value != 1.0) {
      await setPlaybackSpeed(_playbackSpeed.value);
    } else {
      await setPlaybackSpeed(1.0);
    }
    getVideoFit();
    // if (_looping) {
    //   await setLooping(_looping);
    // }

    // 跳转播放
    if (seekTo != Duration.zero) {
      await this.seekTo(seekTo);
    }

    // 自动播放
    if (_autoPlay) {
      await play(duration: duration);
    }
  }

  bool loaded = false;
  StreamSubscription? loadingSubs;
  List<StreamSubscription> subscriptions = [];
  final List<Function(Duration position)> _positionListeners = [];
  final List<Function(PlayerStatus status)> _statusListeners = [];

  /// 播放事件监听
  void startListeners() {
    subscriptions.addAll(
      [
        // Get aspact ratio
        _videoPlayerController!.stream.width.listen((event) {
          width.value = event ?? 0;
          if (event != null && event > 0 && height.value > 0) {
            _direction.value = event > height.value ? 'horizontal' : 'vertical';
          }
        }),

        _videoPlayerController!.stream.height.listen((event) {
          height.value = event ?? 0;
          if (event != null && event > 0 && width.value > 0) {
            _direction.value = width.value > event ? 'horizontal' : 'vertical';
          }
        }),

        videoPlayerController!.stream.playing.listen((event) {
          if (event) {
            playerStatus.status.value = PlayerStatus.playing;
          } else {
            playerStatus.status.value = PlayerStatus.paused;
          }

          /// 触发回调事件
          for (var element in _statusListeners) {
            element(event ? PlayerStatus.playing : PlayerStatus.paused);
          }
        }),

        videoPlayerController!.stream.completed.listen((event) {
          if (event) {
            playerStatus.status.value = PlayerStatus.completed;

            /// 触发回调事件
            for (var element in _statusListeners) {
              element(PlayerStatus.completed);
            }
          } else {
            // playerStatus.status.value = PlayerStatus.playing;
          }
        }),
        videoPlayerController!.stream.position.listen((event) {
          _position.value = event;
          updatePositionSecond();
          if (!isSliderMoving.value) {
            _sliderPosition.value = event;
            updateSliderPositionSecond();
          }

          /// 触发回调事件
          for (var element in _positionListeners) {
            element(event);
          }
        }),
        videoPlayerController!.stream.duration.listen((event) {
          duration.value = event;
        }),
        videoPlayerController!.stream.buffer.listen((event) {
          _buffered.value = event;
          updateBufferedSecond();
        }),
        videoPlayerController!.stream.buffering.listen((event) {
          isBuffering.value = event;
          videoPlayerServiceHandler.onStatusChange(
              playerStatus.status.value, event);
        }),
        // videoPlayerController!.stream.volume.listen((event) {
        //   if (!mute.value && _volumeBeforeMute != event) {
        //     _volumeBeforeMute = event / 100;
        //   }
        // }),
        // 媒体通知监听
        onPlayerStatusChanged.listen((event) {
          videoPlayerServiceHandler.onStatusChange(event, isBuffering.value);
        }),
        onPositionChanged.listen((event) {
          EasyThrottle.throttle(
              'mediaServicePositon',
              const Duration(seconds: 1),
              () => videoPlayerServiceHandler.onPositionChange(event));
        }),
      ],
    );
  }

  /// 移除事件监听
  void removeListeners() {
    for (final s in subscriptions) {
      s.cancel();
    }
    subscriptions.clear();
    loadingSubs?.cancel();
  }

  /// 跳转至指定位置
  Future<void> seekTo(Duration position, {type = 'seek'}) async {
    // if (position >= duration.value) {
    //   position = duration.value - const Duration(milliseconds: 100);
    // }
    if (position < Duration.zero) {
      position = Duration.zero;
    }
    _position.value = position;
    updatePositionSecond();
    if (duration.value.inSeconds != 0) {
      if (type != 'slider') {
        /// 拖动进度条调节时，不等待第一帧，防止抖动
        await _videoPlayerController?.stream.buffer.first;
      }
      await _videoPlayerController?.seek(position);
      // if (playerStatus.stopped) {
      //   play();
      // }
    } else {
      print('seek duration else');
      _timerForSeek?.cancel();
      _timerForSeek =
          Timer.periodic(const Duration(milliseconds: 200), (Timer t) async {
        //_timerForSeek = null;
        if (duration.value.inSeconds != 0) {
          await _videoPlayerController!.stream.buffer.first;
          await _videoPlayerController?.seek(position);
          // if (playerStatus.status.value == PlayerStatus.paused) {
          //   play();
          // }
          t.cancel();
          _timerForSeek = null;
        }
      });
    }
  }

  /// 设置倍速
  Future<void> setPlaybackSpeed(double speed) async {
    /// TODO  _duration.value丢失
    await _videoPlayerController?.setRate(speed);
    // fix 长按倍速后放开不恢复
    if (!doubleSpeedStatus.value) {
      _playbackSpeed.value = speed;
    }
  }

  // 还原默认速度
  Future<void> setDefaultSpeed() async {
    double speed =
        setting.get(PLPlayerConfigKey.playSpeedDefault, defaultValue: 1.0);
    await _videoPlayerController?.setRate(speed);
    _playbackSpeed.value = speed;
  }

  /// 设置倍速
  // Future<void> togglePlaybackSpeed() async {
  //   List<double> allowedSpeeds =
  //       PlaySpeed.values.map<double>((e) => e.value).toList();
  //   int index = allowedSpeeds.indexOf(_playbackSpeed.value);
  //   if (index < allowedSpeeds.length - 1) {
  //     setPlaybackSpeed(allowedSpeeds[index + 1]);
  //   } else {
  //     setPlaybackSpeed(allowedSpeeds[0]);
  //   }
  // }

  /// 播放视频
  /// TODO  _duration.value丢失
  Future<void> play(
      {bool repeat = false, bool hideControls = true, dynamic duration}) async {
    // 播放时自动隐藏控制条
    controls = !hideControls;
    // repeat为true，将从头播放
    if (repeat) {
      await seekTo(Duration.zero);
    }
    await _videoPlayerController?.play();

    await getCurrentVolume();
    await getCurrentBrightness();

    playerStatus.status.value = PlayerStatus.playing;
    // screenManager.setOverlays(false);

    /// 临时fix _duration.value丢失
    if (duration != null) {
      _duration.value = duration;
      updateDurationSecond();
    }
    audioSessionHandler.setActive(true);
  }

  /// 暂停播放
  Future<void> pause({bool notify = true, bool isInterrupt = false}) async {
    await _videoPlayerController?.pause();
    // playerStatus.status.value = PlayerStatus.paused;

    // 主动暂停时让出音频焦点
    if (!isInterrupt) {
      audioSessionHandler.setActive(false);
    }
  }

  /// 更改播放状态
  Future<void> togglePlay() async {
    HapticFeedback.lightImpact();
    if (playerStatus.playing) {
      pause();
    } else {
      play();
    }
  }

  /// 隐藏控制条
  void _hideTaskControls() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(milliseconds: 3000), () {
      if (!isSliderMoving.value) {
        controls = false;
      }
      _timer = null;
    });
  }

  /// 调整播放时间
  onChangedSlider(double v) {
    _sliderPosition.value = Duration(seconds: v.floor());
    updateSliderPositionSecond();
  }

  void onChangedSliderStart() {
    _isSliderMoving.value = true;
  }

  void onUpdatedSliderProgress(Duration value) {
    _sliderTempPosition.value = value;
    _sliderPosition.value = value;
    updateSliderPositionSecond();
  }

  void onChangedSliderEnd() {
    HapticFeedback.lightImpact();
    _isSliderMoving.value = false;
    _hideTaskControls();
  }

  /// 音量
  Future<void> getCurrentVolume() async {
    // mac try...catch
    try {
      _currentVolume.value = (await FlutterVolumeController.getVolume())!;
    } catch (_) {}
  }

  Future<void> setVolume(double volumeNew,
      {bool videoPlayerVolume = false}) async {
    if (volumeNew < 0.0) {
      volumeNew = 0.0;
    } else if (volumeNew > 1.0) {
      volumeNew = 1.0;
    }
    if (volume.value == volumeNew) {
      return;
    }
    volume.value = volumeNew;

    try {
      FlutterVolumeController.updateShowSystemUI(false);
      await FlutterVolumeController.setVolume(volumeNew);
    } catch (err) {
      print(err);
    }
  }

  void volumeUpdated() {
    showVolumeStatus.value = true;
    _timerForShowingVolume?.cancel();
    _timerForShowingVolume = Timer(const Duration(seconds: 1), () {
      showVolumeStatus.value = false;
    });
  }

  /// 亮度
  Future<void> getCurrentBrightness() async {
    try {
      _currentBrightness.value = await ScreenBrightness().current;
    } catch (e) {
      throw 'Failed to get current brightness';
      //return 0;
    }
  }

  Future<void> setBrightness(double brightnes) async {
    try {
      brightness.value = brightnes;
      ScreenBrightness().setScreenBrightness(brightnes);
      // setVideoBrightness();
    } catch (e) {
      throw 'Failed to set brightness';
    }
  }

  Future<void> resetBrightness() async {
    try {
      await ScreenBrightness().resetScreenBrightness();
    } catch (e) {
      throw 'Failed to reset brightness';
    }
  }

  /// 缓存fit
  Future<void> setVideoFit() async {
    List attrs = videoFitType.map((e) => e['attr']).toList();
    int index = attrs.indexOf(_videoFit.value);
    setting.set(PLPlayerConfigKey.cacheVideoFit, index);
  }

  /// 读取fit
  Future<void> getVideoFit() async {
    int fitValue =
        setting.get(PLPlayerConfigKey.cacheVideoFit, defaultValue: 0);
    _videoFit.value = videoFitType[fitValue]['attr'];
    _videoFitDesc.value = videoFitType[fitValue]['desc'];
  }

  /// 读取亮度
  // Future<void> getVideoBrightness() async {
  //   double brightnessValue =
  //       videoStorage.get(VideoBoxKey.videoBrightness, defaultValue: 0.5);
  //   setBrightness(brightnessValue);
  // }

  set controls(bool visible) {
    _showControls.value = visible;
    _timer?.cancel();
    if (visible) {
      _hideTaskControls();
    }
  }

  void hiddenControls(bool val) {
    showControls.value = val;
  }

  /// 设置长按倍速状态 live模式下禁用
  void setDoubleSpeedStatus(bool val) {
    if (controlsLock.value) {
      return;
    }
    _doubleSpeedStatus.value = val;
    if (val) {
      setPlaybackSpeed(
          enableAutoLongPressSpeed ? playbackSpeed * 2 : longPressSpeed);
    } else {
      print(playbackSpeed);
      setPlaybackSpeed(playbackSpeed);
    }
  }

  /// 关闭控制栏
  void onLockControl(bool val) {
    HapticFeedback.lightImpact();
    _controlsLock.value = val;
    showControls.value = !val;
  }

  void toggleFullScreen(bool val) {
    _isFullScreen.value = val;
  }

  // 全屏
  Future<void> triggerFullScreen({bool status = true}) async {
    FullScreenMode mode = FullScreenModeCode.fromCode(
        setting.get(PLPlayerConfigKey.fullScreenMode, defaultValue: 0))!;
    await StatusBarControl.setHidden(true, animation: StatusBarAnimation.FADE);
    if (!isFullScreen.value && status) {
      /// 按照视频宽高比决定全屏方向
      toggleFullScreen(true);

      /// 进入全屏
      await enterFullScreen();
      if (mode == FullScreenMode.vertical ||
          (mode == FullScreenMode.auto && direction.value == 'vertical')) {
        await verticalScreen();
      } else {
        await landScape();
      }

      // bool isValid =
      //     direction.value == 'vertical' || mode == FullScreenMode.vertical
      //         ? true
      //         : false;
      // var result = await showDialog(
      //   context: Get.context!,
      //   useSafeArea: false,
      //   builder: (context) => Dialog.fullscreen(
      //     backgroundColor: Colors.black,
      //     child: SafeArea(
      //       // 忽略手机安全区域
      //       top: isValid,
      //       left: false,
      //       right: false,
      //       bottom: isValid,
      //       child: PLVideoPlayer(
      //         controller: this,
      //         headerControl: headerControl,
      //         bottomControl: bottomControl,
      //         danmuWidget: danmuWidget,
      //       ),
      //     ),
      //   ),
      // );
      // if (result == null) {
      //   // 退出全屏
      //   StatusBarControl.setHidden(false, animation: StatusBarAnimation.FADE);
      //   exitFullScreen();
      //   await verticalScreen();
      //   toggleFullScreen(false);
      // }
    } else if (isFullScreen.value) {
      StatusBarControl.setHidden(false, animation: StatusBarAnimation.FADE);
      // Get.back();
      exitFullScreen();
      await verticalScreen();
      toggleFullScreen(false);
    }
  }

  void addPositionListener(Function(Duration position) listener) =>
      _positionListeners.add(listener);
  void removePositionListener(Function(Duration position) listener) =>
      _positionListeners.remove(listener);
  void addStatusLister(Function(PlayerStatus status) listener) =>
      _statusListeners.add(listener);
  void removeStatusLister(Function(PlayerStatus status) listener) =>
      _statusListeners.remove(listener);

  Future<void> videoPlayerClosed() async {
    _timer?.cancel();
    _timerForVolume?.cancel();
    _timerForGettingVolume?.cancel();
    timerForTrackingMouse?.cancel();
    _timerForSeek?.cancel();
    videoFitChangedTimer?.cancel();
  }

  Future<void> dispose({String type = 'single'}) async {
    // 每次减1，最后销毁
    if (type == 'single' && playerCount.value > 1) {
      _playerCount.value -= 1;
      pause();
      return;
    }
    _playerCount.value = 0;
    try {
      _timer?.cancel();
      _timerForVolume?.cancel();
      _timerForGettingVolume?.cancel();
      timerForTrackingMouse?.cancel();
      _timerForSeek?.cancel();
      videoFitChangedTimer?.cancel();
      // _position.close();
      _playerEventSubs?.cancel();
      // _sliderPosition.close();
      // _sliderTempPosition.close();
      // _isSliderMoving.close();
      // _duration.close();
      // _buffered.close();
      // _showControls.close();
      // _controlsLock.close();

      // playerStatus.status.close();
      // dataStatus.status.close();

      if (_videoPlayerController != null) {
        var pp = _videoPlayerController!.platform as NativePlayer;
        await pp.setProperty('audio-files', '');
        removeListeners();
        await _videoPlayerController?.dispose();
        _videoPlayerController = null;
      }
      _instance = null;
      // 关闭所有视频页面恢复亮度
      resetBrightness();
      videoPlayerServiceHandler.clear();
    } catch (err) {
      print(err);
    }
  }
}
