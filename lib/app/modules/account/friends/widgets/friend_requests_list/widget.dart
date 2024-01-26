import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/iwr_refresh/widget.dart';
import '../../../../../components/user_preview/user_preview.dart';
import '../../controller.dart';
import '../friend_accept_reject_buttons/widget.dart';
import 'controller.dart';

class FriendRequestsList extends StatefulWidget {
  final String tag;
  final String userId;

  const FriendRequestsList({
    super.key,
    required this.tag,
    required this.userId,
  });

  @override
  State<FriendRequestsList> createState() => _FriendRequestsListState();
}

class _FriendRequestsListState extends State<FriendRequestsList>
    with AutomaticKeepAliveClientMixin {
  final FriendsController _parentController = Get.find();
  late FriendRequestsListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<FriendRequestsListController>(tag: widget.tag);
    _controller.initConfig(widget.userId);
    _parentController.friendRequestsListController = _controller;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return IwrRefresh(
      controller: _controller,
      scrollController: _scrollController,
      builder: (data, scrollController) {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = data[index];

                  return UserPreview(
                    user: item.user,
                    showFollowButton: false,
                    showFriendButton: false,
                    customButton: FriendAcceptRejectButtons(
                      user: item.user,
                    ),
                  );
                },
                childCount: data.length,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
