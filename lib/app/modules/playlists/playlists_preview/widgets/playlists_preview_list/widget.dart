import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../../../data/models/playlist/playlist.dart';
import '../../../../../global_widgets/placeholders/media_flat_preview.dart';
import '../../../../../global_widgets/sliver_refresh/widget.dart';
import '../playlist_preview.dart';
import 'controller.dart';

class PlaylistsPreviewList extends StatefulWidget {
  final String userId;
  final bool? requireMyself;
  final String tag;

  const PlaylistsPreviewList({
    super.key,
    required this.userId,
    this.requireMyself,
    required this.tag,
  });

  @override
  State<PlaylistsPreviewList> createState() => _PlaylistsPreviewListState();
}

class _PlaylistsPreviewListState extends State<PlaylistsPreviewList>
    with AutomaticKeepAliveClientMixin {
  late PlaylistsPreviewListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<PlaylistsPreviewListController>(tag: widget.tag);
    _controller.initConfig(widget.userId, widget.requireMyself ?? false);
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

              PlaylistModel playlist = _controller.data[index];
              /*
                  Widget child = Dismissible(
                    key: Key(item.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      showToast(
                        L10n.of(context).message_deleted_item.replaceFirst(
                              "\$s",
                              item.title,
                            ),
                      );
                      _controller.deletePlaylist(index);
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
                      child: PlaylistPreview(
                        playlistId: item.id,
                        title: item.title,
                        videosCount: item.total,
                      ),
                    ),
                  );
                  */

              Widget child = SizedBox(
                height: 100,
                child: PlaylistPreview(
                  playlistId: playlist.id,
                  title: playlist.title,
                  videosCount: playlist.numVideos,
                ),
              );

              return FrameSeparateWidget(
                index: index,
                placeHolder: const SizedBox(
                  height: 100,
                  child: MediaFlatPreviewPlaceholder(),
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
