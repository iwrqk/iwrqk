import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../data/enums/types.dart';
import '../iwr_refresh/widget.dart';
import '../user_comment.dart';
import 'controller.dart';

class CommentsList extends StatefulWidget {
  final CommentsSourceType sourceType;
  final String sourceId;
  final String uploaderUserName;
  final String? parentId;
  final bool showReplies;
  final bool canJumpToDetail;
  final bool paginated;
  final bool showBottomPagination;
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
    this.paginated = true,
    this.showBottomPagination = false,
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

    return Column(
      children: [
        if (widget.paginated && !widget.showBottomPagination)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                  width: 0,
                ),
              ),
            ),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.comment.replies_in_total(numReply: _controller.count),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _controller.currentPage + 1 == 1
                            ? null
                            : () {
                                _controller.previousPage();
                              },
                        icon: const Icon(Icons.chevron_left),
                      ),
                      PopupMenuButton<int>(
                        icon: Text(
                          _controller.totalPage == 0
                              ? "0 / 0"
                              : "${_controller.currentPage + 1} / ${_controller.totalPage}",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) => List.generate(
                          _controller.totalPage,
                          (index) => PopupMenuItem(
                            value: index,
                            child: Text("${index + 1}"),
                          ),
                        ),
                        onSelected: (value) {
                          _controller.setPage(value);
                        },
                      ),
                      IconButton(
                        onPressed:
                            _controller.currentPage + 1 == _controller.totalPage
                                ? null
                                : () {
                                    _controller.nextPage();
                                  },
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: IwrRefresh(
            controller: _controller,
            scrollController: widget.scrollController,
            paginated: widget.paginated,
            builder: (data, scrollController) {
              return Obx(
                () => CustomScrollView(
                  controller: scrollController,
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 16),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          Widget comment = UserComment(
                            comment: data[index],
                            uploaderUserName: widget.uploaderUserName,
                            sourceId: widget.sourceId,
                            sourceType: widget.sourceType,
                            showReplies: widget.showReplies,
                            showDivider: index != data.length - 1,
                            canJumpToDetail: widget.canJumpToDetail,
                            isMyComment: _controller.userService.user?.id ==
                                data[index].user.id,
                          );

                          if (index == 0 && widget.parentComment != null) {
                            return Column(
                              children: [
                                widget.parentComment!,
                                Container(
                                  height: 12,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  color: Theme.of(context)
                                      .dividerColor
                                      .withOpacity(0.1),
                                ),
                                comment,
                              ],
                            );
                          }

                          return comment;
                        },
                        childCount: data.length,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: MediaQuery.of(context).padding.bottom,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        if (widget.paginated && widget.showBottomPagination)
          BottomAppBar(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.comment.replies_in_total(numReply: _controller.count),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _controller.currentPage + 1 == 1
                            ? null
                            : () {
                                _controller.previousPage();
                              },
                        icon: const Icon(Icons.chevron_left),
                      ),
                      PopupMenuButton<int>(
                        icon: Text(
                          _controller.totalPage == 0
                              ? "0 / 0"
                              : "${_controller.currentPage + 1} / ${_controller.totalPage}",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        position: PopupMenuPosition.under,
                        itemBuilder: (context) => List.generate(
                          _controller.totalPage,
                          (index) => PopupMenuItem(
                            value: index,
                            child: Text("${index + 1}"),
                          ),
                        ),
                        onSelected: (value) {
                          _controller.setPage(value);
                        },
                      ),
                      IconButton(
                        onPressed:
                            _controller.currentPage + 1 == _controller.totalPage
                                ? null
                                : () {
                                    _controller.nextPage();
                                  },
                        icon: const Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
