import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../global_widgets/tab_indicator.dart';
import 'controller.dart';
import 'widgets/friend_requests_list/widget.dart';
import 'widgets/friends_preview_list/widget.dart';

class FriendsPage extends GetView<FriendsController> {
  const FriendsPage({Key? key}) : super(key: key);

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
      padding: MediaQuery.of(context).padding.copyWith(top: 0, bottom: 0),
      alignment: Alignment.centerLeft,
      child: TabBar(
        isScrollable: true,
        physics: const BouncingScrollPhysics(),
        indicator: TabIndicator(context),
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: [
          Tab(text: L10n.of(context).user_friends),
          Tab(text: L10n.of(context).friend_requests),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const FaIcon(FontAwesomeIcons.chevronLeft),
        ),
        centerTitle: true,
        title: Text(
          L10n.of(context).user_friends,
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
