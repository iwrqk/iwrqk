import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:keframe/keframe.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../../../l10n.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../data/providers/storage_provider.dart';
import '../../../../../global_widgets/placeholders/media_flat_preview.dart';
import '../../../../../global_widgets/sliver_refresh/widget.dart';
import '../../controller.dart';
import '../history_media_preview.dart';
import 'controller.dart';

class HistoryMediaPreviewList extends StatefulWidget {
  final MediaType? filterType;
  final String tag;

  const HistoryMediaPreviewList(
      {super.key, this.filterType, required this.tag});

  @override
  State<HistoryMediaPreviewList> createState() =>
      _HistoryMediaPreviewListState();
}

class _HistoryMediaPreviewListState extends State<HistoryMediaPreviewList>
    with AutomaticKeepAliveClientMixin {
  final HistoryController _parentController = Get.find();
  late HistoryMediaPreviewListController _controller;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = Get.find<HistoryMediaPreviewListController>(tag: widget.tag);
    _parentController.childrenControllers[widget.tag] = _controller;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SliverRefresh(
      controller: _controller,
      scrollController: _scrollController,
      builder: (data, reachBottomCallback) {
        return Obx(
          () => SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                reachBottomCallback(index);

                final item = data[index];

                if (widget.filterType != null) {
                  if (widget.filterType != item.type) {
                    return FrameSeparateWidget(
                      index: index,
                      placeHolder: const SizedBox.shrink(),
                      child: const SizedBox.shrink(),
                    );
                  }
                }

                Widget child = Slidable(
                  key: Key(item.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        flex: 1,
                        onPressed: (context) {
                          data.removeAt(index);
                          StorageProvider.deleteHistoryItem(index);
                          showToast(
                            L10n.of(context).message_deleted_item(
                              item.title,
                            ),
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
                    child: HistoryMediaPreview(
                      media: item,
                      showType: widget.filterType == null,
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
