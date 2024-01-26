import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/playlist_detail_media_preview_list/widget.dart';

class PlaylistDetailPage extends StatelessWidget {
  PlaylistDetailPage({super.key});

  final String playlistId = Get.arguments["playlistId"];
  final bool requireMyself = Get.arguments["requireMyself"];
  final String title = Get.arguments["title"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PlaylistDetailMediaPreviewList(
        requireMyself: requireMyself,
        playlistId: playlistId,
      ),
    );
  }
}
