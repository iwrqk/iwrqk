import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../l10n.dart';
import '../../../../core/const/iwara.dart';
import '../../../../global_widgets/reloadable_image.dart';
import '../../../../routes/pages.dart';

class PlaylistPreview extends StatelessWidget {
  final String playlistId;
  final String title;
  final int videosCount;

  const PlaylistPreview({
    super.key,
    required this.playlistId,
    required this.title,
    required this.videosCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.playlistDetail, arguments: playlistId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2.5, 0, 2.5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: const ReloadableImage(
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
                                ? L10n.of(context)
                                    .playlist_videos_count("$videosCount")
                                : L10n.of(context).playlist_videos_count_plural(
                                    "$videosCount"),
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const FaIcon(
                      FontAwesomeIcons.chevronRight,
                      size: 25,
                      color: Colors.grey,
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
