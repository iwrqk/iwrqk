import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Translations;
import 'package:iwrqk/i18n/strings.g.dart';

import '../../utils/display_util.dart';
import '../../data/enums/types.dart';
import '../../data/models/media/image.dart';
import '../../data/models/media/media.dart';
import '../../data/models/media/video.dart';
import '../network_image.dart';

class MediaFlatPreview extends StatelessWidget {
  final MediaModel media;
  final Widget? coverOverlay;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const MediaFlatPreview({
    Key? key,
    required this.media,
    this.coverOverlay,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  Widget _buildBadges(BuildContext context) {
    Duration? duration;
    int? galleryLength;

    if ((media is VideoModel)) {
      int? seconds = (media as VideoModel).file?.duration;
      if (seconds != null) duration = Duration(seconds: seconds);
    } else {
      galleryLength = (media as ImageModel).numImages;
    }

    return Row(
      mainAxisAlignment: media.rating == RatingType.ecchi.value
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        if (media.rating == RatingType.ecchi.value)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.red.withAlpha(160),
            ),
            child: const Center(
                child: Text(
              "R-18",
              style: TextStyle(fontSize: 12, color: Colors.white),
            )),
          ),
        if (duration != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black.withAlpha(126),
            ),
            child: Text(
              "${duration.inMinutes}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}",
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        if (galleryLength != null)
          if (galleryLength > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black.withAlpha(126),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.photo_library,
                    size: 12,
                    color: Colors.white,
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 2),
                    child: Text(
                      "$galleryLength",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildCover(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: media.hasCover()
                  ? NetworkImg(
                      imageUrl: media.getCoverUrl(),
                      aspectRatio: 16 / 9,
                      fit: BoxFit.cover,
                      isAdult: media.rating == RatingType.ecchi.value,
                    )
                  : const AspectRatio(aspectRatio: 16 / 9),
            ),
          ),
          if (media is VideoModel)
            if ((media as VideoModel).private)
              Positioned(
                right: 0,
                left: 0,
                child: Container(
                  color: Colors.black.withAlpha(160),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    t.media.private,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          Positioned(
            bottom: 4,
            right: 6,
            left: 6,
            child: _buildBadges(context),
          ),
          if (coverOverlay != null) coverOverlay!,
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(right: 2),
                  child: Icon(
                    Icons.remove_red_eye_outlined,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextSpan(
                text: DisplayUtil.compactBigNumber(media.numViews),
                style: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 2),
                  child: Icon(
                    Icons.favorite_outline,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextSpan(
                text: DisplayUtil.compactBigNumber(media.numLikes),
                style: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(children: [
                Icon(
                  Icons.person,
                  size: 16,
                  color: Theme.of(context).colorScheme.outline,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2, right: 2),
                    child: Text(
                      media.user.name,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Theme.of(context).colorScheme.outline,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                )
              ]),
            ),
            Text(
              DisplayUtil.getDisplayDate(DateTime.parse(media.createdAt)),
              style: TextStyle(
                  fontSize: 12.5, color: Theme.of(context).colorScheme.outline),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget left = Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: AutoSizeText(
              media.title,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          _buildDescription(context),
        ],
      ),
    );

    return InkWell(
      onLongPress: onLongPress,
      onTap: onTap ??
          () {
            Get.toNamed(
              "/mediaDetail?id=${media.id}",
              arguments: {
                "mediaType":
                    media is VideoModel ? MediaType.video : MediaType.image,
              },
            );
          },
      child: Container(
        constraints: const BoxConstraints(maxHeight: 116),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: Get.mediaQuery.orientation == Orientation.portrait
              ? [
                  Flexible(
                    flex: 5,
                    child: _buildCover(context),
                  ),
                  Flexible(flex: 6, child: left)
                ]
              : [
                  Container(
                    constraints: const BoxConstraints(maxWidth: 168),
                    child: _buildCover(context),
                  ),
                  Expanded(child: left),
                ],
        ),
      ),
    );
  }
}
