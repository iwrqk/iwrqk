import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/enums/types.dart';
import '../../sliver_refresh/widget.dart';
import '../user_comment.dart';
import 'controller.dart';

class CommentsList extends StatefulWidget {
  final CommentsSourceType sourceType;
  final String sourceId;
  final String uploaderUserName;
  final String? parentId;
  final bool showReplies;
  final bool canJumpToDetail;
  final ScrollController? scrollController;

  const CommentsList({
    Key? key,
    required this.sourceType,
    required this.sourceId,
    required this.uploaderUserName,
    this.parentId,
    this.showReplies = true,
    this.canJumpToDetail = true,
    this.scrollController,
  }) : super(key: key);

  @override
  State<CommentsList> createState() => _CommentsListState();
}

class _CommentsListState extends State<CommentsList>
    with AutomaticKeepAliveClientMixin {
  final CommentsListController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.initConfig(widget.sourceId, widget.sourceType, widget.parentId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverRefresh(
      controller: _controller,
      scrollController: widget.scrollController,
      builder: (data, reachBottomCallback) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              reachBottomCallback(index);
              return UserComment(
                comment: data[index],
                uploaderUserName: widget.uploaderUserName,
                sourceId: widget.sourceId,
                sourceType: widget.sourceType,
                showReplies: widget.showReplies,
                canJumpToDetail: widget.canJumpToDetail,
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
