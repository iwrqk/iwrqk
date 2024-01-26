import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/providers/storage_provider.dart';

class ProxyDialog extends StatelessWidget {
  ProxyDialog({Key? key}) : super(key: key);

  final FocusNode blankNode = FocusNode();
  final FocusNode focusNode = FocusNode();

  final TextEditingController hostController = TextEditingController();
  final TextEditingController portController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    String? lastHost = StorageProvider.config[StorageKey.proxyHost];
    String? lastPort = StorageProvider.config[StorageKey.proxyPort];

    hostController.text = lastHost ?? "";
    portController.text = lastPort ?? "";

    return AlertDialog(
      title: Text(t.settings.proxy),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Theme(
                data: Theme.of(context).brightness == Brightness.light
                    ? ThemeData.light()
                    : ThemeData.dark(),
                child: TextFormField(
                  controller: hostController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.message.please_type_host;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: t.proxy.host,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Theme(
                data: Theme.of(context).brightness == Brightness.light
                    ? ThemeData.light()
                    : ThemeData.dark(),
                child: TextFormField(
                  controller: portController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.message.please_type_port;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: t.proxy.port,
                    border: InputBorder.none,
                  ),
                  focusNode: focusNode,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            Get.back();
          },
          child: Text(
            t.notifications.cancel,
            style: TextStyle(color: Theme.of(context).colorScheme.outline),
          ),
        ),
        TextButton(
          onPressed: () async {
            FocusScope.of(context).requestFocus(blankNode);
            if (formKey.currentState!.validate()) {
              String host = hostController.text;
              String port = portController.text;
              StorageProvider.config[StorageKey.proxyHost] = host;
              StorageProvider.config[StorageKey.proxyPort] = port;
              SmartDialog.showToast(t.message.restart_required);
              HapticFeedback.mediumImpact();
              Get.back();
            }
          },
          child: Text(t.notifications.confirm),
        )
      ],
    );
  }
}
