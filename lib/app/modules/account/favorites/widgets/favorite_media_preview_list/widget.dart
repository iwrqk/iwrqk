import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../components/iwr_refresh/widget.dart';
import '../../../../../components/media_preview/media_flat_preview.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../data/models/media/media.dart';
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

  Widget _buildFavoriteMediaPreview(MediaModel media) {
    return Obx(() {
      bool checked = _parentController.contains(media);

      return MediaFlatPreview(
        media: media,
        onTap: _parentController.enableMultipleSelection
            ? () {
                _parentController.toggleChecked(media);
                setState(() {});
              }
            : null,
        onLongPress: _parentController.enableMultipleSelection
            ? null
            : () {
                _parentController.enableMultipleSelection = true;
                _parentController.toggleChecked(media);
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
                    return _buildFavoriteMediaPreview(data[index]);
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
