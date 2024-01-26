import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import 'controller.dart';

class AddTagPage extends GetWidget<AddTagController> {
  final void Function(List<String> tags) onConfirm;
  const AddTagPage({super.key, required this.onConfirm});

  Widget _buildTagAutocomplete(BuildContext context) {
    return RawAutocomplete<String>(
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
        return Container(
          key: controller.tagEditingControllerKey,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.fromLTRB(4, 6, 16, 6),
          child: Theme(
            data: Theme.of(context).brightness == Brightness.light
                ? ThemeData.light()
                : ThemeData.dark(),
            child: TextFormField(
              controller: textEditingController,
              focusNode: focusNode,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return t.message.please_type_host;
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: t.filter.tag,
                border: InputBorder.none,
              ),
            ),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
        RenderBox inputRenderBox = controller
            .tagEditingControllerKey.currentContext!
            .findRenderObject() as RenderBox;
        RenderBox tagsRenderBox = controller.tagsBoxKey.currentContext!
            .findRenderObject() as RenderBox;

        return Transform.translate(
          offset: const Offset(0, -12),
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: inputRenderBox.size.width,
              height: options.length * 56 + 10,
              constraints: BoxConstraints(
                  maxHeight: tagsRenderBox.size.height -
                      inputRenderBox.size.height -
                      32),
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
                color: Theme.of(context).colorScheme.secondaryContainer,
                clipBehavior: Clip.antiAlias,
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return InkWell(
                        onTap: () {
                          onSelected.call(option);
                          controller.addTag(option);
                        },
                        child: ListTile(
                          title: Text(option),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagClip(BuildContext context, int index) {
    String tag = controller.selectedTags[index];

    return InputChip(
      label: Text(
        tag,
      ),
      onDeleted: () {
        controller.removeTag(tag);
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.blocked_tags.add_blocked_tag),
        actions: [
          TextButton(
            onPressed: () {
              List<String> tags = controller.selectedTags;

              if (tags.isNotEmpty) {
                onConfirm(tags);
              }

              Get.back();
            },
            child: Text(t.notifications.confirm),
          ),
        ],
      ),
      body: SingleChildScrollView(
        key: controller.tagsBoxKey,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildTagAutocomplete(context),
            Obx(
              () => Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    controller.selectedTags.length,
                    (index) => _buildTagClip(context, index),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      openElevation: 0,
      openColor: Theme.of(context).colorScheme.background,
      middleColor: Theme.of(context).colorScheme.background,
      closedColor: Theme.of(context).colorScheme.background,
      closedShape: const CircleBorder(),
      closedBuilder: (context, action) {
        return IconButton(
          onPressed: action,
          icon: const Icon(
            Icons.add,
          ),
        );
      },
      openShape: Border.all(color: Colors.transparent),
      openBuilder: (context, action) {
        return _buildContent(context);
      },
    );
  }
}
