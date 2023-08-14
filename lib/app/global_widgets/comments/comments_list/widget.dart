import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
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
  final bool? primary;
  final ScrollController? scrollController;
  final Widget? parentComment;

  const CommentsList({
    Key? key,
    required this.sourceType,
    required this.sourceId,
    required this.uploaderUserName,
    this.parentId,
    this.showReplies = true,
    this.canJumpToDetail = true,
    this.primary,
    this.scrollController,
    this.parentComment,
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
      primary: widget.primary,
      controller: _controller,
      scrollController: widget.scrollController,
      builder: (data, reachBottomCallback) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              reachBottomCallback(index);

              Widget comment = UserComment(
                comment: data[index],
                uploaderUserName: widget.uploaderUserName,
                sourceId: widget.sourceId,
                sourceType: widget.sourceType,
                showReplies: widget.showReplies,
                canJumpToDetail: widget.canJumpToDetail,
                isMyComment: _controller.userService.user?.id ==
                    data[index].user.id,
              );

              if (index == 0 && widget.parentComment != null) {
                return Column(
                  children: [
                    widget.parentComment!,
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 5),
                      alignment: Alignment.centerLeft,
                      child: AutoSizeText(
                        L10n.of(context).replies,
                        maxLines: 1,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    comment,
                  ],
                );
              }

              return comment;
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
