import '../../../../../data/enums/result.dart';
import '../../../../../data/models/playlist/playlist.dart';
import '../../../../../data/providers/network/api_provider.dart';

class PlaylistsPreviewListRepository {
  PlaylistsPreviewListRepository();

  Future<GroupResult<PlaylistModel>> getPlaylists({
    required String userId,
    required currentPage,
  }) {
    return ApiProvider.getPlaylists(userId: userId, pageNum: currentPage)
        .then((value) {
      List<PlaylistModel> playlists = [];
      int count = 0;

      if (value.success) {
        playlists = value.data!.results;
        count = value.data!.count;
      } else {
        throw Exception(value.message);
      }

      return GroupResult(results: playlists, count: count);
    });
  }
}
