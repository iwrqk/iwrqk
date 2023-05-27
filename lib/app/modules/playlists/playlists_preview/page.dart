import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../../l10n.dart';
import '../../../global_widgets/dialogs/create_playlis_dialog/widget.dart';
import 'controller.dart';
import 'widgets/playlists_preview_list/widget.dart';

class PlaylistsPreviewPage extends GetView<PlaylistsPreviewController> {
  const PlaylistsPreviewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0,
          ),
        ),
        centerTitle: true,
        title: Text(L10n.of(context).user_playlists),
        actions: [
          if (controller.requireMyself)
            IconButton(
              onPressed: () {
                Get.dialog(
                  CreatePlaylistDialog(
                    onChanged: () {
                      controller.refreshData();
                    },
                  ),
                );
              },
              icon: const FaIcon(
                FontAwesomeIcons.plus,
              ),
            ),
        ],
      ),
      body: SizeCacheWidget(
        child: PlaylistsPreviewList(
          userId: controller.userId,
          requireMyself: controller.requireMyself,
          tag: controller.tag,
        ),
      ),
    );
  }
}
