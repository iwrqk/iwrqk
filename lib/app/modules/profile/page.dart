import 'package:auto_size_text/auto_size_text.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../l10n.dart';
import '../../core/utils/display_util.dart';
import '../../data/enums/types.dart';
import '../../data/models/settings/media_sort_setting.dart';
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
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        _buildAvatarButton(context),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            color: Theme.of(context).canvasColor,
            child: Column(
              children: [
                _buildUploadName(),
                _buildDescription(context),
                _buildJoinSeenAtDate(context)
              ],
            ))
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
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SelectableText(
              "@${controller.profile.user!.username}",
              maxLines: 1,
              style: TextStyle(
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
      padding: EdgeInsets.only(top: 5),
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
              style: TextStyle(fontSize: 12.5, overflow: TextOverflow.ellipsis),
            ),
          ),
          FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 17.5,
          ),
        ]),
      ),
    );
  }

  Widget _buildJoinSeenAtDate(BuildContext context) {
    Widget? lastActiveWidget;

    if (controller.profile.seenAt != null) {
      Duration difference =
          DateTime.now().difference(DateTime.parse(controller.profile.seenAt!));
      if (difference.inMinutes <= 5) {
        lastActiveWidget = Row(
          children: [
            Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            ),
            Text(L10n.of(context).profile_online)
          ],
        );
      } else {
        lastActiveWidget = AutoSizeText(
          "${L10n.of(context).profile_last_active_time}：${DisplayUtil.getDisplayDate(DateTime.parse(controller.profile.seenAt!))}",
          style: TextStyle(fontSize: 12.5),
        );
      }
    }

    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText(
            "${L10n.of(context).profile_join_date}：${DisplayUtil.getDisplayDate(DateTime.parse(controller.profile.createdAt))}",
            style: TextStyle(fontSize: 12.5),
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
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Theme.of(context).canvasColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, right: 25),
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
                          DisplayUtil.compactBigNumber(controller.followingNum),
                          style: TextStyle(fontSize: 12.5),
                        ),
                        Text(
                          L10n.of(context).following,
                          style: TextStyle(color: Colors.grey, fontSize: 12.5),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
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
                          DisplayUtil.compactBigNumber(controller.followersNum),
                          style: TextStyle(fontSize: 12.5),
                        ),
                        Text(
                          L10n.of(context).followers,
                          style: TextStyle(color: Colors.grey, fontSize: 12.5),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          minimumSize: Size.fromHeight(0),
                        ),
                        filledStyle: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          minimumSize: Size.fromHeight(0),
                        ),
                        labelBuilder: (title) => AutoSizeText(
                          title,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: FriendButtonWidget(
                        user: controller.profile.user!,
                        outlineStyle: OutlinedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          minimumSize: Size.zero,
                        ),
                        filledStyle: ElevatedButton.styleFrom(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          minimumSize: Size.zero,
                        ),
                        onlyIcon: true,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        minimumSize: Size.zero,
                      ),
                      onPressed: () {},
                      child: FaIcon(
                        FontAwesomeIcons.solidEnvelope,
                      ),
                    ),
                  ],
                )
            ],
          ))
        ],
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
            margin: EdgeInsets.all(20),
            child: Text(
              errorMessage,
              textAlign: TextAlign.left,
              style: TextStyle(color: Colors.grey),
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
          backgroundColor: Theme.of(context).canvasColor.withAlpha(
                ((1 - controller.hideAppbarFactor) * 255).toInt(),
              ),
          leading: Center(
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Obx(
                () => Container(
                  padding: EdgeInsets.all(10),
                  decoration: controller.hideAppbarFactor == 0
                      ? null
                      : BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withAlpha(
                            (255 * controller.hideAppbarFactor).toInt(),
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
                        .withAlpha(
                        255 - (255 * controller.hideAppbarFactor).toInt(),
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
                    backgroundColor: Theme.of(context).canvasColor,
                    foregroundColor: Colors.grey,
                    heroTag: 'jumpToTopBtn',
                    onPressed: controller.jumpToTop,
                    child: FaIcon(FontAwesomeIcons.arrowUp),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (controller.currentTabIndex == 2)
                    FloatingActionButton(
                      backgroundColor: Theme.of(context).canvasColor,
                      foregroundColor: Colors.grey,
                      heroTag: 'commentBtn',
                      onPressed: () {
                        Get.bottomSheet(
                          SendCommentBottomSheet(
                            sourceId: controller.profile.user!.id,
                            sourceType: CommentsSourceType.profile,
                          ),
                        );
                      },
                      child: FaIcon(FontAwesomeIcons.solidComment),
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
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverPersistentHeaderDelegate(
                child: _buildTabBar(context),
                height: kTextTabBarHeight,
              ),
            ),
          ],
          body: SizeCacheWidget(
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
              icon: FaIcon(
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
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
            ),
          ),
          centerTitle: true,
          title: Text(L10n.of(context).profile),
        ),
        body: Center(
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