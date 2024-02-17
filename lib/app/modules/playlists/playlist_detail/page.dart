import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../components/app_bar_switcher.dart';
import 'controller.dart';
import 'widgets/playlist_detail_media_preview_list/widget.dart';

class PlaylistDetailPage extends StatefulWidget {
  const PlaylistDetailPage({super.key});

  @override
  State<PlaylistDetailPage> createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  final PlaylistDetailController controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBarSwitcher(
          visible: controller.enableMultipleSelection,
          primary: AppBar(
            title: controller.title != null
                ? Text(controller.title!)
                : FutureBuilder<String?>(
                    future: controller.getPlaylistName(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.isEmpty) {
                          return Text(t.playlist.title);
                        }
                        return Text(snapshot.data!);
                      }
                      return Text(t.notifications.loading);
                    },
                  ),
            actions: [
              PopupMenuButton<String>(
                onSelected: (String type) {
                  switch (type) {
                    case 'all':
                      controller.removeAllFromPlaylist();
                      break;
                    case 'multiple':
                      controller.enableMultipleSelection = true;
                      break;
                    default:
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'all',
                    child: Text(t.records.delete_all),
                  ),
                  PopupMenuItem<String>(
                    value: 'multiple',
                    child: Text(t.records.multiple_selection_mode),
                  ),
                ],
              ),
            ],
          ),
          secondary: AppBar(
            titleSpacing: 0,
            centerTitle: false,
            leading: IconButton(
              onPressed: () {
                controller.enableMultipleSelection = false;
                controller.checkedList.clear();
                controller.checkedCount = 0;
              },
              icon: const Icon(Icons.close_outlined),
            ),
            title: Text(
              t.records.selected_num(num: controller.checkedCount),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            actions: [
              TextButton(
                onPressed: controller.toggleCheckedAll,
                child: Text(t.records.select_inverse),
              ),
              TextButton(
                onPressed: controller.deleteChecked,
                child: Text(
                  t.records.delete,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
        body: PlaylistDetailMediaPreviewList(
          parentController: controller,
          tag: controller.listTag,
          requireMyself: controller.requireMyself,
          playlistId: controller.playlistId,
        ),
      ),
    );
  }
}
