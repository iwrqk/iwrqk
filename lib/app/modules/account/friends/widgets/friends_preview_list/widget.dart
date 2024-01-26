import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/iwr_refresh/widget.dart';
import '../../../../../components/user_preview/user_preview.dart';
import '../../controller.dart';
import 'controller.dart';

class FriendsPreviewList extends StatefulWidget {
  final String tag;
  final String userId;

  const FriendsPreviewList({
    super.key,
    required this.tag,
    required this.userId,
  });

  @override
  State<FriendsPreviewList> createState() => _FriendsPreviewListState();
}

class _FriendsPreviewListState extends State<FriendsPreviewList>
    with AutomaticKeepAliveClientMixin {
  final FriendsController _parentController = Get.find();
  late FriendsPreviewListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<FriendsPreviewListController>(tag: widget.tag);
    _controller.initConfig(widget.userId);
    _parentController.friendsPreviewListController = _controller;
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
                    user: item,
                    showFollowButton: false,
                    showFriendButton: true,
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
