import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../../../../l10n.dart';
import '../../../../../global_widgets/media_preview/media_flat_preview.dart';
import '../../../../../global_widgets/sliver_refresh/widget.dart';
import 'controller.dart';

class PlaylistDetailMediaPreviewList extends StatefulWidget {
  final String playlistId;

  const PlaylistDetailMediaPreviewList({super.key, required this.playlistId});

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
    return SliverRefresh(
      controller: _controller,
      scrollController: _scrollController,
      builder: (data, reachBottomCallback) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              reachBottomCallback(index);

              final item = _controller.data[index];

              Widget child = Dismissible(
                key: Key(item.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _controller.removeFromPlaylist(
                    L10n.of(context).message_deleted_item(
                      item.title,
                    ),
                    index,
                  );
                },
                background: Container(
                  color: Colors.red,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        L10n.of(context).delete,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                child: SizedBox(
                  height: 100,
                  child: MediaFlatPreview(
                    meida: item,
                  ),
                ),
              );

              return FrameSeparateWidget(
                index: index,
                placeHolder: Container(
                  height: 100,
                  color: Theme.of(context).canvasColor,
                ),
                child: child,
              );
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
