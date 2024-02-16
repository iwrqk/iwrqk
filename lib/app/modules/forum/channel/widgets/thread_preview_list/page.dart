import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/iwr_refresh/widget.dart';
import '../../../../../components/network_image.dart';
import '../../../../../data/models/forum/thread.dart';
import '../../../../../utils/display_util.dart';
import 'controller.dart';

class ThreadPreviewList extends StatefulWidget {
  final String channelName;
  final ScrollController? scrollController;

  const ThreadPreviewList(
      {super.key, required this.channelName, this.scrollController});

  @override
  State<ThreadPreviewList> createState() => _ThreadPreviewListState();
}

class _ThreadPreviewListState extends State<ThreadPreviewList> {
  late ThreadPreviewListController _controller;

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
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          Get.toNamed("/thread?channelName=$channelName&threadId=${thread.id}",
              arguments: {
                'threadModel': thread,
              });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ClipOval(
                  child: NetworkImg(
                    imageUrl: thread.user.avatarUrl,
                    width: 40,
                    height: 40,
                  ),
                ),
                title: Text(
                  thread.user.name,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  DisplayUtil.getDisplayDate(DateTime.parse(
                      thread.lastPost?.createAt ?? thread.createdAt)),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text.rich(
                  TextSpan(
                    children: [
                      if (thread.sticky)
                        WidgetSpan(
                          child: Container(
                            padding: thread.sticky && thread.locked
                                ? const EdgeInsets.only(left: 6)
                                : const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.push_pin,
                              size: 17.5,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      if (thread.locked)
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.lock,
                              size: 17.5,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      TextSpan(
                        text: thread.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          size: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          DisplayUtil.compactBigNumber(thread.numViews),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.comment,
                          size: 15,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          DisplayUtil.compactBigNumber(thread.numPosts),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
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
    return IwrRefresh(
      controller: _controller,
      scrollController: widget.scrollController,
      builder: (data, scrollController) {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            Obx(
              () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final thread = data[index];
                    return _buildThreadPreview(
                      channelName: widget.channelName,
                      thread: thread,
                    );
                  },
                  childCount: data.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
