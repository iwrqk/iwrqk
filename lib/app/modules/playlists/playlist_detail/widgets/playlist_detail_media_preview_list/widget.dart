import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';

import '../../../../../../l10n.dart';
import '../../../../../global_widgets/media_preview/media_flat_preview.dart';
import '../../../../../global_widgets/placeholders/media_flat_preview.dart';
import '../../../../../global_widgets/sliver_refresh/widget.dart';
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
    return SizeCacheWidget(
      child: SliverRefresh(
        controller: _controller,
        scrollController: _scrollController,
        builder: (data, reachBottomCallback) {
          return Obx(
            () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  reachBottomCallback(index);

                  final item = _controller.data[index];

                  Widget child;

                  if (widget.requireMyself) {
                    child = Slidable(
                      key: Key(item.id),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        extentRatio: 0.25,
                        children: [
                          SlidableAction(
                            flex: 1,
                            onPressed: (context) async {
                              await _controller.removeFromPlaylist(
                                L10n.of(context).message_deleted_item(
                                  item.title,
                                ),
                                index,
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: FontAwesomeIcons.trashCan,
                            label: L10n.of(context).delete,
                          ),
                        ],
                      ),
                      child: SizedBox(
                        height: 100,
                        child: MediaFlatPreview(
                          media: item,
                        ),
                      ),
                    );
                  } else {
                    child = SizedBox(
                      height: 100,
                      child: MediaFlatPreview(
                        media: item,
                      ),
                    );
                  }

                  return FrameSeparateWidget(
                    index: index,
                    placeHolder: const SizedBox(
                      height: 100,
                      child: MediaFlatPreviewPlaceholder(),
                    ),
                    child: child,
                  );
                },
                childCount: data.length,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
