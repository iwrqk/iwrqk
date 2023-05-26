import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../../../l10n.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../global_widgets/media_preview/media_flat_preview.dart';
import '../../../../../global_widgets/sliver_refresh/widget.dart';
import '../../controller.dart';
import 'controller.dart';

class FavoriteMediaPreviewList extends StatefulWidget {
  final MediaType mediaType;
  final String tag;

  const FavoriteMediaPreviewList(
      {super.key, required this.mediaType, required this.tag});

  @override
  State<FavoriteMediaPreviewList> createState() =>
      _FavoriteMediaPreviewListState();
}

class _FavoriteMediaPreviewListState extends State<FavoriteMediaPreviewList>
    with AutomaticKeepAliveClientMixin {
  final FavoritesController _parentController = Get.find();
  late FavoriteMediaPreviewListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<FavoriteMediaPreviewListController>(tag: widget.tag);
    _controller.initConfig(widget.mediaType);
    _parentController.childrenControllers[widget.tag] = _controller;
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

              final item = data[index];

              Widget child = Dismissible(
                key: Key(item.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  showToast(
                    L10n.of(context).message_deleted_item(item.title),
                  );
                  _controller.unfavorite(index);
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
                    media: item,
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
