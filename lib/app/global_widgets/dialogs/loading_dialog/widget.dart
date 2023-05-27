import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import '../../iwr_progress_indicator.dart';
import 'controller.dart';

class LoadingDialog extends GetWidget<LoadingDialogController> {
  final Function() task;
  final Function()? onSuccess;
  final Function()? onFail;
  final String? successMessage;
  final String? errorMessage;

  const LoadingDialog({
    Key? key,
    required this.task,
    this.successMessage,
    this.errorMessage,
    this.onSuccess,
    this.onFail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.init(task);

    return controller.obx(
      (_) => AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          L10n.of(context).success,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(successMessage ?? "Success"),
        contentPadding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
        actionsAlignment: MainAxisAlignment.end,
        actionsPadding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
        actions: [
          CupertinoButton(
            onPressed: () {
              Get.back();
              onSuccess?.call();
            },
            child: Text(
              L10n.of(context).ok,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
        ],
      ),
      onLoading: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            width: 150,
            height: 150,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(top: 5, bottom: 15),
                  child: const IwrProgressIndicator(),
                ),
                Text(
                  L10n.of(context).loading,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onError: (error) => AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          L10n.of(context).error,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(errorMessage ?? error ?? "Unknow error"),
        contentPadding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
        actionsAlignment: MainAxisAlignment.end,
        actionsPadding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
        actions: [
          CupertinoButton(
            onPressed: () {
              Get.back();
              onFail?.call();
            },
            child: Text(
              L10n.of(context).ok,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
