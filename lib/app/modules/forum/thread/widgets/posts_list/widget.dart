import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../global_widgets/sliver_refresh/widget.dart';
import '../post.dart';
import 'controller.dart';

class PostList extends StatefulWidget {
  final String title;
  final String starterUserName;
  final String channelName;
  final String threadId;

  const PostList({
    Key? key,
    required this.title,
    required this.starterUserName,
    required this.channelName,
    required this.threadId,
  }) : super(key: key);

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late PostListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.create(() => PostListController());
    _controller = Get.find();
    _controller.initConfig(widget.channelName, widget.threadId);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      controller: _scrollController,
      child: SliverRefresh(
        controller: _controller,
        scrollController: _scrollController,
        builder: (data, reachBottomCallback) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                reachBottomCallback(index);

                Widget child = Post(
                  post: data[index],
                  index: index,
                  starterUserName: widget.starterUserName,
                );

                if (index == 0) {
                  child = Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(
                          20,
                          15,
                          15,
                          5,
                        ),
                        child: Text(
                          widget.title,
                          style: Theme.of(context).textTheme.titleLarge,
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
          );
        },
      ),
    );
  }
}
