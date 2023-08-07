import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_player/better_player.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
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
import '../../global_widgets/media/iwr_gallery.dart';
import '../../global_widgets/media_preview/media_flat_preview.dart';
import '../../global_widgets/reloadable_image.dart';
import '../../global_widgets/tab_indicator.dart';
import '../../global_widgets/translated_content.dart';
import '../../global_widgets/user_preview/user_preview.dart';
import '../../routes/pages.dart';
import 'controller.dart';
import 'widgets/add_to_playlist_bottom_sheet/widget.dart';
import 'widgets/create_video_download_task_dialog/widget.dart';

class MediaDetailPage extends StatefulWidget {
  const MediaDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MediaDetailPage> createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends State<MediaDetailPage>
    with SingleTickerProviderStateMixin, RouteAware {
  final MediaDetailController _controller = Get.find();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    AppPages.routeObserver.subscribe(this, ModalRoute.of(context)!);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    AppPages.routeObserver.unsubscribe(this);
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didPushNext() {
    String nextRouteName = Get.currentRoute;
    if (nextRouteName != AppRoutes.mediaDetail && nextRouteName.isNotEmpty) {
      _controller.pauseVideo();
    }
    super.didPop();
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
                    L10n.of(context).media_private,
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

    return Obx(() {
      if (_controller.isFectchingResolution || _controller.fetchFailed) {
        child = Container(
          color: Colors.black,
          child: Obx(
            () => Center(
              child: !_controller.fetchFailed
                  ? const IwrProgressIndicator()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _controller.refectchVideo();
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
          ),
        );
      } else if ((_controller.media as VideoModel).embedUrl != null) {
        child = Container(
          color: Colors.black,
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
                  icon: const FaIcon(FontAwesomeIcons.solidShareFromSquare),
                  label: Text(L10n.of(context).open),
                ),
              ],
            ),
          ),
        );
      } else {
        child = BetterPlayer(
          key: _controller.iwrPlayerController!.widgetKey,
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
        controller: _tabController,
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
    return Card(
      color: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.5),
      ),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploaderWidget(),
            _buildMediaTitle(),
            _buildLikesAndViews(),
            _buildDescription(),
            _buildFunctionButtons()
          ],
        ),
      ),
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
            padding: const EdgeInsets.only(top: 5, left: 5),
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
        buttonPadding: EdgeInsets.zero,
        alignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(
            () => IconButton(
              onPressed: _controller.isProcessingFavorite
                  ? null
                  : () {
                      if (_controller.isFavorite) {
                        _controller.unfavoriteMedia();
                      } else {
                        _controller.favroiteMedia();
                      }
                    },
              icon: FaIcon(
                FontAwesomeIcons.solidHeart,
                size: 22.5,
                color: _controller.isFavorite ? Colors.redAccent : null,
              ),
            ),
          ),
          if (_controller.mediaType == MediaType.video)
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.list,
                size: 22.5,
              ),
              onPressed: () {
                Get.bottomSheet(
                  AddToPlaylistBottomSheet(
                    videoId: _controller.media.id,
                  ),
                );
              },
            ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.download,
              size: 22.5,
            ),
            onPressed: () {
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
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.language,
              size: 22.5,
            ),
            onPressed: () {
              if ((_controller.media.body ?? "").isNotEmpty) {
                _controller.getTranslatedContent();
              }
            },
          ),
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.solidShareFromSquare,
              size: 22.5,
            ),
            onPressed: () {
              if (_controller.mediaType == MediaType.video) {
                Share.share(IwaraConst.videoPageUrl
                    .replaceAll("{id}", _controller.media.id));
              } else {
                Share.share(IwaraConst.imagePageUrl
                    .replaceAll("{id}", _controller.media.id));
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRecommendation() {
    List<Widget> children = [];
    if (_controller.moreFromUser.isNotEmpty) {
      children.add(
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 5),
          alignment: Alignment.centerLeft,
          child: AutoSizeText(
            L10n.of(context).media_page_more_from_uploader,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      );
      children.addAll(
        _controller.moreFromUser.map(
          (e) => SizedBox(
            height: 100,
            child: MediaFlatPreview(
              media: e,
            ),
          ),
        ),
      );
    }
    if (_controller.moreLikeThis.isNotEmpty) {
      children.add(
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 5),
          alignment: Alignment.centerLeft,
          child: AutoSizeText(
            L10n.of(context).media_page_more_like_this,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      );
      children.addAll(
        _controller.moreLikeThis.map(
          (e) => SizedBox(
            height: 100,
            child: MediaFlatPreview(
              media: e,
            ),
          ),
        ),
      );
    }
    children.add(SizedBox(height: MediaQuery.of(context).padding.bottom));
    return children;
  }

  Widget _buildDetailTab() {
    return Obx(() {
      List<Widget> children = [
        SliverToBoxAdapter(
          child: _buildMediaDetail(),
        )
      ];

      if (_controller.isFectchingRecommendation) {
        children.add(
          const SliverFillRemaining(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 50),
                child: IwrProgressIndicator(),
              ),
            ),
          ),
        );
      } else {
        if (_controller.errorMessageRecommendation != "") {
          children.add(
            SliverFillRemaining(
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
            const SliverFillRemaining(
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
          children.add(SliverToBoxAdapter(
            child: Column(children: _buildRecommendation()),
          ));
        }
      }
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.symmetric(
            vertical:
                BorderSide(color: Theme.of(context).dividerColor, width: 0),
          ),
        ),
        child: CustomScrollView(
          primary: !_controller.lockingScroll,
          slivers: children,
        ),
      );
    });
  }

  Widget _buildCommentsTab() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor, width: 0),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Obx(
              () => Container(
                margin:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? MediaQuery.of(context)
                            .padding
                            .copyWith(left: 0, bottom: 0)
                        : null,
                child: CommentsList(
                  primary: !_controller.lockingScroll,
                  uploaderUserName: _controller.media.user.username,
                  sourceId: _controller.media.id,
                  sourceType: _controller.mediaType == MediaType.video
                      ? CommentsSourceType.video
                      : CommentsSourceType.image,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Get.bottomSheet(
                SendCommentBottomSheet(
                  sourceId: _controller.media.id,
                  sourceType: _controller.mediaType == MediaType.video
                      ? CommentsSourceType.video
                      : CommentsSourceType.image,
                ),
              );
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
                margin:
                    MediaQuery.of(context).padding.copyWith(left: 0, top: 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
      ),
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

        Widget detailTab = _buildDetailTab();
        Widget commentsTab = _buildCommentsTab();

        Widget mediaWidget = _controller.mediaType == MediaType.video
            ? _buildPlayer()
            : _buildGallery();

        body = Obx(
          () => SafeArea(
            left: false,
            bottom: false,
            right: false,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: false,
              appBar: _controller.hideAppbarFactor == 1
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(kTextTabBarHeight),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const FaIcon(
                                FontAwesomeIcons.chevronLeft,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : AppBar(
                      elevation: 0,
                      backgroundColor:
                          Theme.of(context).canvasColor.withOpacity(
                                1 - _controller.hideAppbarFactor,
                              ),
                      leading: Obx(
                        () => IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.chevronLeft,
                            color: _controller.hideAppbarFactor == 0
                                ? null
                                : Colors.white,
                          ),
                        ),
                      ),
                      centerTitle: true,
                      title: Obx(
                        () => Text(
                          _getTitle(),
                          style: TextStyle(
                            color: _controller.hideAppbarFactor == 0
                                ? null
                                : (Theme.of(context).brightness ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white)
                                    .withOpacity(
                                    1 - _controller.hideAppbarFactor,
                                  ),
                          ),
                        ),
                      ),
                    ),
              body: ExtendedNestedScrollView(
                controller: _controller.scrollController,
                onlyOneScrollInBody: true,
                pinnedHeaderSliverHeightBuilder: () =>
                    (MediaQuery.of(context).orientation == Orientation.landscape
                        ? 0
                        : kTextTabBarHeight) +
                    kTextTabBarHeight,
                headerSliverBuilder: (context, innerBoxIsScrolled) => [
                  SliverToBoxAdapter(
                    child: SafeArea(
                      top: false,
                      bottom: false,
                      right: false,
                      child:
                          AspectRatio(aspectRatio: 16 / 9, child: mediaWidget),
                    ),
                  ),
                  if (MediaQuery.of(context).orientation ==
                      Orientation.portrait)
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverPersistentHeaderDelegate(
                        child: _buildTabBar(),
                        height: kTextTabBarHeight,
                      ),
                    ),
                ],
                body: MediaQuery.of(context).orientation == Orientation.portrait
                    ? TabBarView(
                        controller: _tabController,
                        children: [
                          detailTab,
                          commentsTab,
                        ],
                      )
                    : SafeArea(
                        top: false,
                        bottom: false,
                        right: false,
                        child: detailTab,
                      ),
              ),
            ),
          ),
        );

        return Material(
          color: Theme.of(context).canvasColor,
          child: Row(
            children: [
              Expanded(child: body),
              if (MediaQuery.of(context).orientation == Orientation.landscape)
                SizedBox(
                  width: MediaQuery.of(context).size.longestSide / 3 +
                      MediaQuery.of(context).padding.right,
                  child: commentsTab,
                ),
            ],
          ),
        );
      }
    });
  }
}

class _SliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverPersistentHeaderDelegate({
    required this.child,
    required this.height,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant _SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
