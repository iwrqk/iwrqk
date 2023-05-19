import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../../data/enums/types.dart';
import '../../../global_widgets/tab_indicator.dart';
import 'controller.dart';
import 'widgets/downloads_media_preview_list/widget.dart';

class DownloadsPage extends GetView<DownloadsController> {
  const DownloadsPage({super.key});

  Widget _buildTabBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      alignment: Alignment.centerLeft,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        TabBar(
          isScrollable: true,
          physics: const BouncingScrollPhysics(),
          indicator: TabIndicator(context),
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(text: L10n.of(context).videos),
            Tab(text: L10n.of(context).images)
          ],
        ),
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.solidTrashCan,
            size: 20,
          ),
          color: Colors.grey,
          onPressed: () {
            Get.dialog(
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Theme.of(context).canvasColor,
                title: Text(
                  L10n.of(context).confirm,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content:
                    Text(L10n.of(context).message_history_delete_all_confirm),
                contentPadding: EdgeInsets.fromLTRB(30, 15, 30, 0),
                actionsAlignment: MainAxisAlignment.end,
                actionsPadding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                actions: [
                  CupertinoButton(
                    onPressed: () async {
                      await controller.cleanDownloadVideoRecords();
                      Get.back();
                    },
                    child: Text(
                      L10n.of(context).apply,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
          ),
        ),
        centerTitle: true,
        title: Text(
          L10n.of(context).user_downloads,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildTabBar(context),
            Expanded(
              child: TabBarView(
                children: [
                  DownloadsMediaPreviewList(
                    filterType: MediaType.video,
                    tag: controller.childrenControllerTags[0],
                  ),
                  DownloadsMediaPreviewList(
                    filterType: MediaType.image,
                    tag: controller.childrenControllerTags[1],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
