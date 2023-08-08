import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../../../l10n.dart';
import '../../../global_widgets/iwr_progress_indicator.dart';
import 'controller.dart';
import 'widgets/add_tag_dialog/widget.dart';

class BlockedTagsPage extends GetView<BlockedTagsController> {
  const BlockedTagsPage({super.key});

  AlertDialog _buildConfirmDialog(BuildContext context,
      {required String title,
      required String content,
      required Function() onConfirm}) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Theme.of(context).canvasColor,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      contentPadding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      actions: [
        CupertinoButton(
          onPressed: onConfirm,
          child: Text(
            L10n.of(context).confirm,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFirstLoadFailWidget(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                controller.loadData();
              },
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.arrowRotateLeft,
                  color: Theme.of(context).primaryColor,
                  size: 42,
                ),
              )),
          Container(
            margin: const EdgeInsets.all(20),
            child: Text(
              errorMessage,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
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
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
          ),
        ),
        centerTitle: true,
        title: Text(
          L10n.of(context).user_blocked_tags,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.dialog(AddTagDialog(
                onConfirm: controller.onAddTag,
              ));
            },
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
          IconButton(
            onPressed: () {
              if (controller.whetherAddTag()) {
                Get.dialog(_buildConfirmDialog(
                  context,
                  title: L10n.of(context).confirm,
                  content: L10n.of(context).message_save_blocked_tags_confirm,
                  onConfirm: () {
                    controller
                        .save(L10n.of(context).message_blocked_tags_saved);
                  },
                ));
              } else {
                showToast(L10n.of(context).message_blocked_tags_reached_limit);
              }
            },
            icon: const FaIcon(
              FontAwesomeIcons.solidFloppyDisk,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: controller.obx(
          (state) => ListView.separated(
            itemCount: controller.blockedTags.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 1,
                thickness: 1,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              return Container(
                color: Theme.of(context).cardColor,
                child: ListTile(
                  onTap: () {
                    controller.unblockTag(index);
                  },
                  title: Text(controller.blockedTags[index].id),
                ),
              );
            },
          ),
          onLoading: const Center(
            child: IwrProgressIndicator(),
          ),
          onEmpty: const Center(
            child: FaIcon(
              FontAwesomeIcons.boxArchive,
              color: Colors.grey,
              size: 42,
            ),
          ),
          onError: (error) {
            return _buildFirstLoadFailWidget(context, error!);
          },
        ),
      ),
    );
  }
}
