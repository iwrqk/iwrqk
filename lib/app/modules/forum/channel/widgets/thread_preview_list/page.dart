import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/display_util.dart';
import '../../../../../data/models/forum/post.dart';
import '../../../../../data/models/forum/thread.dart';
import '../../../../../global_widgets/reloadable_image.dart';
import '../../../../../global_widgets/sliver_refresh/widget.dart';
import '../../../../../routes/pages.dart';
import 'controller.dart';

class ThreadPreviewList extends StatefulWidget {
  final String channelName;

  const ThreadPreviewList({super.key, required this.channelName});

  @override
  State<ThreadPreviewList> createState() => _ThreadPreviewListState();
}

class _ThreadPreviewListState extends State<ThreadPreviewList> {
  late ThreadPreviewListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.create(() => ThreadPreviewListController());
    _controller = Get.find<ThreadPreviewListController>();
    _controller.initConfig(widget.channelName);
  }

  Widget _buildThreadPreview({
    required String channelName,
    required ThreadModel thread,
  }) {
    return Card(
      color: Theme.of(context).canvasColor,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.thread, arguments: {
            'title': thread.title,
            'starterUserName': thread.user.username,
            'channelName': channelName,
            'threadId': thread.id,
          });
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipOval(
                  child: ReloadableImage(
                    imageUrl: thread.user.avatarUrl,
                    width: 40,
                    height: 40,
                  ),
                ),
                title: Text(
                  thread.user.name,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                subtitle: Text(
                  "@${thread.user.username}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  thread.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidEye,
                          size: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          DisplayUtil.compactBigNumber(thread.numViews),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.solidComment,
                          size: 15,
                          color: Theme.of(context).primaryColor,
                        ),
                        SizedBox(width: 5),
                        Text(
                          DisplayUtil.compactBigNumber(thread.numPosts),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
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

                return _buildThreadPreview(
                  thread: data[index],
                  channelName: widget.channelName,
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
