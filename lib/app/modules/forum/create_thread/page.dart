import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../l10n.dart';
import 'controller.dart';

class CreateThreadPage extends GetView<CreateThreadController> {
  const CreateThreadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const FaIcon(FontAwesomeIcons.chevronLeft),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 0,
          ),
        ),
        centerTitle: true,
        title: Text(
          L10n.of(context).thread,
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(left: 10, top: 20, bottom: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  L10n.of(context).title,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Theme(
                  data: Theme.of(context).brightness == Brightness.light
                      ? ThemeData.light()
                      : ThemeData.dark(),
                  child: TextFormField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, top: 20, bottom: 5),
                alignment: Alignment.centerLeft,
                child: Text(
                  L10n.of(context).content,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                  child: Theme(
                    data: Theme.of(context).brightness == Brightness.light
                        ? ThemeData.light()
                        : ThemeData.dark(),
                    child: TextFormField(
                      controller: controller.contentController,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      expands: true,
                      maxLines: null,
                      maxLength: 20000,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.createThread(
                      L10n.of(context).message_cannot_be_empty(L10n.of(context).title),
                      L10n.of(context).message_cannot_be_empty(L10n.of(context).content),
                    );
                  },
                  child: Text(L10n.of(context).create),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
