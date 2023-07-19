import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../../../l10n.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../global_widgets/media_preview/media_flat_preview.dart';
import '../../../../../global_widgets/placeholders/media_flat_preview.dart';
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

                  final item = data[index];

                  Widget child = Slidable(
                    key: Key(item.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          flex: 1,
                          onPressed: (context) async {
                            await _controller.unfavorite(index).then((value) {
                              if (value) {
                                showToast(L10n.of(context)
                                    .message_unfavorite_item(item.title));
                              }
                            });
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: FontAwesomeIcons.heartCrack,
                          label: L10n.of(context).unfavorite,
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
