import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../../data/models/tag.dart';
import 'repository.dart';

class AddTagDialogController extends GetxController {
  final AddTagRepository repository = AddTagRepository();

  final TextEditingController tagEditingController = TextEditingController();
  final GlobalKey tagEditingControllerKey = GlobalKey();
  final FocusNode tagFocusNode = FocusNode();

  List<TagModel> candidateTags = [];

  Future<List<String>> autoCompleteTags(String keyword) async {
    try {
      return await repository.autoCompleteTags(keyword).then((value) {
        candidateTags = value;
        return value.map((e) => e.id).toList();
      });
    } catch (e) {
      return [];
    }
  }

  TagModel? getSelectedTag() {
    final String tag = tagEditingController.text.trim();

    if (tag.isEmpty) {
      return null;
    }

    return candidateTags.firstWhere(
      (element) => element.id == tag,
    );
  }
}
