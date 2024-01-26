import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../components/load_empty.dart';
import '../../../components/load_fail.dart';
import 'controller.dart';
import 'add_tag/widget.dart';

class BlockedTagsPage extends GetView<BlockedTagsController> {
  const BlockedTagsPage({super.key});

  AlertDialog _buildConfirmDialog(BuildContext context,
      {required String title,
      required String content,
      required Function() onConfirm}) {
    return AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: onConfirm,
          child: Text(t.notifications.confirm),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          t.user.blocked_tags,
        ),
        actions: [
          AddTagPage(
            onConfirm: controller.onAddTag,
          ),
          IconButton(
            onPressed: () {
              if (controller.whetherAddTag()) {
                Get.dialog(_buildConfirmDialog(
                  context,
                  title: t.notifications.confirm,
                  content: t.message.blocked_tags.save_confirm,
                  onConfirm: () {
                    controller.save();
                  },
                ));
              } else {
                SmartDialog.showToast(t.message.blocked_tags.reached_limit);
              }
            },
            icon: const Icon(
              Icons.save,
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
                  title: Text(controller.blockedTags[index]),
                ),
              );
            },
          ),
          onLoading: const Center(child: CircularProgressIndicator()),
          onEmpty: const Center(child: LoadEmpty()),
          onError: (error) {
            return Center(
              child: LoadFail(
                onRefresh: controller.loadData,
                errorMessage: error!.toString(),
              ),
            );
          },
        ),
      ),
    );
  }
}
