import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'repository.dart';

class AddTagController extends GetxController {
  final AddTagRepository repository = AddTagRepository();

  final GlobalKey tagsBoxKey = GlobalKey();

  final TextEditingController tagEditingController = TextEditingController();
  final GlobalKey tagEditingControllerKey = GlobalKey();
  final FocusNode tagFocusNode = FocusNode();

  final RxList<String> _selectedTags = <String>[].obs;
  List<String> get selectedTags => _selectedTags.toList();

  Future<List<String>> autoCompleteTags(String keyword) async {
    try {
      return await repository.autoCompleteTags(keyword).then((value) {
        return value.map((e) => e.id).toList();
      });
    } catch (e) {
      return [];
    }
  }

  void addTag(String tag) {
    if (selectedTags.contains(tag)) {
      return;
    }
    selectedTags.add(tag);
    update();
  }

  void removeTag(String tag) {
    selectedTags.remove(tag);
    update();
  }
}
