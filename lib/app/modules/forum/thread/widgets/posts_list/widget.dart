import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/display_util.dart';
import '../../../../../data/models/forum/post.dart';
import '../../../../../global_widgets/iwr_markdown.dart';
import '../../../../../global_widgets/reloadable_image.dart';
import '../../../../../global_widgets/sliver_refresh/widget.dart';
import '../../../../../routes/pages.dart';
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

  Widget _buildStarterBadge(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: const Text(
        "OP",
        style: TextStyle(color: Colors.white, fontSize: 12.5),
      ),
    );
  }

  Widget _buildStarter(String title, PostModel post) {
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
      padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.profile,
                arguments: post.user.username,
                preventDuplicates: false,
              );
            },
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipOval(
                child: ReloadableImage(
                  imageUrl: post.user.avatarUrl,
                  width: 45,
                  height: 45,
                ),
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    post.user.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (widget.starterUserName == post.user.username)
                    _buildStarterBadge(context)
                ],
              ),
              subtitle: Text(
                DisplayUtil.getDisplayTime(DateTime.parse(post.createAt)),
                style: const TextStyle(color: Colors.grey, fontSize: 12.5),
              ),
            ),
          ),
          Text(
            widget.title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IwrMarkdown(
            padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
            selectable: true,
            data: post.body,
          ),
        ],
      ),
    );
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

                if (index == 0) {
                  return _buildStarter(widget.title, data[index]);
                }

                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Post(
                    post: data[index],
                    index: index,
                    starterUserName: widget.starterUserName,
                  ),
                );
              },
              childCount: data.length,
            ),
          );
        },
      ),
    );
  }
}
