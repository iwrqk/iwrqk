import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../l10n.dart';
import '../../../../data/models/playlist/light_playlist.dart';
import '../../../../global_widgets/iwr_progress_indicator.dart';
import '../../../../routes/pages.dart';
import 'controller.dart';

class AddToPlaylistBottomSheet
    extends GetWidget<AddToPlaylistBottomSheetController> {
  final String videoId;
  const AddToPlaylistBottomSheet({
    super.key,
    required this.videoId,
  });

  Widget _buildRequireLoginWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: FaIcon(
                  FontAwesomeIcons.userCheck,
                  size: 42,
                  color: Colors.grey,
                ),
              ),
              Text(
                L10n.of(context).message_require_login,
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.login);
            },
            child: Text(
              L10n.of(context).login,
              style: TextStyle(fontSize: 17.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadFailWidget(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: controller.refreshData,
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowRotateLeft,
                  color: Theme.of(context).primaryColor,
                  size: 42,
                ),
              )),
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              errorMessage,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDataWidget(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10),
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: controller.data.length,
        itemBuilder: (context, index) => Obx(() {
          LightPlaylistModel playlist = controller.data[index];
          return ListTile(
            leading: Checkbox(
              activeColor: Theme.of(context).primaryColor,
              value: controller.selectedPlaylists.contains(playlist.id),
              onChanged: (value) {
                if (value == true) {
                  controller.selectedPlaylists.add(playlist.id);
                } else {
                  controller.selectedPlaylists.remove(playlist.id);
                }
              },
            ),
            title: Text(
              playlist.title,
              style: TextStyle(fontSize: 17.5),
            ),
            subtitle: Text(
              playlist.numVideos == 1
                  ? L10n.of(context)
                      .playlist_videos_count("${playlist.numVideos}")
                  : L10n.of(context)
                      .playlist_videos_count_plural("${playlist.numVideos}"),
              style: TextStyle(fontSize: 15),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.init(videoId);
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 2.5,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      L10n.of(context).playlist_select,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.addingtoPlaylist
                          ? null
                          : controller.showCreatePlaylistDialog,
                      child: FaIcon(
                        FontAwesomeIcons.plus,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: controller.obx(
                  (state) {
                    if (!controller.userService.accountService.isLogin) {
                      return ListView(
                        children: [_buildRequireLoginWidget(context)],
                      );
                    }
                    return _buildDataWidget(context);
                  },
                  onError: (error) =>
                      _buildLoadFailWidget(context, error.toString()),
                  onLoading: Center(
                    child: IwrProgressIndicator(),
                  ),
                  onEmpty: Center(
                    child: FaIcon(
                      FontAwesomeIcons.boxArchive,
                      color: Colors.grey,
                      size: 42,
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                child: Obx(
                  () => CupertinoButton(
                    padding: EdgeInsets.zero,
                    borderRadius: BorderRadius.zero,
                    onPressed: controller.addingtoPlaylist
                        ? null
                        : controller.renewPlaylist,
                    child: Text(
                      L10n.of(context).confirm,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
