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
import '../../data/models/offline/history_meida.dart';
import '../../data/models/offline/offline_meida.dart';
import '../../data/providers/storage_provider.dart';
import '../../routes/pages.dart';
import '../reloadable_image.dart';

class MediaFlatPreview extends StatelessWidget {
  final MediaModel media;
  final Function? beforeNavigation;

  const MediaFlatPreview({
    Key? key,
    required this.media,
    this.beforeNavigation,
  }) : super(key: key);

  Widget _buildViewsAndRating(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.5),
            color: Colors.black.withAlpha(175),
          ),
          height: 25,
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.solidEye,
                size: 12.5,
                color: Colors.white,
              ),
              Container(
                  margin: EdgeInsets.only(left: 2),
                  child: Text(
                    DisplayUtil.compactBigNumber(media.numViews),
                    style: TextStyle(fontSize: 12.5, color: Colors.white),
                  ))
            ],
          ),
        ),
        if (media.rating == "ecchi")
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5),
              color: Colors.red.withAlpha(175),
            ),
            height: 25,
            child: Center(
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
          padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.5),
            color: Colors.black.withAlpha(175),
          ),
          height: 25,
          child: Row(
            children: [
              FaIcon(
                FontAwesomeIcons.solidHeart,
                size: 12.5,
                color: Colors.white,
              ),
              Container(
                  margin: EdgeInsets.only(left: 2),
                  child: Text(
                    DisplayUtil.compactBigNumber(media.numLikes),
                    style: TextStyle(fontSize: 12.5, color: Colors.white),
                  ))
            ],
          ),
        ),
        if (duration != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.5),
              color: Colors.black.withAlpha(175),
            ),
            height: 25,
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.play,
                  size: 12.5,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(left: 2),
                  child: Text(
                    "${duration.inMinutes}:${(duration.inSeconds.remainder(60)).toString().padLeft(2, '0')}",
                    style: TextStyle(fontSize: 12.5, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        if (galleryLength != null)
          if (galleryLength > 1)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7.5, vertical: 2.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.black.withAlpha(175),
              ),
              height: 25,
              child: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.solidImages,
                    size: 12.5,
                    color: Colors.white,
                  ),
                  Container(
                      margin: EdgeInsets.only(left: 2),
                      child: Text(
                        "$galleryLength",
                        style: TextStyle(fontSize: 12.5, color: Colors.white),
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
        padding: EdgeInsets.only(left: 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5)),
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
                    : AspectRatio(aspectRatio: 16 / 9),
              ),
            ),
            Positioned(
                left: 5,
                top: 5,
                bottom: 5,
                child: _buildViewsAndRating(context)),
            Positioned(
                right: 5,
                top: 5,
                bottom: 5,
                child: _buildLikesAndGallery(context)),
            if (media is VideoModel)
              if ((media as VideoModel).private)
                Positioned(
                  right: 0,
                  left: 0,
                  child: Container(
                    color: Colors.black.withAlpha(175),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: AutoSizeText(
                      L10n.of(context).meida_private,
                      style: TextStyle(
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
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText(
                media.title,
                maxLines: 2,
                style: TextStyle(
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
                                arguments: media.user.username,
                                preventDuplicates: true,
                              );
                            },
                            child: Row(
                              children: [
                                SizedBox(
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
                                    margin: EdgeInsets.only(left: 2, right: 2),
                                    child: Text(
                                      media.user.name,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Colors.grey,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 20,
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.calendar,
                            size: 12.5,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(left: 2),
                          child: Text(
                            DisplayUtil.getDisplayDate(
                              DateTime.parse(media.createdAt),
                            ),
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
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
        color: Theme.of(context).canvasColor,
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: _buildFullVerison(context),
        ),
      ),
      onTap: () {
        beforeNavigation?.call();

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
