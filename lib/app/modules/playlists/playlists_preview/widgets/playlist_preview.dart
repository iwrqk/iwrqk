import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../../components/network_image.dart';
import '../../../../const/iwara.dart';
import '../../../../routes/pages.dart';

class PlaylistPreview extends StatelessWidget {
  final String playlistId;
  final String title;
  final int videosCount;
  final bool requireMyself;

  const PlaylistPreview({
    super.key,
    required this.playlistId,
    required this.title,
    required this.videosCount,
    this.requireMyself = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.playlistDetail, arguments: {
          "playlistId": playlistId,
          "requireMyself": requireMyself,
          "title": title
        });
      },
      child: Container(
        constraints: const BoxConstraints(maxHeight: 116),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 168),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: const NetworkImg(
                      imageUrl: IwaraConst.defaultCoverUrl,
                      aspectRatio: 16 / 9,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 17.5,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                          Text(
                            videosCount == 1
                                ? t.playlist
                                    .videos_count(numVideo: "$videosCount")
                                : t.playlist.videos_count_plural(
                                    numVideo: "$videosCount"),
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Theme.of(context).colorScheme.outline,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 24,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
