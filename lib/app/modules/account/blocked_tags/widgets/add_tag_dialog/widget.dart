import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../l10n.dart';
import '../../../../../data/models/tag.dart';
import 'controller.dart';

class AddTagDialog extends GetWidget<AddTagDialogController> {
  final void Function(TagModel tag) onConfirm;
  const AddTagDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        L10n.of(context).add_tag,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: RawAutocomplete<String>(
        focusNode: controller.tagFocusNode,
        textEditingController: controller.tagEditingController,
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return controller.autoCompleteTags(textEditingValue.text);
        },
        onSelected: (String selection) {
          controller.tagEditingController.text = selection;
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            key: controller.tagEditingControllerKey,
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              hintText: L10n.of(context).tag,
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
          );
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options) {
          RenderBox renderBox = controller
              .tagEditingControllerKey.currentContext!
              .findRenderObject() as RenderBox;

          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
              elevation: 4,
              child: SizedBox(
                width: renderBox.size.width,
                height: options.length < 5
                    ? options.length * 55
                    : MediaQuery.of(context).size.height / 3,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return GestureDetector(
                      onTap: () {
                        onSelected(option);
                      },
                      child: ListTile(
                        title: Text(option),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
      contentPadding: const EdgeInsets.fromLTRB(30, 15, 30, 0),
      actionsAlignment: MainAxisAlignment.end,
      actionsPadding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      actions: [CupertinoButton(
            onPressed: () {
              TagModel? tag = controller.getSelectedTag();
              if (tag != null) {
                onConfirm(tag);
              }

              Get.back();
            },
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
}
