import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/iwr_refresh/widget.dart';
import '../../../../../components/media_preview/media_flat_preview.dart';
import 'controller.dart';

class PlaylistDetailMediaPreviewList extends StatefulWidget {
  final String playlistId;
  final bool requireMyself;

  const PlaylistDetailMediaPreviewList(
      {super.key, required this.playlistId, required this.requireMyself});

  @override
  State<PlaylistDetailMediaPreviewList> createState() =>
      _PlaylistDetailMediaPreviewListState();
}

class _PlaylistDetailMediaPreviewListState
    extends State<PlaylistDetailMediaPreviewList>
    with AutomaticKeepAliveClientMixin {
  final PlatlistDetailMediaPreviewListController _controller = Get.find();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _controller.initConfig(widget.playlistId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return IwrRefresh(
      controller: _controller,
      scrollController: _scrollController,
      builder: (data, scrollController) {
        return CustomScrollView(
          controller: scrollController,
          slivers: [
            Obx(
              () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = _controller.data[index];
                    return MediaFlatPreview(
                      media: item,
                    );
                  },
                  childCount: data.length,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
