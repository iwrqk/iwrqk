import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import '../../../../../components/iwr_refresh/controller.dart';
import '../../../../../data/enums/result.dart';
import '../../../../../data/models/media/media.dart';
import '../../../../../data/services/user_service.dart';
import 'repository.dart';

class PlatlistDetailMediaPreviewListController
    extends IwrRefreshController<MediaModel> {
  final PlaylistDetailMediaPreviewListRepository repository =
      PlaylistDetailMediaPreviewListRepository();
  final UserService _userService = Get.find();
  late String _playlistId;

  void initConfig(String playlistId) {
    _playlistId = playlistId;
  }

  Future<void> removeFromPlaylist(String successMessage, int index) async {
    await _userService
        .removeFromPlaylist(data[index].id, [_playlistId]).then((value) {
      if (value) {
        SmartDialog.showToast(successMessage);
        data.removeAt(index);
      }
    });
  }

  @override
  Future<GroupResult<MediaModel>> getNewData(int currentPage) {
    return repository.getPlaylistMedia(
      currentPage: currentPage,
      playlistId: _playlistId,
    );
  }
}
