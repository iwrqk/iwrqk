import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../../../../data/models/conversations/conversation.dart';
import '../../../../../../global_widgets/sliver_refresh/widget.dart';
import '../conversation_preview.dart';
import 'controller.dart';

class ConversationsPreviewList extends StatefulWidget {
  final String userId;

  const ConversationsPreviewList({
    super.key,
    required this.userId,
  });

  @override
  State<ConversationsPreviewList> createState() =>
      _ConversationsPreviewListState();
}

class _ConversationsPreviewListState extends State<ConversationsPreviewList>
    with AutomaticKeepAliveClientMixin {
  late ConversationsPreviewListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<ConversationsPreviewListController>();
    _controller.initConfig(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverRefresh(
      controller: _controller,
      scrollController: _scrollController,
      builder: (data, reachBottomCallback) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              reachBottomCallback(index);

              ConversationModel conversation = _controller.data[index];

              Widget child = SizedBox(
                height: 75,
                child: ConversationPreview(
                  conversation: conversation,
                  userId: widget.userId,
                ),
              );

              return FrameSeparateWidget(
                index: index,
                placeHolder: Container(
                  height: 75,
                  color: Theme.of(context).canvasColor,
                ),
                child: child,
              );
            },
            childCount: _controller.data.length,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
