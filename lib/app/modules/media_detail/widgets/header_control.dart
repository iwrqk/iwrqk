import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../components/plugin/pl_player/index.dart';
import '../../../data/models/resolution.dart';
import '../../../data/providers/storage_provider.dart';
import '../../../routes/pages.dart';
import '../controller.dart';

class HeaderControl extends StatefulWidget implements PreferredSizeWidget {
  const HeaderControl({
    this.controller,
    this.videoDetailCtr,
    this.floating,
    super.key,
  });
  final PlPlayerController? controller;
  final MediaDetailController? videoDetailCtr;
  final Floating? floating;

  @override
  State<HeaderControl> createState() => _HeaderControlState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _HeaderControlState extends State<HeaderControl> {
  List<ResolutionModel> resolutions = [];
  List<PlaySpeed> playSpeed = PlaySpeed.values;
  static const TextStyle subTitleStyle = TextStyle(fontSize: 14);
  static const TextStyle titleStyle = TextStyle(fontSize: 16);
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
  late List<double> speedsList;
  double buttonSpace = 8;
  GStorageConfig setting = StorageProvider.config;

  @override
  void initState() {
    super.initState();
    resolutions = widget.videoDetailCtr!.resolutions;
    speedsList = widget.controller!.speedsList;
  }

  @override
  Widget build(BuildContext context) {
    final _ = widget.controller!;
    const TextStyle textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
    );
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      primary: false,
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: 8,
      title: Row(
        children: [
          ComBtn(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            fuc: () => <Set<void>>{
              if (widget.controller!.isFullScreen.value)
                <void>{widget.controller!.triggerFullScreen(status: false)}
              else
                <void>{
                  if (MediaQuery.of(context).orientation ==
                      Orientation.landscape)
                    {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                      ])
                    },
                  Get.back()
                }
            },
          ),
          SizedBox(width: buttonSpace),
          ComBtn(
            icon: const Icon(
              Icons.home,
              color: Colors.white,
            ),
            fuc: () async {
              // 销毁播放器实例
              await widget.controller!.dispose(type: 'all');
              if (mounted) {
                Navigator.popUntil(
                    context, ModalRoute.withName(AppRoutes.home));
              }
            },
          ),
          const Spacer(),
          SizedBox(width: buttonSpace),
          if (GetPlatform.isAndroid) ...<Widget>[
            ComBtn(
              icon: const Icon(
                Icons.picture_in_picture,
                size: 20,
                color: Colors.white,
              ),
              fuc: () async {
                bool canUsePiP = false;
                widget.controller!.hiddenControls(false);
                try {
                  canUsePiP = await widget.floating!.isPipAvailable;
                } on PlatformException catch (_) {
                  canUsePiP = false;
                }
                if (canUsePiP) {
                  final Rational aspectRatio =
                      widget.videoDetailCtr?.aspectRatio ??
                          const Rational(16, 9);
                  await widget.floating!.enable(aspectRatio: aspectRatio);
                } else {}
              },
            ),
            SizedBox(width: buttonSpace),
          ],
          if (Get.mediaQuery.orientation == Orientation.landscape) ...[
            Obx(
              () => SizedBox(
                width: 46,
                height: 34,
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () => showSetSpeedSheet(),
                  child: Text(
                    '${_.playbackSpeed}X',
                    style: textStyle,
                  ),
                ),
              ),
            ),
            SizedBox(width: buttonSpace),
            SizedBox(
              height: 34,
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
                onPressed: () => showResolutionSheet(),
                child: Text(
                  widget.videoDetailCtr!
                      .resolutions[widget.videoDetailCtr!.resolutionIndex].name,
                  style: textStyle,
                ),
              ),
            ),
          ],
          ComBtn(
            icon: const Icon(
              Icons.more_vert_outlined,
              color: Colors.white,
            ),
            fuc: () => showSettingSheet(),
          ),
        ],
      ),
    );
  }

  /// 设置面板
  void showSettingSheet() {
    showModalBottomSheet(
      elevation: 0,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: Get.height * 0.6,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 36,
                child: Center(
                  child: Container(
                    width: 32,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondaryContainer
                          .withOpacity(0.5),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Material(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.hd),
                        title: Text(t.player.quality, style: titleStyle),
                        subtitle: Text(
                            t.player.current_item(
                                item: widget
                                    .videoDetailCtr!
                                    .resolutions[
                                        widget.videoDetailCtr!.resolutionIndex]
                                    .name),
                            style: subTitleStyle),
                        onTap: () => {Get.back(), showResolutionSheet()},
                      ),
                      ListTile(
                        leading: const Icon(Icons.speed),
                        title: Text(t.player.playback_speed, style: titleStyle),
                        subtitle: Text(
                            t.player.current_item(
                                item: '${widget.controller!.playbackSpeed}X'),
                            style: subTitleStyle),
                        onTap: () => {Get.back(), showSetSpeedSheet()},
                      ),
                      ListTile(
                        leading: const Icon(Icons.rectangle),
                        title: Text(t.player.aspect_ratio, style: titleStyle),
                        subtitle: Text(
                            t.player.current_item(
                                item: widget.controller!.videoFitDEsc.value),
                            style: subTitleStyle),
                        onTap: () => {Get.back(), showVideoFitSheet()},
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      clipBehavior: Clip.hardEdge,
      isScrollControlled: true,
    );
  }

  void showSetSpeedSheet() {
    final double currentSpeed = widget.controller!.playbackSpeed;
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: Get.height * 0.6,
          padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(t.player.select_playback_speed, style: titleStyle),
              ),
              Expanded(
                child: Material(
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        for (final double i in speedsList) ...<Widget>[
                          if (i == currentSpeed) ...<Widget>[
                            ListTile(
                              title: Text(i.toString()),
                              trailing: Icon(Icons.check,
                                  color: Theme.of(context).colorScheme.primary),
                              onTap: () async {
                                await widget.controller!.setPlaybackSpeed(i);
                                Get.back();
                              },
                            ),
                          ] else ...[
                            ListTile(
                              title: Text(i.toString()),
                              onTap: () async {
                                await widget.controller!.setPlaybackSpeed(i);
                                Get.back();
                              },
                            ),
                          ]
                        ]
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showVideoFitSheet() {
    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: Get.height * 0.6,
          padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(t.player.select_aspect_ratio, style: titleStyle),
              ),
              Expanded(
                child: Material(
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        for (final i in widget.controller!.videoFitType)
                          ListTile(
                            title: Text(i['desc']),
                            trailing: i['attr'] ==
                                    widget.controller!.videoFit.value
                                ? Icon(Icons.check,
                                    color:
                                        Theme.of(context).colorScheme.primary)
                                : null,
                            onTap: () async {
                              widget.controller!.videoFit.value = i['attr'];
                              widget.controller!.videoFitDEsc.value = i['desc'];
                              widget.controller!.setVideoFit();
                              Get.back();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void showResolutionSheet() {
    List<ResolutionModel> resolutions = widget.videoDetailCtr!.resolutions;

    showModalBottomSheet(
      context: context,
      elevation: 0,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(t.player.select_quality, style: titleStyle),
              ),
              Expanded(
                child: Material(
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        for (final ResolutionModel i
                            in resolutions) ...<Widget>[
                          ListTile(
                            title: Text(i.name),
                            trailing: i ==
                                    widget.videoDetailCtr!.resolutions[
                                        widget.videoDetailCtr!.resolutionIndex]
                                ? Icon(
                                    Icons.check,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  )
                                : null,
                            onTap: () async {
                              widget.videoDetailCtr!.resolutionIndex =
                                  resolutions.indexOf(i);
                              widget.videoDetailCtr!.updatePlayer();
                              Get.back();
                            },
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
