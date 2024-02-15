import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../../components/network_image.dart';
import '../../../../data/enums/types.dart';
import '../../../../data/models/offline/history_media.dart';
import '../../../../utils/display_util.dart';
import '../controller.dart';

class HistoryMediaPreview extends StatelessWidget {
  final HistoryController historyController;
  final bool checked;
  final HistoryMediaModel media;
  final bool showType;
  final void Function()? onTap;
  final void Function()? onLongPress;

  const HistoryMediaPreview({
    Key? key,
    required this.historyController,
    required this.media,
    this.checked = false,
    this.showType = true,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  Widget _buildBadges(BuildContext context) {
    Duration? duration;
    int? galleryLength;

    if ((media.type == MediaType.video)) {
      if (media.duration != null) {
        duration = Duration(seconds: media.duration!);
      }
    } else {
      galleryLength = media.galleryLength;
    }

    return Row(
      mainAxisAlignment: media.ratingType == RatingType.ecchi.value
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.end,
      children: [
        if (media.ratingType == RatingType.ecchi.value)
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
              child: media.coverUrl != null
                  ? NetworkImg(
                      imageUrl: media.coverUrl!,
                      aspectRatio: 16 / 9,
                      fit: BoxFit.cover,
                      isAdult: media.ratingType == RatingType.ecchi.value,
                    )
                  : const AspectRatio(aspectRatio: 16 / 9),
            ),
          ),
          if (media.type == MediaType.video)
            if (media.isPrivate)
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
          Obx(
            () => Positioned.fill(
              child: AnimatedOpacity(
                opacity: historyController.enableMultipleSelection ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withOpacity(
                        historyController.enableMultipleSelection && checked
                            ? 0.6
                            : 0),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 34,
                      height: 34,
                      child: AnimatedScale(
                        scale: checked ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: (Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.white
                                    : Colors.black)
                                .withOpacity(0.8),
                          ),
                          child: Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                    Icons.person,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
              TextSpan(
                text: media.uploader.name,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Icon(
                    Icons.tv,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2),
                      child: Text(
                        DisplayUtil.getDisplayDate(media.viewedDate),
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Theme.of(context).colorScheme.outline,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (showType)
              Text(
                media.type == MediaType.video ? t.common.video : t.common.image,
                style: TextStyle(
                    fontSize: 12.5,
                    color: Theme.of(context).colorScheme.outline),
              )
          ],
        ),
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
      onTap: onTap,
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
