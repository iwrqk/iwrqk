import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../l10n.dart';
import '../../core/const/config.dart';

class NotifyUpdateDialog extends StatelessWidget {
  final bool isForce;

  const NotifyUpdateDialog({Key? key, required this.isForce}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        L10n.of(context).update_available,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(L10n.of(context).message_update_available),
      actions: [
        if (!isForce)
          CupertinoButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(L10n.of(context).cancel),
          ),
        CupertinoButton(
          onPressed: () {
            launchUrlString(ConfigConst.updateUrl);
          },
          child: Text(L10n.of(context).ok),
        ),
      ],
    );
  }
}
