import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../l10n.dart';
import '../../core/utils/display_util.dart';
import '../../data/enums/types.dart';
import '../../data/models/media/image.dart';
import '../../data/models/media/media.dart';
import '../../data/models/media/video.dart';
import '../../routes/pages.dart';
import '../reloadable_image.dart';

class MediaPreview extends StatelessWidget {
  final MediaModel media;

  const MediaPreview({
    Key? key,
    required this.media,
  }) : super(key: key);

  Widget _buildViewsAndRating(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
                FontAwesomeIcons.solidEye,
                size: 12.5,
                color: Colors.white,
              ),
              Container(
                margin: const EdgeInsets.only(left: 2),
                child: Text(
                  DisplayUtil.compactBigNumber(media.numViews),
                  style: const TextStyle(fontSize: 12.5, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        if (media.rating == RatingType.ecchi.value)
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

  Widget _buildLikesAndGallery(BuildContext context) {
    Duration? duration;
    int? galleryLength;

    if ((media is VideoModel)) {
      int? seconds = (media as VideoModel).file?.duration;
      if (seconds != null) duration = Duration(seconds: seconds);
    } else {
      galleryLength = (media as ImageModel).numImages;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
                FontAwesomeIcons.solidHeart,
                size: 12.5,
                color: Colors.white,
              ),
              Container(
                  margin: const EdgeInsets.only(left: 2),
                  child: Text(
                    DisplayUtil.compactBigNumber(media.numLikes),
                    style: const TextStyle(fontSize: 12.5, color: Colors.white),
                  ))
            ],
          ),
        ),
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
        if (galleryLength != null)
          if (galleryLength > 1)
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
                        "$galleryLength",
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
      Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(7.5)),
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: media.hasCover()
                  ? ReloadableImage(
                      imageUrl: media.getCoverUrl(),
                      aspectRatio: 16 / 9,
                      fit: BoxFit.cover,
                      isAdult: media.rating == RatingType.ecchi.value,
                    )
                  : const AspectRatio(aspectRatio: 16 / 9),
            ),
          ),
          Positioned(
              left: 5, top: 5, bottom: 5, child: _buildViewsAndRating(context)),
          Positioned(
              right: 5,
              top: 5,
              bottom: 5,
              child: _buildLikesAndGallery(context)),
          if (media is VideoModel)
            if ((media as VideoModel).private)
              Container(
                color: Colors.black.withAlpha(175),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AutoSizeText(
                  L10n.of(context).media_private,
                  maxLines: 1,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
        ],
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                child: AutoSizeText(
                  media.title,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 12.5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(7.5, 0, 7.5, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.profile,
                          arguments: media.user.username,
                          preventDuplicates: true,
                        );
                      },
                      child: Row(children: [
                        const FaIcon(
                          FontAwesomeIcons.solidUser,
                          size: 12.5,
                          color: Colors.grey,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2, right: 2),
                            child: Text(
                              media.user.name,
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                  Text(
                    DisplayUtil.getDisplayDate(DateTime.parse(media.createdAt)),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.5),
        ),
        child: Column(
          children: _buildFullVerison(context),
        ),
      ),
      onTap: () {
        Get.toNamed(
          AppRoutes.mediaDetail,
          arguments: {
            "mediaType":
                media is VideoModel ? MediaType.video : MediaType.image,
            "id": media.id,
          },
          preventDuplicates: false,
        );
      },
    );
  }
}
