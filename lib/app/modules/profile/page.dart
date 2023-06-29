import 'package:auto_size_text/auto_size_text.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../l10n.dart';
import '../../core/utils/display_util.dart';
import '../../data/enums/types.dart';
import '../../data/models/account/settings/media_sort_setting.dart';
import '../../global_widgets/comments/comments_list/widget.dart';
import '../../global_widgets/comments/send_comment_bottom_sheet/widget.dart';
import '../../global_widgets/buttons/follow_button/widget.dart';
import '../../global_widgets/buttons/friend_button/widget.dart';
import '../../global_widgets/iwr_progress_indicator.dart';
import '../../global_widgets/media_preview/media_preview_grid/controller.dart';
import '../../global_widgets/media_preview/media_preview_grid/widget.dart';
import '../../global_widgets/reloadable_image.dart';
import '../../global_widgets/tab_indicator.dart';
import '../../routes/pages.dart';
import 'controller.dart';
import 'profile_detail/page.dart';

class ProfilePage extends GetWidget<ProfileController> {
  const ProfilePage({super.key});

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        _buildAvatarButton(context),
        Container(
          color: Theme.of(context).canvasColor,
          child: SafeArea(
            top: false,
            bottom: false,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  _buildUploadName(),
                  _buildDescription(context),
                  _buildJoinSeenAtDate(context)
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              controller.profile.user!.name,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SelectableText(
              "@${controller.profile.user!.username}",
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12.5,
                color: Colors.grey,
              ),
            ),
          ],
        )),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: GestureDetector(
        excludeFromSemantics: true,
        onTap: () {
          Get.to(
            () => ProfileDetailPage(
              profile: controller.profile,
            ),
          );
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
            child: Text(
              controller.profile.body.isEmpty
                  ? L10n.of(context).profile_no_description
                  : controller.profile.body,
              maxLines: 1,
              style: const TextStyle(
                  fontSize: 12.5, overflow: TextOverflow.ellipsis),
            ),
          ),
          const FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 17.5,
          ),
        ]),
      ),
    );
  }

  Widget _buildJoinSeenAtDate(BuildContext context) {
    Widget? lastActiveWidget;

    String? seenAt = controller.profile.user!.seenAt;

    if (seenAt != null) {
      Duration difference = DateTime.now().difference(DateTime.parse(seenAt));
      if (difference.inMinutes <= 5) {
        lastActiveWidget = Row(
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            ),
            Text(L10n.of(context).profile_online)
          ],
        );
      } else {
        lastActiveWidget = AutoSizeText(
          "${L10n.of(context).profile_last_active_time}：${DisplayUtil.getDisplayDate(DateTime.parse(seenAt))}",
          style: const TextStyle(fontSize: 12.5),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText(
            "${L10n.of(context).profile_join_date}：${DisplayUtil.getDisplayDate(DateTime.parse(controller.profile.user!.createdAt))}",
            style: const TextStyle(fontSize: 12.5),
          ),
          if (lastActiveWidget != null) lastActiveWidget
        ],
      ),
    );
  }

  Widget _buildAvatarButton(BuildContext context) {
    bool isMyself = controller.profile.user!.username ==
        controller.userService.user?.username;
    return Container(
      color: Theme.of(context).canvasColor,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 25),
                child: ClipOval(
                  child: ReloadableImage(
                    imageUrl: controller.profile.user!.avatarUrl,
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.followersFollowing,
                            arguments: {
                              "parentUser": controller.profile.user,
                              "sourceType": UsersSourceType.following,
                            },
                            preventDuplicates: false,
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              DisplayUtil.compactBigNumber(
                                  controller.followingNum),
                              style: const TextStyle(fontSize: 12.5),
                            ),
                            Text(
                              L10n.of(context).following,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12.5),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.followersFollowing,
                            arguments: {
                              "parentUser": controller.profile.user,
                              "sourceType": UsersSourceType.followers,
                            },
                            preventDuplicates: false,
                          );
                        },
                        child: Column(
                          children: [
                            Text(
                              DisplayUtil.compactBigNumber(
                                  controller.followersNum),
                              style: const TextStyle(fontSize: 12.5),
                            ),
                            Text(
                              L10n.of(context).followers,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12.5),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  if (!isMyself)
                    Row(
                      children: [
                        Flexible(
                          child: FollowButton(
                            user: controller.profile.user!,
                            outlineStyle: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              minimumSize: const Size.fromHeight(0),
                            ),
                            filledStyle: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              minimumSize: const Size.fromHeight(0),
                            ),
                            labelBuilder: (title) => AutoSizeText(
                              title,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: FriendButtonWidget(
                            user: controller.profile.user!,
                            outlineStyle: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              minimumSize: Size.zero,
                            ),
                            filledStyle: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              minimumSize: Size.zero,
                            ),
                            onlyIcon: true,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () {},
                          child: const FaIcon(
                            FontAwesomeIcons.solidEnvelope,
                          ),
                        ),
                      ],
                    )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
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
      child: SafeArea(
        top: false,
        bottom: false,
        child: TabBar(
          isScrollable: true,
          indicator: TabIndicator(context),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(text: L10n.of(context).videos),
            Tab(
              text: L10n.of(context).images,
            ),
            Tab(
              text: L10n.of(context).comments,
            ),
          ],
          controller: controller.tabController,
        ),
      ),
    );
  }

  Widget _buildVideosTab() {
    String tag = "profile_page_${controller.userName}_videos";
    Get.lazyPut(() => MediaPreviewGridController(), tag: tag);
    return MediaPreviewGrid(
      tag: tag,
      sourceType: MediaSourceType.uploaderVideos,
      sortSetting: MediaSortSettingModel(
        orderType: OrderType.date,
        userId: controller.profile.user!.id,
      ),
    );
  }

  Widget _buildImagesTab() {
    String tag = "profile_page_${controller.userName}_images";
    Get.lazyPut(() => MediaPreviewGridController(), tag: tag);
    return MediaPreviewGrid(
      tag: tag,
      sourceType: MediaSourceType.uploaderImages,
      sortSetting: MediaSortSettingModel(
        orderType: OrderType.date,
        userId: controller.profile.user!.id,
      ),
    );
  }

  Widget _buildCommentsTab(BuildContext context) {
    return CommentsList(
      uploaderUserName: controller.profile.user!.username,
      sourceId: controller.profile.user!.id,
      sourceType: CommentsSourceType.profile,
    );
  }

  Widget _buildLoadFailWidget(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                controller.loadData();
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
              errorMessage,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDataWidget(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).canvasColor.withOpacity(
                1 - controller.hideAppbarFactor,
              ),
          leading: Center(
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.all(10),
                  decoration: controller.hideAppbarFactor == 0
                      ? null
                      : BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(
                            controller.hideAppbarFactor,
                          ),
                        ),
                  child: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    color:
                        controller.hideAppbarFactor == 0 ? null : Colors.white,
                  ),
                ),
              ),
            ),
          ),
          centerTitle: true,
          title: Obx(
            () => Text(
              L10n.of(context).profile,
              style: TextStyle(
                color: controller.hideAppbarFactor == 0
                    ? null
                    : (Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : Colors.white)
                        .withOpacity(
                        1 - controller.hideAppbarFactor,
                      ),
              ),
            ),
          ),
        ),
        floatingActionButton: controller.hideAppbarFactor == 0
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    heroTag: 'jumpToTopBtn',
                    onPressed: controller.jumpToTop,
                    child: const FaIcon(FontAwesomeIcons.arrowUp),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if (controller.currentTabIndex == 2)
                    FloatingActionButton(
                      heroTag: 'commentBtn',
                      onPressed: () {
                        Get.bottomSheet(
                          SendCommentBottomSheet(
                            sourceId: controller.profile.user!.id,
                            sourceType: CommentsSourceType.profile,
                          ),
                        );
                      },
                      child: const FaIcon(FontAwesomeIcons.solidComment),
                    )
                ],
              )
            : null,
        body: ExtendedNestedScrollView(
          controller: controller.scrollController,
          onlyOneScrollInBody: true,
          pinnedHeaderSliverHeightBuilder: () =>
              kTextTabBarHeight +
              kTextTabBarHeight +
              MediaQuery.of(context).padding.top,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(
              child: ReloadableImage(
                imageUrl: controller.profile.bannerUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverPersistentHeaderDelegate(
                child: _buildTabBar(context),
                height: kTextTabBarHeight,
              ),
            ),
          ],
          body: SafeArea(
            top: false,
            bottom: false,
            child: SizeCacheWidget(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildVideosTab(),
                  _buildImagesTab(),
                  _buildCommentsTab(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return controller.obx(
      (state) {
        return _buildDataWidget(context);
      },
      onError: (error) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const FaIcon(
                FontAwesomeIcons.chevronLeft,
              ),
            ),
            centerTitle: true,
            title: Text(L10n.of(context).profile),
          ),
          body: _buildLoadFailWidget(context, error!),
        );
      },
      onLoading: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const FaIcon(
              FontAwesomeIcons.chevronLeft,
            ),
          ),
          centerTitle: true,
          title: Text(L10n.of(context).profile),
        ),
        body: const Center(
          child: IwrProgressIndicator(),
        ),
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
