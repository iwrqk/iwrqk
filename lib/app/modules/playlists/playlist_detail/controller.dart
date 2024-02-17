import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';
import '../../../data/services/user_service.dart';
import 'widgets/playlist_detail_media_preview_list/controller.dart';

class PlaylistDetailController extends GetxController {
  final UserService _userService = Get.find();

  late String playlistId;
  late bool requireMyself;
  late String? title;

  late PlaylistDetailMediaPreviewListController childController;

  final RxBool _enableMultipleSelection = false.obs;
  bool get enableMultipleSelection => _enableMultipleSelection.value;
  set enableMultipleSelection(bool value) =>
      _enableMultipleSelection.value = value;

  List checkedList = [];

  final RxInt _checkedCount = 0.obs;
  int get checkedCount => _checkedCount.value;
  set checkedCount(int value) => _checkedCount.value = value;

  late String listTag;

  @override
  void onInit() {
    super.onInit();

    playlistId = Get.parameters["playlistId"]!;
    requireMyself = Get.parameters["requireMyself"] != null &&
        Get.parameters["requireMyself"] == "true";
    title = Get.arguments["title"];

    listTag = "playlist_detail_media_preview_list_$playlistId";

    Get.lazyPut(() => PlaylistDetailMediaPreviewListController(), tag: listTag);
  }

  void toggleChecked(String id, [bool all = false]) {
    if (checkedList.contains(id)) {
      checkedList.remove(id);
      checkedCount--;
    } else {
      checkedList.add(id);
      checkedCount++;
    }
    update();
  }

  void toggleCheckedAll() {
    childController.toggleCheckedAll();
    update();
  }

  Future<void> removeFromPlaylist(String id) async {
    await _userService.removeFromPlaylist(id, [playlistId]);
  }

  Future<void> removeAllFromPlaylist() async {
    childController.showLoading();
    await childController.removeAllFromPlaylist();
  }

  void deleteChecked() async {
    childController.showLoading();
    for (String id in checkedList) {
      await removeFromPlaylist(id);
    }
    checkedList.clear();
    checkedCount = 0;
    await refreshPlaylist();
  }

  Future<void> refreshPlaylist() async {
    childController.refreshData(showSplash: true);
  }

  Future<String?> getPlaylistName() {
    return ApiProvider.getPlaylistName(playlistId: playlistId).then((value) {
      if (value.success) {
        return value.data;
      }
      return null;
    });
  }
}
