import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import 'controller.dart';
import 'widgets/friend_requests_list/widget.dart';
import 'widgets/friends_preview_list/widget.dart';

class FriendsPage extends GetView<FriendsController> {
  const FriendsPage({Key? key}) : super(key: key);

  Widget _buildTabBar(BuildContext context) {
    return Container(
      padding: MediaQuery.of(context).padding.copyWith(top: 0, bottom: 0),
      alignment: Alignment.centerLeft,
      child: TabBar(
        isScrollable: true,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.center,
        splashBorderRadius: BorderRadius.circular(8),
        tabs: [
          Tab(text: t.user.friends),
          Tab(text: t.friend.friend_requests),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.user.friends,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildTabBar(context),
            Expanded(
              child: SafeArea(
                top: false,
                bottom: false,
                child: TabBarView(
                  children: [
                    FriendsPreviewList(
                      userId: controller.userService.user!.id,
                      tag: controller.friendsPreviewListTag,
                    ),
                    FriendRequestsList(
                      userId: controller.userService.user!.id,
                      tag: controller.friendRequestsListTag,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
