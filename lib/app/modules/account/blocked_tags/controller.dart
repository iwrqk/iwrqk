import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:iwrqk/i18n/strings.g.dart';

import '../../../data/services/user_service.dart';

class BlockedTagsController extends GetxController with StateMixin {
  final UserService _userService = Get.find<UserService>();

  final RxList<String> _blockedTags = <String>[].obs;
  List<String> get blockedTags => _blockedTags.toList();

  bool whetherAddTag() {
    bool isPremium = _userService.user?.premium ?? false;

    return isPremium ? _blockedTags.length <= 16 : _blockedTags.length <= 8;
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() async {
    change(null, status: RxStatus.loading());
    try {
      await _userService.getUser();
      _blockedTags.value = _userService.blockedTags.map((e) => e.id).toList();

      if (_blockedTags.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(null, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void onAddTag(List<String> tags) {
    for (var tag in tags) {
      if (!_blockedTags.contains(tag)) {
        _blockedTags.add(tag);
      }
    }
    change(null, status: RxStatus.success());
  }

  Future<void> save() async {
    await _userService.saveBlockedTags(_blockedTags).then((value) {
      if (value) {
        SmartDialog.showToast(t.message.blocked_tags.saved);
        Get.back();
      }
    });
  }

  void unblockTag(int index) {
    _blockedTags.removeAt(index);
    if (_blockedTags.isEmpty) {
      change(null, status: RxStatus.empty());
    } else {
      change(null, status: RxStatus.success());
    }
  }
}
