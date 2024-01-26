import '../../../../../components/iwr_refresh/controller.dart';
import '../../../../../data/enums/result.dart';
import '../../../../../data/models/playlist/playlist.dart';
import 'repository.dart';

class PlaylistsPreviewListController
    extends IwrRefreshController<PlaylistModel> {
  final PlaylistsPreviewListRepository repository =
      PlaylistsPreviewListRepository();

  late String _userId;
  bool _requireMyself = false;

  void initConfig(String userId, bool requireMyself) {
    _userId = userId;
    _requireMyself = requireMyself;
  }

  @override
  Future<GroupResult<PlaylistModel>> getNewData(int currentPage) {
    return repository.getPlaylists(userId: _userId, currentPage: currentPage);
  }

  void deletePlaylist(int index) {
    if (_requireMyself) data.removeAt(index);
  }
}
