import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../../data/models/tag.dart';
import '../../../data/services/user_service.dart';

class BlockedTagsController extends GetxController with StateMixin {
  final UserService _userService = Get.find<UserService>();

  final RxList<TagModel> _blockedTags = <TagModel>[].obs;
  List<TagModel> get blockedTags => _blockedTags.toList();

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
      _blockedTags.value = _userService.blockedTags.toList();

      if (_blockedTags.isEmpty) {
        change(null, status: RxStatus.empty());
      } else {
        change(null, status: RxStatus.success());
      }
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void onAddTag(TagModel tag) {
    if (_blockedTags.contains(tag)) {
      return;
    }
    _blockedTags.add(tag);
    change(null, status: RxStatus.success());
  }

  Future<void> save(String saveMessage) async {
    await _userService.saveBlockedTags(_blockedTags).then((value) {
      if (value) {
        showToast(saveMessage);
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
