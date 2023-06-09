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
              const Padding(
                padding: EdgeInsets.only(right: 10),
                child: FaIcon(
                  FontAwesomeIcons.userCheck,
                  size: 42,
                  color: Colors.grey,
                ),
              ),
              Text(
                L10n.of(context).message_require_login,
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.login);
            },
            child: Text(
              L10n.of(context).login,
              style: const TextStyle(fontSize: 17.5),
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
            margin: const EdgeInsets.all(20),
            child: Text(
              errorMessage,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDataWidget(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
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
              style: const TextStyle(fontSize: 17.5),
            ),
            subtitle: Text(
              playlist.numVideos == 1
                  ? L10n.of(context)
                      .playlist_videos_count("${playlist.numVideos}")
                  : L10n.of(context)
                      .playlist_videos_count_plural("${playlist.numVideos}"),
              style: const TextStyle(fontSize: 15),
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).orientation == Orientation.portrait
            ? double.infinity
            : MediaQuery.of(context).size.width / 2,
        maxHeight: MediaQuery.of(context).orientation == Orientation.portrait &&
                MediaQuery.of(context).size.height > 600
            ? MediaQuery.of(context).size.height / 2
            : MediaQuery.of(context).size.height / 1.25,
      ),
      builder: (BuildContext context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      L10n.of(context).playlist_select,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.addingtoPlaylist
                          ? null
                          : controller.showCreatePlaylistDialog,
                      child: const FaIcon(
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
                      return CustomScrollView(
                        slivers: [
                          SliverSafeArea(
                            sliver: SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(
                                child: _buildRequireLoginWidget(context),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return _buildDataWidget(context);
                  },
                  onError: (error) =>
                      _buildLoadFailWidget(context, error.toString()),
                  onLoading: const Center(
                    child: IwrProgressIndicator(),
                  ),
                  onEmpty: const Center(
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
                      color: Theme.of(context).dividerColor,
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
