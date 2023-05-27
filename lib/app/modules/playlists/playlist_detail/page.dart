import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../../l10n.dart';
import 'widgets/playlist_detail_media_preview_list/widget.dart';

class PlaylistDetailPage extends StatelessWidget {
  PlaylistDetailPage({super.key});

  final String playlistId = Get.arguments;

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
      ),
      body: SizeCacheWidget(
        child: PlaylistDetailMediaPreviewList(
          playlistId: playlistId,
        ),
      ),
    );
  }
}
