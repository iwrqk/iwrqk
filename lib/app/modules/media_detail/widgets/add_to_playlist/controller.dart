import 'package:get/get.dart';

import '../../../../components/dialogs/edit_playlis_dialog/widget.dart';
import '../../../../data/models/playlist/light_playlist.dart';
import '../../../../data/services/user_service.dart';

class AddToPlaylistBottomSheetController extends GetxController
    with StateMixin {
  final UserService userService = Get.find();
  late String _videoId;

  final RxBool _addingtoPlaylist = false.obs;

  bool get addingtoPlaylist => _addingtoPlaylist.value;

  final RxList<LightPlaylistModel> _data = <LightPlaylistModel>[].obs;

  List<LightPlaylistModel> get data => _data;

  final RxList<String> _selectedPlaylists = <String>[].obs;

  List<String> get selectedPlaylists => _selectedPlaylists;

  @override
  void onInit() {
    super.onInit();
    change(null, status: RxStatus.loading());
  }

  void init(String videoId) {
    _videoId = videoId;
    loadData().then((value) => null);
  }

  Future<void> refreshData() async {
    change(null, status: RxStatus.loading());

    await loadData();
  }

  Future<void> loadData() async {
    bool success = false;

    if (!userService.accountService.isLogin) {
      change("requireLogin", status: RxStatus.success());
      return;
    }

    await userService.getLightPlaylists(_videoId).then((value) {
      success = value.success;
      if (value.success) {
        _data.value = value.data!;
        for (var item in _data) {
          if (item.added == true) {
            selectedPlaylists.add(item.id);
          }
        }
      } else {
        change(null, status: RxStatus.error(value.message!));
      }
    });

    if (success == false) return;

    if (_data.isNotEmpty) {
      change(null, status: RxStatus.success());
    } else {
      change(null, status: RxStatus.empty());
    }
  }

  Future<void> renewPlaylist() async {
    bool success = true;

    _addingtoPlaylist.value = true;

    if (selectedPlaylists.isNotEmpty) {
      await userService
          .addToPlaylist(_videoId, selectedPlaylists)
          .then((value) {
        success = value;
      });
    }

    if (success == false) {
      _addingtoPlaylist.value = false;
      return;
    }

    List<String> previousPlaylistsAddedto = _data
        .where((element) => element.added == true)
        .map((e) => e.id)
        .toList();

    List<String> playlistsNeedtoRemove = previousPlaylistsAddedto
        .where((element) => !selectedPlaylists.contains(element))
        .toList();

    if (playlistsNeedtoRemove.isNotEmpty) {
      await userService
          .removeFromPlaylist(_videoId, playlistsNeedtoRemove)
          .then((value) {
        success = value;
      });
    }

    if (success) {
      Get.back();
    }

    _addingtoPlaylist.value = false;
  }

  Future<void> showCreatePlaylistDialog() async {
    if (!userService.accountService.isLogin) {
      return;
    }
    Get.dialog(
      EditPlaylistDialog(
        onChanged: () {
          refreshData();
        },
      ),
    );
  }
}
