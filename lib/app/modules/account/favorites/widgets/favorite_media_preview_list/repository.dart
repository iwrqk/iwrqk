import '../../../../../data/enums/result.dart';
import '../../../../../data/enums/types.dart';
import '../../../../../data/models/media/media.dart';
import '../../../../../data/providers/api_provider.dart';

class FavoriteMediaPreviewListRepository {
  FavoriteMediaPreviewListRepository();

  Future<GroupResult<MediaModel>> getPlaylistMedias({
    required MediaType type,
    required int currentPage,
  }) {
    return ApiProvider.getFavoriteMedia(
      currentPage: currentPage,
      type: type,
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
