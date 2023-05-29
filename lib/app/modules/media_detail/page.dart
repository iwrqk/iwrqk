import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../l10n.dart';
import '../../core/const/iwara.dart';
import '../../core/utils/display_util.dart';
import '../../data/enums/types.dart';
import '../../data/models/media/image.dart';
import '../../data/models/media/video.dart';
import '../../global_widgets/buttons/follow_button/widget.dart';
import '../../global_widgets/comments/comments_list/widget.dart';
import '../../global_widgets/comments/send_comment_bottom_sheet/widget.dart';
import '../../global_widgets/iwr_markdown.dart';
import '../../global_widgets/iwr_progress_indicator.dart';
import '../../global_widgets/media_preview/media_flat_preview.dart';
import '../../global_widgets/reloadable_image.dart';
import '../../global_widgets/tab_indicator.dart';
import '../../global_widgets/translated_content.dart';
import '../../global_widgets/user_preview/user_preview.dart';
import '../../routes/pages.dart';
import 'controller.dart';
import 'widgets/add_to_playlist_bottom_sheet/widget.dart';
import 'widgets/create_video_download_task_dialog/widget.dart';
import 'widgets/iwr_gallery.dart';

class MediaDetailPage extends StatefulWidget {
  const MediaDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MediaDetailPage> createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends State<MediaDetailPage> {
  final MediaDetailController _controller = Get.find();

  final ScrollController _detailController = ScrollController();
  final ScrollController _commentsController = ScrollController();

  Widget? detailWidget;
  Widget? mediaWidget;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildLoadingWidget() {
    String errorMessage = _controller.errorMessage;
    if (errorMessage == "") {
      return const Center(
        child: IwrProgressIndicator(),
      );
    } else if (errorMessage == "errors.privateVideo") {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: FaIcon(
                      FontAwesomeIcons.lock,
                      size: 42,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    L10n.of(context).meida_private,
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: UserPreview(
                user: _controller.user,
                showFriendButton: true,
                showFollowButton: false,
              ),
            )
          ],
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  _controller.errorMessage = "";
                  _controller.isLoading = true;
                  _controller.loadData();
                },
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.arrowRotateLeft,
                    color: Theme.of(context).primaryColor,
                    size: 42,
                  ),
                )),
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                _controller.errorMessage,
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.grey),
              ),
            )
          ],
        ),
      );
    }
  }

  Widget _buildPlayer() {
    Widget child;

    Widget exitButton = Positioned(
      top: 5,
      left: 5,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
    );

    return Obx(() {
      if (_controller.isFectchingResolution) {
        child = Container(
          color: Colors.black,
          child: Stack(
            children: [
              exitButton,
              Obx(
                () => Center(
                  child: !_controller.fetchFailed
                      ? const IwrProgressIndicator()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                _controller.refectchVideos();
                              },
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.arrowRotateLeft,
                                  color: Theme.of(context).primaryColor,
                                  size: 42,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: Text(
                                L10n.of(context).error_fetch_failed,
                                style: const TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                ),
              )
            ],
          ),
        );
      } else if ((_controller.media as VideoModel).embedUrl != null) {
        child = Container(
          color: Colors.black,
          child: Stack(
            alignment: Alignment.center,
            children: [
              exitButton,
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.circleInfo,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(L10n.of(context).video_page_external_video)
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          launchUrlString(
                              (_controller.media as VideoModel).embedUrl!);
                        },
                        icon:
                            const FaIcon(FontAwesomeIcons.solidShareFromSquare),
                        label: Text(L10n.of(context).open),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        child = BetterPlayer(
          controller: _controller.iwrPlayerController!.betterPlayerController,
        );
      }
      return child;
    });
  }

  Widget _buildGallery() {
    return IwrGallery(
      imageUrls: (_controller.media as ImageModel).galleryFileUrls,
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: TabBar(
        isScrollable: true,
        indicator: TabIndicator(context),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: [
          Tab(text: L10n.of(context).details),
          Tab(
            text: L10n.of(context).comments,
          )
        ],
      ),
    );
  }

  Widget _buildTagClip(BuildContext context, int index) {
    String title = _controller.media.tags[index].id;
    return GestureDetector(
      onTap: () {},
      onLongPress: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Text(
          title,
          style: const TextStyle(height: 1),
        ),
      ),
    );
  }

  Widget _buildMediaDetail() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildUploaderWidget(),
        _buildMediaTitle(),
        _buildLikesAndViews(),
        _buildDescription(),
        _buildFunctionButtons()
      ]),
    );
  }

  void _gotoUploaderProfilePage() {
    _controller.pauseVideo();
    Get.toNamed(
      AppRoutes.profile,
      arguments: _controller.media.user.username,
      preventDuplicates: true,
    );
  }

  Widget _buildUploaderWidget() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 5),
      leading: GestureDetector(
        onTap: _gotoUploaderProfilePage,
        child: ClipOval(
          child: ReloadableImage(
            imageUrl: _controller.media.user.avatarUrl,
            width: 40,
            height: 40,
          ),
        ),
      ),
      title: GestureDetector(
        onTap: _gotoUploaderProfilePage,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _controller.media.user.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              DisplayUtil.getDisplayTime(
                  DateTime.parse(_controller.media.createdAt)),
              style: const TextStyle(color: Colors.grey, fontSize: 12.5),
            ),
          ],
        ),
      ),
      trailing: FollowButton(user: _controller.media.user),
    );
  }

  Widget _buildMediaTitle() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        _controller.detailExpanded = !_controller.detailExpanded;

        if (_controller.detailExpanded) {
          _controller.animationController.forward();
        } else {
          _controller.animationController.reverse();
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _controller.detailExpanded
                ? SelectableText(
                    _controller.media.title,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    _controller.media.title,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5),
            alignment: Alignment.topRight,
            child: RotationTransition(
              turns: _controller.iconTurn,
              child: const FaIcon(FontAwesomeIcons.chevronDown, size: 20),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLikesAndViews() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const FaIcon(
            FontAwesomeIcons.solidEye,
            size: 15,
            color: Colors.grey,
          ),
          Container(
              margin: const EdgeInsets.only(left: 5, right: 15),
              child: Text(
                DisplayUtil.formatNumberWithCommas(_controller.media.numViews),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              )),
          const FaIcon(
            FontAwesomeIcons.solidHeart,
            size: 15,
            color: Colors.grey,
          ),
          Container(
              margin: const EdgeInsets.only(left: 5),
              child: Text(
                DisplayUtil.formatNumberWithCommas(_controller.media.numLikes),
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ))
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Obx(() {
      final bool closed = !_controller.detailExpanded &&
          _controller.animationController.isDismissed;

      final Widget result = Offstage(
        offstage: closed,
        child: TickerMode(
          enabled: !closed,
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IwrMarkdown(
                  selectable: true,
                  data: _controller.media.body ?? "",
                ),
                if (_controller.translatedContent.isNotEmpty)
                  TranslatedContent(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    translatedContent: _controller.translatedContent,
                  ),
                if ((_controller.media.body ?? "").isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _controller.getTranslatedContent();
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.language,
                          size: 15,
                        ),
                        label: Text(
                          L10n.of(context).translate,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_controller.media.tags.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(
                        _controller.media.tags.length,
                        (index) => _buildTagClip(context, index),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );

      return AnimatedBuilder(
        animation: _controller.animationController.view,
        builder: (_, child) {
          return ClipRect(
            child: Align(
              heightFactor: _controller.heightFactor.value,
              child: child,
            ),
          );
        },
        child: closed ? null : result,
      );
    });
  }

  Widget _buildFunctionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => InkWell(
              onTap: _controller.isProcessingFavorite
                  ? null
                  : () {
                      if (_controller.isFavorite) {
                        _controller.unfavoriteMedia();
                      } else {
                        _controller.favroiteMedia();
                      }
                    },
              child: FaIcon(
                FontAwesomeIcons.solidHeart,
                size: 30,
                color: _controller.isFavorite ? Colors.redAccent : null,
              ),
            ),
          ),
          if (_controller.mediaType == MediaType.video)
            InkWell(
              child: const FaIcon(
                FontAwesomeIcons.list,
                size: 35,
              ),
              onTap: () {
                Get.bottomSheet(
                  AddToPlaylistBottomSheet(
                    videoId: _controller.media.id,
                  ),
                );
              },
            ),
          InkWell(
              child: const FaIcon(
                FontAwesomeIcons.solidShareFromSquare,
                size: 30,
              ),
              onTap: () {
                if (_controller.mediaType == MediaType.video) {
                  Share.share(IwaraConst.videoPageUrl
                      .replaceAll("{id}", _controller.media.id));
                } else {
                  Share.share(IwaraConst.imagePageUrl
                      .replaceAll("{id}", _controller.media.id));
                }
              }),
          InkWell(
            child: const FaIcon(
              FontAwesomeIcons.download,
              size: 30,
            ),
            onTap: () {
              if (_controller.mediaType == MediaType.video) {
                if (_controller.resolutions.isEmpty) {
                  showToast(L10n.of(context).error_fetch_failed);
                  return;
                }
                Get.dialog(
                  CreateVideoDownloadDialog(
                    resolutions: _controller.resolutions,
                    previewData: _controller.offlineMedia,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRecommendation() {
    return [
      if (_controller.moreFromUser.isNotEmpty)
        Container(
          color: Theme.of(context).canvasColor,
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 15),
          alignment: Alignment.centerLeft,
          child: AutoSizeText(
            L10n.of(context).meida_page_more_from_uploader,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      if (_controller.moreFromUser.isNotEmpty)
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _controller.moreFromUser.length,
          itemBuilder: (BuildContext context, int index) => SizedBox(
            height: 100,
            child: MediaFlatPreview(
              media: _controller.moreFromUser[index],
              beforeNavigation: () {
                _controller.pauseVideo();
              },
            ),
          ),
        ),
      if (_controller.moreLikeThis.isNotEmpty)
        Container(
          color: Theme.of(context).canvasColor,
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 15),
          alignment: Alignment.centerLeft,
          child: AutoSizeText(
            L10n.of(context).meida_page_more_like_this,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      if (_controller.moreLikeThis.isNotEmpty)
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _controller.moreLikeThis.length,
          itemBuilder: (BuildContext context, int index) => SizedBox(
            height: 100,
            child: MediaFlatPreview(
              media: _controller.moreLikeThis[index],
              beforeNavigation: () {
                _controller.pauseVideo();
              },
            ),
          ),
        ),
    ];
  }

  Widget _buildDetailTab() {
    return Obx(() {
      List<Widget> children = [_buildMediaDetail()];

      if (_controller.isFectchingRecommendation) {
        children.add(const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 50),
            child: IwrProgressIndicator(),
          ),
        ));
      } else {
        if (_controller.errorMessageRecommendation != "") {
          children.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          _controller.errorMessageRecommendation = "";
                          _controller.isFectchingRecommendation = true;
                          _controller.refectchRecommendation();
                        },
                        child: Center(
                          child: FaIcon(
                            FontAwesomeIcons.arrowRotateLeft,
                            color: Theme.of(context).primaryColor,
                            size: 42,
                          ),
                        )),
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Text(
                        _controller.errorMessageRecommendation,
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else if (_controller.moreFromUser.isEmpty &&
            _controller.moreLikeThis.isEmpty) {
          children.add(
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 50),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.boxArchive,
                  color: Colors.grey,
                  size: 42,
                ),
              ),
            ),
          );
        } else {
          children.addAll(_buildRecommendation());
        }
      }

      return CupertinoScrollbar(
        controller: _detailController,
        child: ListView(
          controller: _detailController,
          children: children,
        ),
      );
    });
  }

  Widget _buildCommentsTab() {
    return Column(
      children: [
        Expanded(
          child: CupertinoScrollbar(
            controller: _commentsController,
            child: CommentsList(
              uploaderUserName: _controller.media.user.username,
              sourceId: _controller.media.id,
              scrollController: _commentsController,
              sourceType: _controller.mediaType == MediaType.video
                  ? CommentsSourceType.video
                  : CommentsSourceType.image,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Get.bottomSheet(SendCommentBottomSheet(
              sourceId: _controller.media.id,
              sourceType: _controller.mediaType == MediaType.video
                  ? CommentsSourceType.video
                  : CommentsSourceType.image,
            ));
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(1000),
                ),
                child: AutoSizeText(
                  L10n.of(context).comments_send_comment,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _getTitle() {
    switch (_controller.mediaType) {
      case MediaType.video:
        return L10n.of(context).video;
      case MediaType.image:
        return L10n.of(context).image;
    }
  }

  @override
  Widget build(BuildContext context) {
    _controller.windowSize ??= MediaQuery.of(context).size;

    return Obx(() {
      if (_controller.isLoading) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const FaIcon(FontAwesomeIcons.chevronLeft),
            ),
            shape: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: 0,
              ),
            ),
            centerTitle: true,
            title: Text(_getTitle()),
          ),
          body: _buildLoadingWidget(),
        );
      } else {
        Widget body;
        detailWidget ??= DefaultTabController(
          length: 2,
          child: Column(children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildDetailTab(),
                  _buildCommentsTab(),
                ],
              ),
            ),
          ]),
        );

        mediaWidget ??= _controller.mediaType == MediaType.video
            ? _buildPlayer()
            : _buildGallery();

        body = OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              _controller.currentOrientation = orientation;
              _controller.resetPlayerAspectRatio();
              return Column(
                children: [
                  AspectRatio(aspectRatio: 16 / 9, child: mediaWidget),
                  Expanded(child: detailWidget!),
                ],
              );
            } else {
              _controller.currentOrientation = orientation;
              _controller.resetPlayerAspectRatio();
              return Row(
                children: [
                  Expanded(child: mediaWidget!),
                  SizedBox(
                    width: 300,
                    child: detailWidget,
                  )
                ],
              );
            }
          },
        );

        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: body,
          ),
        );
      }
    });
  }
}
