import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../components/load_fail.dart';
import '../../../components/network_image.dart';
import '../../../utils/display_util.dart';
import 'controller.dart';
import 'widgets/posts_list/widget.dart';
import 'widgets/send_post_bottom_sheet/widget.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage({super.key});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  final ThreadController _controller = Get.find();

  Widget _buildTitle() {
    return ListTile(
      leading: ClipOval(
        child: NetworkImg(
          imageUrl: _controller.thread.user.avatarUrl,
          width: 30,
          height: 30,
        ),
      ),
      title: Text(
        _controller.thread.user.name,
        style: const TextStyle(fontSize: 14),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        DisplayUtil.getDisplayTime(
            DateTime.parse(_controller.thread.createdAt)),
        style: const TextStyle(fontSize: 12),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDataWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Obx(
          () => AnimatedOpacity(
            opacity: _controller.showTitle ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: _buildTitle(),
          ),
        ),
        titleSpacing: 0,
      ),
      floatingActionButton: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 2),
          end: const Offset(0, 0),
        ).animate(CurvedAnimation(
          parent: _controller.fabAnimationController,
          curve: Curves.easeInOut,
        )),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 64),
          child: FloatingActionButton(
            onPressed: _controller.thread.locked
                ? null
                : () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SendPostBottomSheet(
                          threadId: _controller.thread.id,
                        ),
                      ),
                    );
                  },
            child: _controller.thread.locked
                ? const Icon(Icons.lock)
                : const Icon(Icons.reply),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PostList(
              title: _controller.thread.title,
              starterUserName: _controller.thread.user.name,
              channelName: _controller.channelName,
              threadId: _controller.thread.id,
              scrollController: _controller.scrollController,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.fromExternal) {
      return _controller.obx(
        (state) {
          return _buildDataWidget(context);
        },
        onError: (error) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: LoadFail(
                errorMessage: error!,
                onRefresh: () {
                  _controller.refreshData(showSplash: true);
                },
              ),
            ),
          );
        },
        onLoading: Scaffold(
          appBar: AppBar(),
          body: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return _buildDataWidget(context);
    }
  }
}
