import 'package:better_player/better_player.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../l10n.dart';
import '../../../../data/enums/types.dart';
import '../../../../global_widgets/iwr_progress_indicator.dart';
import '../../../../global_widgets/tab_indicator.dart';
import '../../../../routes/pages.dart';
import '../../downloads/widgets/downloads_media_preview_list/widget.dart';
import 'controller.dart';

class DownloadedVideoDetailPage extends StatefulWidget {
  const DownloadedVideoDetailPage({super.key});

  @override
  State<DownloadedVideoDetailPage> createState() =>
      _DownloadedVideoDetailPageState();
}

class _DownloadedVideoDetailPageState extends State<DownloadedVideoDetailPage>
    with SingleTickerProviderStateMixin {
  final DownloadedVideoDetailController _controller =
      Get.put(DownloadedVideoDetailController());
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void _gotoUploaderProfilePage() {
    _controller.pauseVideo();
    Get.toNamed(
      AppRoutes.profile,
      arguments: _controller.media.uploader.username,
      preventDuplicates: true,
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
            text: L10n.of(context).user_playlists,
          )
        ],
      ),
    );
  }

  Widget _buildDetailTab() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.symmetric(
          vertical: BorderSide(color: Theme.of(context).dividerColor, width: 0),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Card(
              color: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5),
              ),
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: GestureDetector(
                  onTap: _gotoUploaderProfilePage,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 5),
                        leading: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            _controller.media.uploader.name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _controller.media.uploader.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _controller.media.uploader.username,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12.5),
                            ),
                          ],
                        ),
                      ),
                      SelectableText(
                        _controller.media.title,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaylistTab() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          left: BorderSide(color: Theme.of(context).dividerColor, width: 0),
        ),
      ),
      margin: MediaQuery.of(context).orientation == Orientation.landscape
          ? MediaQuery.of(context).padding.copyWith(left: 0, bottom: 0)
          : null,
      child: Obx(
        () => DownloadsMediaPreviewList(
          filterType: MediaType.video,
          tag: _controller.taskPreviewListTag,
          isPlaylist: true,
          currentMediaId: _controller.currentMediaId,
          onChangeVideo: _controller.changeVideoSource,
        ),
      ),
    );
  }

  Widget _buildPlayer() {
    return BetterPlayer(
      controller: _controller.iwrPlayerController!.betterPlayerController,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    Widget detailTab = _buildDetailTab();
    Widget playlistTab = _buildPlaylistTab();

    Widget mediaWidget = Obx(() {
      if (_controller.loading) {
        return Container(
          color: Colors.black,
          child: const AspectRatio(
            aspectRatio: 16 / 9,
            child: Center(
              child: IwrProgressIndicator(),
            ),
          ),
        );
      } else {
        return _buildPlayer();
      }
    });

    body = Obx(
      () => SafeArea(
        left: false,
        bottom: false,
        right: false,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).canvasColor.withOpacity(
                  1 - _controller.hideAppbarFactor,
                ),
            leading: Obx(
              () => IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  color:
                      _controller.hideAppbarFactor == 0 ? null : Colors.white,
                ),
              ),
            ),
            centerTitle: true,
            title: Obx(
              () => Text(
                L10n.of(context).video,
                style: TextStyle(
                  color: _controller.hideAppbarFactor == 0
                      ? null
                      : (Theme.of(context).brightness == Brightness.light
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
                  child: AspectRatio(aspectRatio: 16 / 9, child: mediaWidget),
                ),
              ),
              if (MediaQuery.of(context).orientation == Orientation.portrait)
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
                      playlistTab,
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
              child: playlistTab,
            ),
        ],
      ),
    );
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
