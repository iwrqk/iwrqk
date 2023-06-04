import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../../../global_widgets/buttons/friend_accept_reject_buttons/widget.dart';
import '../../../../../global_widgets/sliver_refresh/widget.dart';
import '../../../../../global_widgets/user_preview/user_preview.dart';
import '../../controller.dart';
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
    return SliverRefresh(
      controller: _controller,
      scrollController: _scrollController,
      builder: (data, reachBottomCallback) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              reachBottomCallback(index);

              final item = data[index];

              Widget child = SizedBox(
                height: 100,
                child: UserPreview(
                  user: item.user,
                  showFollowButton: false,
                  showFriendButton: false,
                  customButton: FriendAcceptRejectButtons(
                    user: item.user,
                  ),
                ),
              );

              return FrameSeparateWidget(
                index: index,
                placeHolder: Container(
                  height: 100,
                  color: Theme.of(context).canvasColor,
                ),
                child: child,
              );
            },
            childCount: data.length,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
