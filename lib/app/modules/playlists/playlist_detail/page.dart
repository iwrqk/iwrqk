import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/providers/api_provider.dart';
import 'widgets/playlist_detail_media_preview_list/widget.dart';

class PlaylistDetailPage extends StatelessWidget {
  PlaylistDetailPage({super.key});

  final String playlistId = Get.parameters["playlistId"]!;
  final bool requireMyself = Get.parameters["requireMyself"] != null &&
      Get.parameters["requireMyself"] == "true";
  final String? title = Get.arguments["title"];

  Future<String?> getPlaylistName() {
    return ApiProvider.getPlaylistName(playlistId: playlistId).then((value) {
      if (value.success) {
        return value.data;
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title != null
            ? Text(title!)
            : FutureBuilder<String?>(
                future: getPlaylistName(),
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
      ),
      body: PlaylistDetailMediaPreviewList(
        requireMyself: requireMyself,
        playlistId: playlistId,
      ),
    );
  }
}
