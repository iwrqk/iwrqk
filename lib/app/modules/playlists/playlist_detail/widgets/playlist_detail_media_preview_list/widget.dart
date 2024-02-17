import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/iwr_refresh/widget.dart';
import '../../../../../components/media_preview/media_flat_preview.dart';
import '../../../../../data/models/media/media.dart';
import '../../controller.dart';
import 'controller.dart';

class PlaylistDetailMediaPreviewList extends StatefulWidget {
  final String tag;
  final PlaylistDetailController parentController;
  final String playlistId;
  final bool requireMyself;

  const PlaylistDetailMediaPreviewList({
    super.key,
    required this.tag,
    required this.parentController,
    required this.playlistId,
    required this.requireMyself,
  });

  @override
  State<PlaylistDetailMediaPreviewList> createState() =>
      _PlaylistDetailMediaPreviewListState();
}

class _PlaylistDetailMediaPreviewListState
    extends State<PlaylistDetailMediaPreviewList>
    with AutomaticKeepAliveClientMixin {
  late PlaylistDetailController _parentController;
  late PlaylistDetailMediaPreviewListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _parentController = widget.parentController;
    _controller = Get.find(tag: widget.tag);
    _controller.initConfig(widget.playlistId, _parentController);
    _parentController.childController = _controller;
  }

  Widget _buildPlaylistMediaPreview(MediaModel media) {
    return Obx(() {
      bool checked = _parentController.checkedList.contains(media.id);

      return MediaFlatPreview(
        media: media,
        onTap: _parentController.enableMultipleSelection
            ? () {
                _parentController.toggleChecked(media.id);
                setState(() {});
              }
            : null,
        onLongPress: _parentController.enableMultipleSelection
            ? null
            : () {
                _parentController.enableMultipleSelection = true;
                _parentController.toggleChecked(media.id);
                setState(() {});
              },
        coverOverlay: Positioned.fill(
          child: AnimatedOpacity(
            opacity: _parentController.enableMultipleSelection ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withOpacity(
                    _parentController.enableMultipleSelection && checked
                        ? 0.6
                        : 0),
              ),
              child: Center(
                child: SizedBox(
                  width: 34,
                  height: 34,
                  child: AnimatedScale(
                    scale: checked ? 1 : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: (Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(0.8),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
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
                    return _buildPlaylistMediaPreview(data[index]);
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
