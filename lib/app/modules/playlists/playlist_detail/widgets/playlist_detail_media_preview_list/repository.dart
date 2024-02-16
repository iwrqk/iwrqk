import '../../../../../data/enums/result.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../data/models/media/media.dart';
import '../../../../../data/providers/api_provider.dart';

class PlaylistDetailMediaPreviewListRepository {
  PlaylistDetailMediaPreviewListRepository();

  Future<GroupResult<MediaModel>> getPlaylistMedia({
    required String playlistId,
    required int currentPage,
  }) {
    return ApiProvider.getMedia(
      path: "/playlist/$playlistId",
      queryParameters: {"page": currentPage},
      type: MediaType.video,
    ).then((value) {
      List<MediaModel> previews = [];
      int count = 0;

      if (value.success) {
        previews = value.data!.results;
        count = value.data!.count;
      } else {
        throw Exception(value.message);
      }

      return GroupResult(results: previews, count: count);
    });
  }
}
