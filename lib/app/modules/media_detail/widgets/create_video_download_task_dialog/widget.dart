import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../l10n.dart';
import '../../../../data/models/offline/offline_meida.dart';
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
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        L10n.of(context).create_download_task,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: resolutions.length,
          itemBuilder: (context, index) {
            return Obx(
              () => RadioListTile(
                value: index,
                title: Text(resolutions[index].name),
                activeColor: Theme.of(context).primaryColor,
                groupValue: controller.currentResolutionIndex,
                onChanged: (_) {
                  controller.currentResolutionIndex = index;
                },
              ),
            );
          },
        ),
      ),
      contentPadding: const EdgeInsets.only(top: 15),
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
      actions: [
        Obx(
          () => CupertinoButton(
            onPressed: controller.creatingDownloadTask
                ? null
                : () {
                    controller.createVideoDownloadTask(
                      L10n.of(context).message_playlist_created,
                    );
                  },
            child: Text(
              L10n.of(context).confirm,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        )
      ],
    );
  }
}
