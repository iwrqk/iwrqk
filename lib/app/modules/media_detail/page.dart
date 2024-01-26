import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:share_plus/share_plus.dart';

import '../../../i18n/strings.g.dart';
import '../../components/buttons/follow_button/widget.dart';
import '../../components/comments_list/widget.dart';
import '../../components/load_empty.dart';
import '../../components/load_fail.dart';
import '../../components/media_preview/media_flat_preview.dart';
import '../../components/network_image.dart';
import '../../components/send_comment_bottom_sheet/widget.dart';
import '../../const/iwara.dart';
import '../../data/enums/types.dart';
import '../../data/models/media/image.dart';
import '../../data/models/media/video.dart';
import '../../routes/pages.dart';
import '../../utils/display_util.dart';
import 'controller.dart';
import 'widgets/create_video_download_task/widget.dart';
import 'widgets/gallery/iwr_gallery.dart';
import 'widgets/add_to_playlist/widget.dart';
import 'widgets/media_desc.dart';

class MediaDetailPage extends StatefulWidget {
  const MediaDetailPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MediaDetailPage> createState() => _MediaDetailPageState();
}

class _MediaDetailPageState extends State<MediaDetailPage>
    with TickerProviderStateMixin {
  final MediaDetailController _controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  Widget _buildLoadingWidget() {
    String errorMessage = _controller.errorMessage;
    if (errorMessage == "") {
      return const Center(
        child: CircularProgressIndicator(),
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
                    child: Icon(
                      Icons.lock,
                      size: 42,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    t.media.private,
                    style: const TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: LoadFail(
          errorMessage: _controller.errorMessage,
          onRefresh: () {
            _controller.errorMessage = "";
            _controller.isLoading = true;
            _controller.loadData();
          },
        ),
      );
    }
  }

  Widget _buildFunctionButtons() {
    Widget buildButton(IconData iconData, String text, VoidCallback? onPressed,
        [bool active = false]) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: active
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.inverseSurface,
            backgroundColor: active
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.onInverseSurface,
          ),
          onPressed: onPressed,
          icon: Icon(iconData),
          label: Text(text),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Obx(
              () => buildButton(
                !_controller.isProcessingFavorite & _controller.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_outline,
                DisplayUtil.compactBigNumber(_controller.tempFavorite
                    ? _controller.media.numLikes + 1
                    : _controller.media.numLikes),
                _controller.isProcessingFavorite
                    ? null
                    : () {
                        if (_controller.isFavorite) {
                          _controller.unfavoriteMedia();
                        } else {
                          _controller.favroiteMedia();
                        }
                      },
                !_controller.isProcessingFavorite & _controller.isFavorite,
              ),
            ),
            if (_controller.mediaType == MediaType.video)
              buildButton(
                Icons.playlist_add,
                t.media.add_to_playlist,
                () {
                  Get.bottomSheet(
                    AddToPlaylistBottomSheet(
                      videoId: _controller.media.id,
                    ),
                    isScrollControlled: true,
                    enableDrag: true,
                  );
                },
              ),
            buildButton(
              Icons.file_download,
              t.media.download,
              () {
                if (_controller.mediaType == MediaType.video) {
                  if (_controller.resolutions.isEmpty) {
                    SmartDialog.showToast(t.error.fetch_failed);
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
            buildButton(
              Icons.share,
              t.media.share,
              () {
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
      ),
    );
  }

  Widget _buildMediaDetail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          child: InkWell(
            onTap: () {
              Get.bottomSheet(
                MeidaDescription(media: _controller.media),
                isScrollControlled: true,
                enableDrag: true,
                barrierColor: Colors.transparent,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      _controller.media.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    width: double.infinity,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: Icon(
                                Icons.remove_red_eye,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: DisplayUtil.compactBigNumber(
                                _controller.media.numViews),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const WidgetSpan(
                            child: SizedBox(width: 16),
                          ),
                          TextSpan(
                            text: DisplayUtil.getDisplayTime(
                              DateTime.parse(_controller.media.createdAt),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
        _buildFunctionButtons(),
        ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          leading: GestureDetector(
            onTap: gotoProfile,
            child: ClipOval(
              clipBehavior: Clip.antiAlias,
              child: NetworkImg(
                imageUrl: _controller.media.user.avatarUrl,
                width: 40,
                height: 40,
              ),
            ),
          ),
          subtitle: GestureDetector(
            onTap: gotoProfile,
            child: Text(
              '@${_controller.media.user.username}',
              style: const TextStyle(
                fontSize: 12.5,
                color: Colors.grey,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ),
          title: GestureDetector(
            onTap: gotoProfile,
            child: Text(
              _controller.media.user.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          trailing: FollowButton(
            user: _controller.media.user,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void gotoProfile() {
    HapticFeedback.lightImpact();
    Get.toNamed(
      AppRoutes.profile,
      arguments: _controller.media.user.username,
      preventDuplicates: true,
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
            t.media.more_from(username: _controller.media.user.name),
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      );
      children.addAll(
        _controller.moreFromUser.map(
          (e) => MediaFlatPreview(
            media: e,
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
            t.media.more_like_this,
            maxLines: 1,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      );
      children.addAll(
        _controller.moreLikeThis.map(
          (e) => MediaFlatPreview(
            media: e,
          ),
        ),
      );
    }
    children.add(SizedBox(height: MediaQuery.of(context).padding.bottom));
    return children;
  }

  Widget _buildCommentsTab() {
    return Stack(children: [
      CommentsList(
        uploaderUserName: _controller.media.user.username,
        sourceId: _controller.media.id,
        sourceType: _controller.mediaType == MediaType.video
            ? CommentsSourceType.video
            : CommentsSourceType.image,
      ),
      Positioned(
        bottom: MediaQuery.of(context).padding.bottom + 16,
        right: 14,
        child: FloatingActionButton(
          onPressed: () {
            Get.bottomSheet(
              SendCommentBottomSheet(
                sourceId: _controller.media.id,
                sourceType: _controller.mediaType == MediaType.video
                    ? CommentsSourceType.video
                    : CommentsSourceType.image,
              ),
            );
          },
          child: const Icon(Icons.reply),
        ),
      ),
    ]);
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
                padding: EdgeInsets.symmetric(vertical: 48),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      } else {
        if (_controller.errorMessageRecommendation != "") {
          children.add(
            SliverFillRemaining(
              child: Center(
                child: LoadFail(
                  errorMessage: _controller.errorMessageRecommendation,
                  onRefresh: () {
                    _controller.errorMessageRecommendation = "";
                    _controller.isFectchingRecommendation = true;
                    _controller.refectchRecommendation();
                  },
                ),
              ),
            ),
          );
        } else if (_controller.moreFromUser.isEmpty &&
            _controller.moreLikeThis.isEmpty) {
          children.add(
            const SliverFillRemaining(
              child: Center(child: LoadEmpty()),
            ),
          );
        } else {
          children.add(SliverToBoxAdapter(
            child: Material(
              child: Column(
                children: _buildRecommendation(),
              ),
            ),
          ));
        }
      }
      return CustomScrollView(
        slivers: children,
      );
    });
  }

  Widget _buildPlayer() {
    return Obx(() {
      Widget child;

      if (_controller.isFectchingResolution || _controller.fetchFailed) {
        child = Container(
          color: Colors.black,
          child: Obx(
            () => Center(
              child: !_controller.fetchFailed
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            _controller.refectchVideo();
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: Theme.of(context).primaryColor,
                            size: 42,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            t.error.fetch_failed,
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
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info,
                      color: Colors.white,
                    ),
                    Text(
                      t.media.external_video,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                FilledButton.icon(
                  onPressed: () {
                    launchUrlString(
                        (_controller.media as VideoModel).embedUrl!);
                  },
                  label: Text(
                    t.common.open,
                    style: const TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.open_in_browser,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        child = Container(
          color: Colors.black,
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_controller.isLoading) {
        return Scaffold(
          appBar: AppBar(),
          body: _buildLoadingWidget(),
        );
      } else {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.black,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
          ),
          body: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _controller.mediaType == MediaType.video
                    ? _buildPlayer()
                    : _buildGallery(),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: DefaultTabController(
                    length: 2,
                    child: TabBarView(
                      children: [_buildDetailTab(), _buildCommentsTab()],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
