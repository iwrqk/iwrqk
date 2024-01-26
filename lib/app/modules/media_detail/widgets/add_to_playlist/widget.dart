import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../../components/load_empty.dart';
import '../../../../components/load_fail.dart';
import '../../../../data/models/playlist/light_playlist.dart';
import '../../../../routes/pages.dart';
import 'controller.dart';

class AddToPlaylistBottomSheet
    extends GetWidget<AddToPlaylistBottomSheetController> {
  final String videoId;
  const AddToPlaylistBottomSheet({
    super.key,
    required this.videoId,
  });

  Widget _buildRequireLoginWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            t.account.require_login,
            style: const TextStyle(fontSize: 17.5),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () {
              Get.toNamed(AppRoutes.login);
            },
            child: Text(
              t.account.login,
              style: const TextStyle(fontSize: 17.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataWidget(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: controller.data.length,
        itemBuilder: (context, index) => Obx(() {
          LightPlaylistModel playlist = controller.data[index];
          return ListTile(
            onTap: () {
              if (controller.selectedPlaylists
                  .contains(controller.data[index].id)) {
                controller.selectedPlaylists.remove(controller.data[index].id);
              } else {
                controller.selectedPlaylists.add(controller.data[index].id);
              }
            },
            leading: const Icon(Icons.folder),
            trailing: Checkbox(
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
            ),
            subtitle: Text(
              playlist.numVideos == 1
                  ? t.playlist.videos_count(numVideo: "${playlist.numVideos}")
                  : t.playlist
                      .videos_count_plural(numVideo: "${playlist.numVideos}"),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.init(videoId);
    return Material(
      child: Container(
        color: Theme.of(context).colorScheme.background,
        height: Get.height - Get.width / 16 * 9 - Get.mediaQuery.padding.top,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.playlist.select,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: controller.addingtoPlaylist
                        ? null
                        : controller.showCreatePlaylistDialog,
                    icon: const Icon(
                      Icons.add,
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
                              child: _buildRequireLoginWidget(),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return _buildDataWidget(context);
                },
                onError: (error) => LoadFail(
                  errorMessage: error.toString(),
                ),
                onLoading: const Center(
                  child: CircularProgressIndicator(),
                ),
                onEmpty: const Center(
                  child: LoadEmpty(),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              margin: EdgeInsets.only(bottom: Get.mediaQuery.padding.bottom),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => FilledButton(
                      style: FilledButton.styleFrom(
                        foregroundColor:
                            Theme.of(context).colorScheme.onSurface,
                        backgroundColor:
                            Theme.of(context).colorScheme.onInverseSurface,
                      ),
                      onPressed: controller.addingtoPlaylist
                          ? null
                          : () {
                              Get.back();
                            },
                      child: Text(
                        t.notifications.cancel,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(
                    () => FilledButton(
                      onPressed: controller.addingtoPlaylist
                          ? null
                          : controller.renewPlaylist,
                      child: Text(
                        t.notifications.confirm,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
