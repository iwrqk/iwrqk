import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/history_media_preview_list/controller.dart';
import '../widgets/history_media_preview_list/widget.dart';

class HistorySearchPage extends StatefulWidget {
  const HistorySearchPage({super.key});

  @override
  State<HistorySearchPage> createState() => _HistorySearchPageState();
}

class _HistorySearchPageState extends State<HistorySearchPage> {
  static const String listTag = "search_history_list";

  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController textEditingController = TextEditingController();
  RxString searchKeyWord = ''.obs;

  @override
  void initState() {
    super.initState();
    Get.put(HistoryMediaPreviewListController(), tag: listTag);
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  void _submit() {
    if (textEditingController.text.isNotEmpty) {
      searchKeyWord.value = textEditingController.text;
    }
  }

  void _onClear() {
    if (searchKeyWord.value.isNotEmpty && textEditingController.text != '') {
      textEditingController.clear();
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () => _submit(),
            icon: const Icon(Icons.search_outlined, size: 22),
          ),
          const SizedBox(width: 10)
        ],
        title: TextField(
          autofocus: true,
          focusNode: searchFocusNode,
          controller: textEditingController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                size: 22,
                color: Theme.of(context).colorScheme.outline,
              ),
              onPressed: () => _onClear(),
            ),
          ),
          onSubmitted: (String value) => _submit(),
        ),
      ),
      body: Obx(
        () => HistoryMediaPreviewList(
          tag: listTag,
          keyword: searchKeyWord.value,
        ),
      ),
    );
  }
}
