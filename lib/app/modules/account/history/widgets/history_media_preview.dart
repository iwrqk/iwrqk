import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../l10n.dart';
import '../../../../core/utils/display_util.dart';
import '../../../../data/enums/types.dart';
import '../../../../data/models/offline/history_meida.dart';
import '../../../../data/models/offline/offline_meida.dart';
import '../../../../global_widgets/reloadable_image.dart';
import '../../../../routes/pages.dart';

class HistoryMediaPreview extends StatelessWidget {
  final HistoryMediaModel media;
  final bool showType;

  const HistoryMediaPreview(
      {Key? key, required this.media, this.showType = true})
      : super(key: key);

  Widget _buildRating() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (media.ratingType == "ecchi")
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5),
              color: Colors.red.withAlpha(175),
            ),
            height: 25,
            child: const Center(
                child: Text(
              "R-18",
              style: TextStyle(fontSize: 12.5, color: Colors.white),
            )),
          ),
      ],
    );
  }

  Widget _buildDurationGallery() {
    Duration? duration;

    if (media.duration != null) {
      duration = Duration(seconds: media.duration!);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (duration != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5),
              color: Colors.black.withAlpha(175),
            ),
            height: 25,
            child: Row(
              children: [
                const FaIcon(
                  FontAwesomeIcons.play,
                  size: 12.5,
                  color: Colors.white,
                ),
                Container(
                    margin: const EdgeInsets.only(left: 2),
                    child: Text(
                      "${duration.inMinutes}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}",
                      style:
                          const TextStyle(fontSize: 12.5, color: Colors.white),
                    ))
              ],
            ),
          ),
        if (media.galleryLength != null)
          if (media.galleryLength! > 1)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.black.withAlpha(175),
              ),
              height: 25,
              child: Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.solidImages,
                    size: 12.5,
                    color: Colors.white,
                  ),
                  Container(
                      margin: const EdgeInsets.only(left: 2),
                      child: Text(
                        "${media.galleryLength}",
                        style: const TextStyle(
                            fontSize: 12.5, color: Colors.white),
                      ))
                ],
              ),
            ),
      ],
    );
  }

  List<Widget> _buildFullVerison(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                child: Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: media.coverUrl != null
                      ? ReloadableImage(
                          imageUrl: media.coverUrl!,
                          aspectRatio: 16 / 9,
                          fit: BoxFit.cover,
                          isAdult: media.ratingType == RatingType.ecchi.value,
                        )
                      : const AspectRatio(aspectRatio: 16 / 9),
                )),
            Positioned(left: 5, bottom: 5, child: _buildRating()),
            Positioned(right: 5, bottom: 5, child: _buildDurationGallery()),
            if (media.isPrivate)
              Positioned(
                right: 0,
                left: 0,
                child: Container(
                  color: Colors.black.withAlpha(175),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 2.5),
                  child: AutoSizeText(
                    L10n.of(context).meida_private,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
          ],
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                media.title,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12.5,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.profile,
                                arguments: media.uploader.username,
                                preventDuplicates: true,
                              );
                            },
                            child: Row(children: [
                              const SizedBox(
                                width: 20,
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.solidUser,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(left: 2, right: 2),
                                  child: Text(
                                    media.uploader.name,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              )
                            ]),
                          ),
                        ),
                        if (showType)
                          Text(
                            media.type == MediaType.video
                                ? L10n.of(context).video
                                : L10n.of(context).image,
                            style: const TextStyle(
                                fontSize: 12.5, color: Colors.grey),
                          )
                      ]),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 20,
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.tv,
                            size: 12.5,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.only(left: 2),
                          child: Text(
                            DisplayUtil.getDisplayDate(media.viewedDate),
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: _buildFullVerison(context),
        ),
      ),
      onTap: () {
        Get.toNamed(AppRoutes.mediaDetail, arguments: {
          "mediaType": media.type,
          "id": media.id,
          "offlineMedia": OfflineMediaModel.fromHistoryMediaPreviewData(media),
        });
      },
    );
  }
}
