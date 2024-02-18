import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../../../components/iwr_refresh/widget.dart';
import '../post.dart';
import 'controller.dart';

class PostList extends StatefulWidget {
  final String tag;
  final String title;
  final String starterUserName;
  final String channelName;
  final String threadId;
  final ScrollController? scrollController;

  const PostList({
    Key? key,
    required this.tag,
    required this.title,
    required this.starterUserName,
    required this.channelName,
    required this.threadId,
    this.scrollController,
  }) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late PostListController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find(tag: widget.tag);
    _controller.initConfig(widget.channelName, widget.threadId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: IwrRefresh(
            controller: _controller,
            scrollController: widget.scrollController,
            paginated: true,
            builder: (data, scrollController) {
              return CustomScrollView(
                controller: scrollController,
                slivers: [
                  Obx(
                    () => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          int realIndex =
                              _controller.currentPage * _controller.pageSize +
                                  index;

                          Widget child = Post(
                            post: data[index],
                            index: realIndex,
                            showDivider: index != data.length - 1,
                            starterUserName: widget.starterUserName,
                            isMyComment: _controller.userService.user?.id ==
                                data[index].user.id,
                            onUpdated: (Map data) {
                              if (data["state"] == "delete") {
                                _controller.deleteComment(index);
                              } else if (data["state"] == "edit") {
                                _controller.updateContent(
                                    index, data["content"]);
                              }
                            },
                          );

                          if (realIndex == 0) {
                            child = Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    16,
                                    16,
                                    16,
                                  ),
                                  child: Text(
                                    widget.title,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                ),
                                child,
                              ],
                            );
                          }

                          return child;
                        },
                        childCount: data.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
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
}
