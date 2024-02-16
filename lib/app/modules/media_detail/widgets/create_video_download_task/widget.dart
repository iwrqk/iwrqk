import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../../data/models/offline/offline_media.dart';
import '../../../../data/models/resolution.dart';
import 'controller.dart';

class CreateVideoDownloadDialog
    extends GetWidget<CreateVideoDownloadDialogController> {
  final List<ResolutionModel> resolutions;
  final OfflineMediaModel previewData;

  const CreateVideoDownloadDialog({
    Key? key,
    required this.resolutions,
    required this.previewData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.init(resolutions, previewData);

    return AlertDialog(
      title: Text(t.download.create_download_task),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      content: Container(
        width: Get.width * 0.8,
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: resolutions.length,
          itemBuilder: (context, index) {
            return Obx(
              () => RadioListTile(
                value: index,
                title: Text(resolutions[index].name),
                groupValue: controller.currentResolutionIndex,
                onChanged: (_) {
                  controller.currentResolutionIndex = index;
                },
              ),
            );
          },
        ),
      ),
      actions: [
        Obx(
          () => TextButton(
            onPressed: controller.creatingDownloadTask
                ? null
                : () {
                    Get.back();
                  },
            child: Text(
              t.notifications.cancel,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
            ),
          ),
        ),
        Obx(
          () => TextButton(
            onPressed: controller.creatingDownloadTask
                ? null
                : () {
                    controller.createVideoDownloadTask();
                  },
            child: Text(t.notifications.confirm),
          ),
        )
      ],
    );
  }
}
