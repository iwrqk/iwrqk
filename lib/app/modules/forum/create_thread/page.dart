import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import 'controller.dart';

class CreateThreadPage extends GetView<CreateThreadController> {
  const CreateThreadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(t.create_thread.create_thread),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 8, bottom: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  t.create_thread.title,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .secondaryContainer
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Theme(
                  data: Theme.of(context).brightness == Brightness.light
                      ? ThemeData.light()
                      : ThemeData.dark(),
                  child: TextFormField(
                    controller: controller.titleController,
                    decoration: const InputDecoration(
                        border: InputBorder.none, isDense: true),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  t.create_thread.content,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondaryContainer
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Theme(
                    data: Theme.of(context).brightness == Brightness.light
                        ? ThemeData.light()
                        : ThemeData.dark(),
                    child: TextFormField(
                      controller: controller.contentController,
                      decoration: const InputDecoration(
                          border: InputBorder.none, isDense: true),
                      expands: true,
                      maxLines: null,
                      maxLength: 20000,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 16, bottom: Get.mediaQuery.padding.bottom + 16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    controller.createThread();
                  },
                  child: Text(t.notifications.confirm),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
