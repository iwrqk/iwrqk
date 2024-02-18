import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

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
        title: Text(t.notifications.success),
        content: Text(successMessage ?? t.notifications.success),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              onSuccess?.call();
            },
            child: Text(
              t.notifications.ok,
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
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.only(top: 5, bottom: 15),
                  child: const CircularProgressIndicator(),
                ),
                Text(
                  t.notifications.loading,
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
        title: Text(t.notifications.error),
        content: Text(errorMessage ?? error ?? "Unknow error"),
        actionsAlignment: MainAxisAlignment.end,
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              onFail?.call();
            },
            child: Text(
              t.notifications.ok,
            ),
          ),
        ],
      ),
    );
  }
}
